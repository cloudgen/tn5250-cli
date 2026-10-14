#!/bin/sh
# Proves Termux removes under the exec interceptor (RQ-TERMUX-CLI-CODING rule 14).
# TP-TMX-10: setup does not print the toybox quote error. A matching digest still saves.
# TP-TMX-11: coreutils does not call safe-rm. Without coreutils, safe-rm text stays hidden.
# Does not compile. Does not call sudo or pkg. Does not remove the login prefix.

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
CLI="${ROOT}/src/tn5250-cli"
FAIL=0

say() { printf '%s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1" >&2; FAIL=1; }
ok() { printf 'ok %s\n' "$1"; }

test_rm_rf() {
    if command -v coreutils >/dev/null 2>&1; then
        coreutils --coreutils-prog=rm -rf -- "$@"
    else
        rm -rf "$@"
    fi
}

if [ -z "${TERMUX_VERSION:-}" ]; then
    bad "TERMUX_VERSION is unset"
    say "termux-rm: failed"
    exit 1
fi
if [ -z "${PREFIX:-}" ] || [ ! -r "${PREFIX}/lib/libtermux-exec.so" ]; then
    bad "libtermux-exec.so"
    say "termux-rm: failed"
    exit 1
fi

# LD_PRELOAD has to be on the shell that calls execve. A direct /bin/rm from a
# shell that was not preloaded never hits the interceptor. env starts timeout
# with the library, and timeout starts the command.
intercept() {
    env -u TERMUX_EXEC_OPTOUT -u TERMUX_EXEC__PROC_SELF_EXE \
        LD_PRELOAD="${PREFIX}/lib/libtermux-exec.so" \
        timeout 25 \
        env \
        "$@"
}

if ! sh -n "${CLI}"; then
    bad "sh -n"
else
    ok "sh -n"
fi

WORK=$(mktemp -d) || exit 1
trap 'test_rm_rf "${WORK}"' EXIT

# The interceptor is on only when /bin/rm prints the quote error and leaves the file.
PROBE="${WORK}/probe"
printf '%s\n' probe > "${PROBE}"
intercept /bin/rm -f "${PROBE}" >"${WORK}/probe.out" 2>&1 || true
if grep -q 'Syntax error: Unterminated quoted string' "${WORK}/probe.out"; then
    ok "interceptor rewrites /bin/rm"
else
    bad "interceptor rewrites /bin/rm"
    say "termux-rm: failed"
    exit 1
fi
if [ -f "${PROBE}" ]; then
    ok "rewritten /bin/rm left the file"
else
    bad "rewritten /bin/rm left the file"
fi
if env -u TERMUX_EXEC_OPTOUT sh -c 'test -z "${TERMUX_EXEC_OPTOUT:-}"'; then
    ok "TERMUX_EXEC_OPTOUT can be unset"
else
    bad "TERMUX_EXEC_OPTOUT can be unset"
fi

ABOUT=$(intercept "${CLI}" about --json 2>/dev/null) || ABOUT=""
ARCH=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_arch":"\([^"]*\)".*/\1/p')
CLIB=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_clib":"\([^"]*\)".*/\1/p')
case "${ARCH}" in
    amd64|arm64|arm|386|ppc64le|riscv64|s390x) ok "about arch ${ARCH}" ;;
    *) bad "about arch ${ARCH}"; say "termux-rm: failed"; exit 1 ;;
esac
case "${CLIB}" in
    bionic-*) ok "about clib ${CLIB}" ;;
    *) bad "about clib ${CLIB}"; say "termux-rm: failed"; exit 1 ;;
esac

NAME="tn5250-${ARCH}-${CLIB}.1.2.2"
CHAN="${WORK}/chan"
mkdir -p "${CHAN}"
printf '%s\n' 'payload-bytes' > "${CHAN}/${NAME}"
sha256sum "${CHAN}/${NAME}" | awk '{ print $1 }' > "${CHAN}/${NAME}.sha256"
printf '%s\n' "${NAME}" > "${CHAN}/index.txt"

login_name=$(id -un 2>/dev/null || printf '%s\n' unknown)
if [ -d /dev/shm ] && [ -w /dev/shm ]; then
    STOR="/dev/shm/tn5250-cli-${login_name}"
elif [ -w /tmp ]; then
    STOR="/tmp/tn5250-cli-${login_name}"
else
    STOR="${HOME}/.cache/tn5250-cli-${login_name}"
fi

list_files() {
    _dir=$1
    _out=$2
    if [ -d "${_dir}" ]; then
        find "${_dir}" -type f | sort > "${_out}"
    else
        : > "${_out}"
    fi
}

run_setup() {
    _home=$1
    shift
    intercept "$@" \
        HOME="${_home}" \
        TN5250_PAYLOAD_BASE="file://${CHAN}" \
        "${CLI}" setup >"${WORK}/setup.out" 2>"${WORK}/setup.err"
}

# TP-TMX-10. coreutils is on PATH. Scratch goes away. No quote error. No [ERROR].
HOME1="${WORK}/home1"
mkdir -p "${HOME1}"
list_files "${STOR}" "${WORK}/before"
if run_setup "${HOME1}"; then
    ok "setup exit 0"
else
    bad "setup exit $?"
fi
cat "${WORK}/setup.out" "${WORK}/setup.err" > "${WORK}/setup.all"
if grep -q 'Syntax error: Unterminated quoted string' "${WORK}/setup.all"; then
    bad "setup quote error"
else
    ok "setup quote error absent"
fi
if grep -q '\[ERROR\]' "${WORK}/setup.all"; then
    bad "setup [ERROR]"
else
    ok "setup [ERROR] absent"
fi
if grep -q '\[WARN\]' "${WORK}/setup.all"; then
    bad "setup warned after a coreutils remove"
else
    ok "setup did not warn"
fi
case "$(cat "${WORK}/setup.out")" in
    *"Saved ${NAME} as ${HOME1}/.local/bin/tn5250"*) ok "setup saved" ;;
    *) bad "setup saved: $(cat "${WORK}/setup.out" 2>/dev/null)" ;;
