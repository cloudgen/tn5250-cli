#!/bin/sh
# Proves the build board, the dash glibc parse, clean on a private prefix,
# and the committed download/ client. Does not compile. Does not call sudo.
# Does not remove the login prefix or the shared cache.

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
CLI="${ROOT}/src/tn5250-cli"
FAIL=0

say() { printf '%s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1" >&2; FAIL=1; }
ok() { printf 'ok %s\n' "$1"; }

if ! sh -n "${CLI}"; then
    bad "sh -n"
else
    ok "sh -n"
fi

ABOUT=$(${CLI} about --json 2>/dev/null) || ABOUT=""
CLIB=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_clib":"\([^"]*\)".*/\1/p')
case "${CLIB}" in
    glibc-*) ok "about clib ${CLIB}" ;;
    *) bad "about clib ${CLIB}" ;;
esac

VER=$(${CLI} version 2>/dev/null) || VER=""
case "${VER}" in
    *"version 1.2.0"*) ok "version 1.2.0" ;;
    *) bad "version ${VER}" ;;
esac

HELP=$(${CLI} build -h 2>&1) || true
case "${HELP}" in
    *local*) ok "help local" ;;
    *) bad "help local" ;;
esac
case "${HELP}" in
    *global*) ok "help global" ;;
    *) bad "help global" ;;
esac
case "${HELP}" in
    *clean*) ok "help clean" ;;
    *) bad "help clean" ;;
esac
case "${HELP}" in
    *download/*) ok "help download" ;;
    *) bad "help download" ;;
esac

if ${CLI} build nosuch >/tmp/tn5250-build-nosuch.out 2>/tmp/tn5250-build-nosuch.err; then
    bad "build nosuch exited 0"
else
    ERR=$(cat /tmp/tn5250-build-nosuch.err /tmp/tn5250-build-nosuch.out 2>/dev/null)
    case "${ERR}" in
        *"build --help"*) ok "build nosuch names help" ;;
        *) bad "build nosuch text" ;;
    esac
fi
/bin/rm -f /tmp/tn5250-build-nosuch.out /tmp/tn5250-build-nosuch.err

python3 - "${CLI}" <<'PY'
import os, pty, select, sys
cli = sys.argv[1]
pid, fd = pty.fork()
if pid == 0:
    os.execv(cli, [cli])
buf = b""
want = [
    b"11",
    b"clean",
    b"12",
    b"local",
    b"13",
    b"global",
    b"is not on this list",
]
steps = [b"1\n", b"nosuch\n", b"0\n", b"9\n"]
step = 0
prompts = 0
while True:
    r, _, _ = select.select([fd], [], [], 8)
    if not r:
        sys.stderr.write("timeout waiting for menu\n")
        os.kill(pid, 15)
        sys.exit(1)
    try:
        chunk = os.read(fd, 4096)
    except OSError:
        break
    if not chunk:
        break
    buf += chunk
    if b"Choose a number" in buf and step < len(steps):
        # Wait until the prompt is the latest text, then send one line.
        if buf.endswith(b": ") or buf.rstrip().endswith(b":"):
            os.write(fd, steps[step])
            step += 1
            prompts += 1
            # Drop the consumed prompt marker so the next one is new.
            buf = buf.replace(b"Choose a number, or type the command name: ", b"", 1)
_, status = os.waitpid(pid, 0)
text = buf.decode("utf-8", "replace")
code = os.waitstatus_to_exitcode(status) if hasattr(os, "waitstatus_to_exitcode") else (status >> 8)
missing = [w.decode() for w in want if w not in text.encode()]
# want was checked against original stream; re-read from the child output we kept after replacements.
# The replacements removed prompts only. The board text stays.
if code != 0:
    sys.stderr.write("menu exit %s\n" % code)
    sys.exit(1)
# The loop replaced prompt strings inside buf, so board text remains.
raw = text
for w in ("11", "12", "13", "clean", "local", "global", "is not on this list"):
    if w not in raw:
        sys.stderr.write("missing %s\n" % w)
        sys.exit(1)
if prompts < 4:
    sys.stderr.write("prompts %s\n" % prompts)
    sys.exit(1)
sys.exit(0)
PY
if [ $? -eq 0 ]; then
    ok "build board pty"
else
    bad "build board pty"
fi

TMP=$(mktemp -d) || exit 1
trap '/bin/rm -rf "${TMP}"' EXIT
mkdir -p "${TMP}/prefix/opt/tn5250" "${TMP}/cache/tn5250/build" "${TMP}/keep"
printf 'client\n' > "${TMP}/prefix/opt/tn5250/tn5250"
printf 'cache\n' > "${TMP}/cache/tn5250/build/CMakeCache.txt"
printf 'src\n' > "${TMP}/cache/tn5250/src-marker"
printf 'keep\n' > "${TMP}/keep/download-standin"
if XDG_CACHE_HOME="${TMP}/cache" "${CLI}" build clean --prefix "${TMP}/prefix" >"${TMP}/clean.out" 2>"${TMP}/clean.err"; then
    ok "clean exit 0"
else
    bad "clean exit"
fi
if [ -e "${TMP}/prefix/opt/tn5250" ]; then
    bad "clean left opt/tn5250"
else
    ok "clean removed opt/tn5250"
fi
if [ -e "${TMP}/cache/tn5250/build" ]; then
    bad "clean left cache/build"
else
    ok "clean removed cache/build"
fi
if [ -f "${TMP}/cache/tn5250/src-marker" ]; then
    ok "clean kept source cache marker"
else
    bad "clean removed source cache marker"
fi
if [ -f "${ROOT}/download/index.txt" ]; then
    ok "clean left download/index.txt"
else
    bad "clean removed download/index.txt"
fi

NAME="tn5250-amd64-glibc-2.34.1.2.0"
BIN="${ROOT}/download/${NAME}"
if [ -x "${BIN}" ]; then
    ok "download executable"
else
    bad "download executable"
fi
SUM=$(sha256sum "${BIN}" | awk '{ print $1 }')
FILESUM=$(tr -d '\r\n' < "${BIN}.sha256")
if [ "${SUM}" = "${FILESUM}" ]; then
    ok "download sha256"
else
    bad "download sha256"
fi
if grep -qx "${NAME}" "${ROOT}/download/index.txt"; then
    ok "download index"
else
    bad "download index"
fi
HIGH=$(objdump -T "${BIN}" 2>/dev/null | grep -oE 'GLIBC_[0-9]+\.[0-9]+' | sed 's/^GLIBC_//' | sort -Vu | tail -n 1)
if [ "${HIGH}" = "2.34" ]; then
    ok "highest symbol GLIBC_${HIGH}"
else
    bad "highest symbol GLIBC_${HIGH}"
fi

if [ "${FAIL}" -ne 0 ]; then
    say "FAILED"
    exit 1
fi
say "ok"
exit 0
