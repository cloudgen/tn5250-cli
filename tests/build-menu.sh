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

# /bin/rm is Android toybox. A Termux login rewrites it and prints a quote error.
test_rm_rf() {
    if command -v coreutils >/dev/null 2>&1; then
        coreutils --coreutils-prog=rm -rf -- "$@"
    else
        rm -rf "$@"
    fi
}

if ! sh -n "${CLI}"; then
    bad "sh -n"
else
    ok "sh -n"
fi

ABOUT=$(${CLI} about --json 2>/dev/null) || ABOUT=""
CLIB=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_clib":"\([^"]*\)".*/\1/p')
case "${CLIB}" in
    bionic-*|glibc-*|musl-*|uclibc-*|ucrt-*) ok "about clib ${CLIB}" ;;
    *) bad "about clib ${CLIB}" ;;
esac
if [ -n "${TERMUX_VERSION:-}" ]; then
    case "${CLIB}" in
        bionic-30) ok "termux clib ${CLIB}" ;;
        *) bad "termux clib ${CLIB}" ;;
    esac
fi

VER=$(${CLI} version 2>/dev/null) || VER=""
case "${VER}" in
    *"version 1.2.3"*) ok "version 1.2.3" ;;
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
case "${HELP}" in
    *"not available"*) ok "help not available" ;;
    *) bad "help not available" ;;
esac

NOSUCH=$(mktemp -d) || exit 1
if ${CLI} build nosuch >"${NOSUCH}/out" 2>"${NOSUCH}/err"; then
    bad "build nosuch exited 0"
else
    ERR=$(cat "${NOSUCH}/err" "${NOSUCH}/out" 2>/dev/null)
    case "${ERR}" in
        *"build --help"*) ok "build nosuch names help" ;;
        *) bad "build nosuch text" ;;
    esac
fi
test_rm_rf "${NOSUCH}"

python3 - "${CLI}" <<'PY'
import os, pty, select, sys
cli = sys.argv[1]
pid, fd = pty.fork()
if pid == 0:
    env = os.environ.copy()
    env.pop("TERMUX_VERSION", None)
    os.execve(cli, [cli], env)
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

python3 - "${CLI}" <<'PY'
import os, pty, select, sys
cli = sys.argv[1]
pid, fd = pty.fork()
if pid == 0:
    env = os.environ.copy()
    env["TERMUX_VERSION"] = "1"
    os.execve(cli, [cli], env)
allb = b""
buf = b""
steps = [b"1\n", b"13\n", b"global\n", b"0\n", b"9\n"]
step = 0
prompts = 0
prompt = b"Choose a number, or type the command name: "
while True:
    ready, _, _ = select.select([fd], [], [], 8)
    if not ready:
        sys.stderr.write("timeout termux menu\n")
        os.kill(pid, 15)
        sys.exit(1)
    try:
        chunk = os.read(fd, 4096)
    except OSError:
        break
    if not chunk:
        break
    allb += chunk
    buf += chunk
    if prompt in buf and step < len(steps) and (buf.endswith(b": ") or buf.rstrip().endswith(b":")):
        os.write(fd, steps[step])
        step += 1
        prompts += 1
        buf = buf.replace(prompt, b"", 1)
_, status = os.waitpid(pid, 0)
text = allb.decode("utf-8", "replace")
code = os.waitstatus_to_exitcode(status) if hasattr(os, "waitstatus_to_exitcode") else (status >> 8)
if code != 0:
    sys.stderr.write("termux menu exit %s\n" % code)
    sys.exit(1)
need = (
    "Global is not available on Termux.",
    "Local uses the login prefix.",
    "Local copies the named client into download/.",
    "Clean, or install the client for this login",
    "is not on this list",
)
for word in need:
    if word not in text:
        sys.stderr.write("missing %s\n" % word)
        sys.exit(1)
forbid = (
    "Build install (global)",
    "Global uses /usr/local",
    "for every login",
    "Scope:",
)
for word in forbid:
    if word in text:
        sys.stderr.write("unexpected %s\n" % word)
        sys.exit(1)
if prompts < 5 or text.count("is not on this list") < 2:
    sys.stderr.write("prompts %s retries %s\n" % (prompts, text.count("is not on this list")))
    sys.exit(1)
sys.exit(0)
PY
if [ $? -eq 0 ]; then
    ok "termux build board omits global"
else
    bad "termux build board omits global"
fi

TMP=$(mktemp -d) || exit 1
trap 'test_rm_rf "${TMP}"' EXIT