esac
if [ -x "${HOME1}/.local/bin/tn5250" ]; then
    ok "saved executable"
else
    bad "saved executable"
fi
list_files "${STOR}" "${WORK}/after"
LEAK=$(awk 'NR==FNR { seen[$0]=1; next } !($0 in seen) && $0 != ""' "${WORK}/before" "${WORK}/after")
if [ -n "${LEAK}" ]; then
    bad "scratch remains: ${LEAK}"
else
    ok "scratch removed"
fi

# JSON must not carry an error object for the remove.
HOMEJ="${WORK}/homej"
mkdir -p "${HOMEJ}"
if intercept HOME="${HOMEJ}" TN5250_PAYLOAD_BASE="file://${CHAN}" \
    "${CLI}" --json setup >"${WORK}/json.out" 2>"${WORK}/json.err"; then
    ok "json setup exit 0"
else
    bad "json setup exit $?"
fi
if grep -q '"type":"success"' "${WORK}/json.out"; then
    ok "json success"
else
    bad "json success: $(cat "${WORK}/json.out" 2>/dev/null)"
fi
if grep -q 'out_error\|Syntax error\|\[ERROR\]' "${WORK}/json.err"; then
    bad "json stderr: $(cat "${WORK}/json.err" 2>/dev/null)"
else
    ok "json stderr has no error"
fi

# build clean on a private prefix. Success is silent apart from the clean lines.
PFX="${WORK}/pfx"
CACHE="${WORK}/cache"
mkdir -p "${PFX}/opt/tn5250/keep" "${CACHE}/tn5250/build/keep"
printf '%s\n' x > "${PFX}/opt/tn5250/keep/a"
printf '%s\n' x > "${CACHE}/tn5250/build/keep/a"
if intercept HOME="${WORK}/home-clean" XDG_CACHE_HOME="${CACHE}" TN5250_PREFIX="${PFX}" \
    "${CLI}" build clean >"${WORK}/clean.out" 2>"${WORK}/clean.err"; then
    ok "build clean exit 0"
else
    bad "build clean exit $?"
fi
cat "${WORK}/clean.out" "${WORK}/clean.err" > "${WORK}/clean.all"
if grep -q 'Syntax error: Unterminated quoted string' "${WORK}/clean.all"; then
    bad "build clean quote error"
else
    ok "build clean quote error absent"
fi
if grep -q '\[ERROR\]' "${WORK}/clean.all"; then
    bad "build clean [ERROR]: $(cat "${WORK}/clean.all")"
else
    ok "build clean [ERROR] absent"
fi
if grep -q '\[WARN\]' "${WORK}/clean.all"; then
    bad "build clean warned after a coreutils remove"
else
    ok "build clean did not warn"
fi
case "$(cat "${WORK}/clean.out")" in
    *"Cleaned the built client under ${PFX}"*) ok "build clean finished" ;;
    *) bad "build clean finished: $(cat "${WORK}/clean.out" 2>/dev/null)" ;;
esac
if [ -e "${PFX}/opt/tn5250" ] || [ -e "${CACHE}/tn5250/build" ]; then
    bad "build clean left a tree"
else
    ok "build clean removed both trees"
fi

# TP-TMX-11. A PATH rm that is safe-rm must not run while coreutils is visible.
SAFE_LOG="${WORK}/safe.log"
: > "${SAFE_LOG}"
FAKE="${WORK}/fakebin"
mkdir -p "${FAKE}"
cat > "${FAKE}/safe-rm" <<EOF
#!${PREFIX}/bin/sh
printf '%s\n' "called" >> "${SAFE_LOG}"
printf '%s\n' "SAFE-RM-CHILD" >&2
exit 1
EOF
chmod 755 "${FAKE}/safe-rm"
ln -s safe-rm "${FAKE}/rm"
HOME2="${WORK}/home2"
mkdir -p "${HOME2}"
if intercept PATH="${FAKE}:${PATH}" SAFE_RM_LOG="${SAFE_LOG}" HOME="${HOME2}" \
    TN5250_PAYLOAD_BASE="file://${CHAN}" \
    "${CLI}" setup >"${WORK}/safe.out" 2>"${WORK}/safe.err"; then
    ok "setup with shadowed safe-rm exit 0"
else
    bad "setup with shadowed safe-rm exit $?"
fi
cat "${WORK}/safe.out" "${WORK}/safe.err" > "${WORK}/safe.all"
if [ -s "${SAFE_LOG}" ]; then
    bad "coreutils path called safe-rm"
else
    ok "coreutils path did not call safe-rm"
fi
if grep -q 'SAFE-RM-CHILD\|Syntax error\|\[ERROR\]' "${WORK}/safe.all"; then
    bad "shadowed safe-rm text: $(cat "${WORK}/safe.all")"
else
    ok "shadowed safe-rm text absent"
fi
case "$(cat "${WORK}/safe.out")" in
    *"Saved ${NAME} as ${HOME2}/.local/bin/tn5250"*) ok "shadowed safe-rm still saved" ;;
    *) bad "shadowed safe-rm still saved" ;;
esac

# coreutils absent. The only rm is the fake safe-rm. Child text stays hidden.
# Link just the tools setup runs, not the whole prefix. ln on every prefix
# name is slow here, and that directory also contains coreutils.
TOOL="${WORK}/tools"
mkdir -p "${TOOL}"
for _need in id mkdir mktemp curl sha256sum awk tr uname clang cc readlink chmod mv sed grep; do
    _src=$(command -v "${_need}" 2>/dev/null) || _src=""
    if [ -n "${_src}" ]; then
        "${PREFIX}/bin/ln" -s "${_src}" "${TOOL}/${_need}"
    fi
done
if [ -x /system/bin/getprop ]; then
    "${PREFIX}/bin/ln" -s /system/bin/getprop "${TOOL}/getprop"
fi
"${PREFIX}/bin/ln" -s "${FAKE}/safe-rm" "${TOOL}/safe-rm"
"${PREFIX}/bin/ln" -s safe-rm "${TOOL}/rm"
ABSENT_PATH="${TOOL}:/system/bin"
if PATH="${ABSENT_PATH}" command -v coreutils >/dev/null 2>&1; then
    bad "absent PATH still has coreutils"