refuse_global() {
    _label=$1
    shift
    if "$@" >"${TMP}/refuse.out" 2>"${TMP}/refuse.err"; then
        bad "${_label} exited 0"
        return
    fi
    _err=$(cat "${TMP}/refuse.err" "${TMP}/refuse.out" 2>/dev/null)
    case "${_err}" in
        *"Global is not available on"*"build local"*) ok "${_label}" ;;
        *) bad "${_label} text" ;;
    esac
    case "${_err}" in
        *"Scope:"*|*"Installed"*) bad "${_label} started work" ;;
    esac
}

refuse_global "termux build global" env TERMUX_VERSION=1 "${CLI}" build global
refuse_global "termux build install global" env TERMUX_VERSION=1 "${CLI}" build install global
mkdir -p "${TMP}/keep-prefix/opt/tn5250"
printf 'keep\n' > "${TMP}/keep-prefix/opt/tn5250/tn5250"
refuse_global "termux build clean global" env TERMUX_VERSION=1 "${CLI}" build clean global --prefix "${TMP}/keep-prefix"
if [ -f "${TMP}/keep-prefix/opt/tn5250/tn5250" ]; then
    ok "termux clean global left the prefix"
else
    bad "termux clean global removed the prefix"
fi
if env TERMUX_VERSION=1 "${CLI}" build global --json >"${TMP}/json.out" 2>"${TMP}/json.err"; then
    bad "termux json global exited 0"
else
    _json=$(cat "${TMP}/json.err" "${TMP}/json.out")
    case "${_json}" in
        *"Global is not available on Termux"*) ok "termux json global" ;;
        *) bad "termux json global" ;;
    esac
fi
if env TERMUX_VERSION=1 "${CLI}" build -h >"${TMP}/help-termux.out" 2>"${TMP}/help-termux.err"; then
    ok "termux build -h"
else
    bad "termux build -h"
fi

REAL_UNAME=$(command -v uname)
cat > "${TMP}/uname" <<EOF
#!/bin/sh
case "\${1-}" in
    -s) printf '%s\\n' 'MINGW64_NT-10.0' ;;
    *) exec ${REAL_UNAME} "\$@" ;;
esac
EOF
chmod 755 "${TMP}/uname"
refuse_global "windows build global" env OSTYPE=msys PATH="${TMP}:${PATH}" "${CLI}" build global
refuse_global "windows build clean global" env OSTYPE=msys PATH="${TMP}:${PATH}" "${CLI}" build clean global --prefix "${TMP}/keep-prefix"
_win=$(cat "${TMP}/refuse.err" "${TMP}/refuse.out")
case "${_win}" in
    *"Global is not available on Windows."*) ok "windows names Windows" ;;
    *) bad "windows names Windows" ;;
esac
if [ -f "${TMP}/keep-prefix/opt/tn5250/tn5250" ]; then
    ok "windows clean global left the prefix"
else
    bad "windows clean global removed the prefix"
fi

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

NAME="tn5250-amd64-glibc-2.34.1.2.3"
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

BNAME="tn5250-arm64-bionic-30.1.2.2"
BBIN="${ROOT}/download/${BNAME}"
if [ -x "${BBIN}" ]; then
    ok "bionic download executable"
else
    bad "bionic download executable"
fi
BSUM=$(sha256sum "${BBIN}" | awk '{ print $1 }')
BFILESUM=$(tr -d '\r\n' < "${BBIN}.sha256")
if [ "${BSUM}" = "${BFILESUM}" ]; then
    ok "bionic download sha256"
else
    bad "bionic download sha256"
fi
if grep -qx "${BNAME}" "${ROOT}/download/index.txt"; then
    ok "bionic download index"
else
    bad "bionic download index"
fi
BINTERP=$(readelf -l "${BBIN}" 2>/dev/null | grep -F 'Requesting program interpreter' || true)
case "${BINTERP}" in
    *linker64*) ok "bionic interpreter" ;;
    *) bad "bionic interpreter" ;;
esac
if readelf -n "${BBIN}" 2>/dev/null | grep -F 'description data:' | grep -q '1e 00 00 00'; then
    ok "bionic note api 30"
else
    bad "bionic note api 30"
fi
BHIGH=$(objdump -T "${BBIN}" 2>/dev/null | grep -oE 'GLIBC_[0-9]+\.[0-9]+' | head -n 1 || true)
if [ -z "${BHIGH}" ]; then
    ok "bionic has no GLIBC_ symbol"
else
    bad "bionic has no GLIBC_ symbol"
fi

if [ "${FAIL}" -ne 0 ]; then
    say "FAILED"
    exit 1
fi
say "ok"
exit 0