else
    ok "absent PATH has no coreutils"
fi
: > "${SAFE_LOG}"
HOME3="${WORK}/home3"
mkdir -p "${HOME3}"
if intercept PATH="${ABSENT_PATH}" SAFE_RM_LOG="${SAFE_LOG}" HOME="${HOME3}" \
    TN5250_PAYLOAD_BASE="file://${CHAN}" \
    "${CLI}" setup >"${WORK}/absent.out" 2>"${WORK}/absent.err"; then
    ok "absent coreutils setup exit 0"
else
    bad "absent coreutils setup exit $?: $(cat "${WORK}/absent.out" "${WORK}/absent.err" 2>/dev/null)"
fi
cat "${WORK}/absent.out" "${WORK}/absent.err" > "${WORK}/absent.all"
if [ -s "${SAFE_LOG}" ]; then
    ok "absent coreutils called safe-rm"
else
    bad "absent coreutils called safe-rm"
fi
if grep -q 'SAFE-RM-CHILD' "${WORK}/absent.all"; then
    bad "safe-rm child text was shown"
else
    ok "safe-rm child text hidden"
fi
if grep -q 'Syntax error\|\[ERROR\]' "${WORK}/absent.all"; then
    bad "absent coreutils error: $(cat "${WORK}/absent.all")"
else
    ok "absent coreutils has no error"
fi
if grep -q '\[WARN\]' "${WORK}/absent.all"; then
    ok "absent coreutils warned"
else
    bad "absent coreutils warned"
fi
case "$(cat "${WORK}/absent.out")" in
    *"Saved ${NAME} as ${HOME3}/.local/bin/tn5250"*) ok "absent coreutils still saved" ;;
    *) bad "absent coreutils still saved: $(cat "${WORK}/absent.out" 2>/dev/null)" ;;
esac

# Menu row 2 is the same setup. The interceptor stays on. 9 leaves the list.
HOME4="${WORK}/home4"
mkdir -p "${HOME4}"
if python3 - "${CLI}" "${HOME4}" "${CHAN}" "${PREFIX}" "${NAME}" >"${WORK}/menu.out" 2>"${WORK}/menu.err" <<'PY'
import os, pty, select, sys
cli, home, chan, prefix, name = sys.argv[1:6]
pid, fd = pty.fork()
if pid == 0:
    env = os.environ.copy()
    env.pop("TERMUX_EXEC_OPTOUT", None)
    env.pop("TERMUX_EXEC__PROC_SELF_EXE", None)
    env["LD_PRELOAD"] = prefix + "/lib/libtermux-exec.so"
    env["HOME"] = home
    env["TN5250_PAYLOAD_BASE"] = "file://" + chan
    os.execve(cli, [cli], env)
buf = b""
steps = [b"2\n", b"9\n"]
step = 0
while True:
    ready, _, _ = select.select([fd], [], [], 20)
    if not ready:
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
        if buf.endswith(b": ") or buf.rstrip().endswith(b":"):
            os.write(fd, steps[step])
            step += 1
            buf = buf.replace(b"Choose a number", b"CHOSE", 1)
_, status = os.waitpid(pid, 0)
code = status >> 8 if os.WIFEXITED(status) else 1
text = buf.decode("utf-8", "replace")
sys.stdout.write(text)
saved = "Saved %s as %s/.local/bin/tn5250" % (name, home)
if code != 0 or step != 2:
    sys.stderr.write("menu exit %s steps %s\n" % (code, step))
    sys.exit(1)
if "Syntax error" in text or "[ERROR]" in text:
    sys.stderr.write("menu showed an error\n")
    sys.exit(1)
if saved not in text:
    sys.stderr.write("menu did not save\n")
    sys.exit(1)
PY
then
    ok "menu row 2 saved and exited 0"
else
    bad "menu row 2: $(cat "${WORK}/menu.err" 2>/dev/null)"
fi

if [ "${FAIL}" -ne 0 ]; then
    say "termux-rm: failed"
    exit 1
fi
say "termux-rm: passed"
exit 0
