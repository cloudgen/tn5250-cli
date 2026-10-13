#!/bin/sh
# Aligns RQ-TERMUX-CLI-CODING and RQ-TERMUX-BUILD-PAYLOAD with the ship unit without compiling.
# Live build and a host session are TP-TMX-03 through TP-TMX-08 in the review.
# Does not call sudo. Does not call pkg.

set -u

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
CLI="${ROOT}/src/tn5250-cli"
FAIL=0

say() {
    printf '%s\n' "$1"
}

bad() {
    printf 'FAIL %s\n' "$1" >&2
    FAIL=1
}

ok() {
    printf 'ok %s\n' "$1"
}

if ! sh -n "${CLI}"; then
    bad "sh -n"
else
    ok "sh -n"
fi

HELP=$(${CLI} build -h 2>&1)
STATUS=$?
if [ "${STATUS}" -ne 0 ]; then
    bad "build -h exit ${STATUS}"
else
    ok "build -h exit 0"
fi

case "${HELP}" in
    *Termux*) ok "build -h names Termux" ;;
    *) bad "build -h names Termux" ;;
esac
case "${HELP}" in
    *"pkg"*) ok "build -h names pkg" ;;
    *) bad "build -h names pkg" ;;
esac
case "${HELP}" in
    *"does not run under Termux"*) bad "old Termux refusal is still in build -h" ;;
    *) ok "build -h does not refuse Termux" ;;
esac
case "${HELP}" in
    *Alpine*) ok "build -h names Alpine" ;;
    *) bad "build -h names Alpine" ;;
esac

TOP=$(${CLI} help 2>&1)
TSTATUS=$?
if [ "${TSTATUS}" -ne 0 ]; then
    bad "help exit ${TSTATUS}"
else
    ok "help exit 0"
fi
case "${TOP}" in
    *Alpine*) ok "help names Alpine" ;;
    *) bad "help names Alpine" ;;
esac
case "${HELP}" in
    *apk*) ok "build -h names apk" ;;
    *) bad "build -h names apk" ;;
esac
case "${HELP}" in
    *macOS*) ok "build -h names macOS" ;;
    *) bad "build -h names macOS" ;;
esac
case "${HELP}" in
    *brew*) ok "build -h names brew" ;;
    *) bad "build -h names brew" ;;
esac
case "${HELP}" in
    *"macOS does not call sudo"*) ok "build -h says macOS does not call sudo" ;;
    *) bad "build -h says macOS does not call sudo" ;;
esac
case "${HELP}" in
    *"refuses macOS"*) bad "build -h refuses macOS" ;;
    *) ok "build -h does not refuse macOS" ;;
esac
case "${TOP}" in
    *macOS*) ok "help names macOS" ;;
    *) bad "help names macOS" ;;
esac
case "${TOP}" in
    *Fedora*) ok "help names Fedora" ;;
    *) bad "help names Fedora" ;;
esac
case "${TOP}" in
    *"Red Hat"*) ok "help names Red Hat" ;;
    *) bad "help names Red Hat" ;;
esac
case "${HELP}" in
    *Fedora*) ok "build -h names Fedora" ;;
    *) bad "build -h names Fedora" ;;
esac
case "${HELP}" in
    *"Red Hat"*) ok "build -h names Red Hat" ;;
    *) bad "build -h names Red Hat" ;;
esac
case "${HELP}" in
    *dnf*) ok "build -h names dnf" ;;
    *) bad "build -h names dnf" ;;
esac
case "${HELP}" in
    *"refuses Fedora"*|*"refuses Red Hat"*) bad "build -h refuses Fedora or Red Hat" ;;
    *) ok "build -h does not refuse Fedora or Red Hat" ;;
esac
case "${TOP}" in
    *"refuses Fedora"*|*"refuses Red Hat"*) bad "help refuses Fedora or Red Hat" ;;
    *) ok "help does not refuse Fedora or Red Hat" ;;
esac
case "${TOP}" in
    *"refuses macOS"*) bad "help refuses macOS" ;;
    *) ok "help does not refuse macOS" ;;
esac

ABOUT=$(${CLI} --json about 2>/dev/null || true)
if printf '%s\n' "${ABOUT}" | grep -q 'payload_platform' && printf '%s\n' "${ABOUT}" | grep -q 'termux'; then
    ok "about json platform termux"
else
    bad "about json platform termux: ${ABOUT}"
fi
if printf '%s\n' "${ABOUT}" | grep -q '"payload_platform":"macos"'; then
    bad "this Termux host was detected as macos"
else
    ok "this Termux host is not macos"
fi
if printf '%s\n' "${ABOUT}" | grep -q '"payload_platform":"fedora"' || printf '%s\n' "${ABOUT}" | grep -q '"payload_platform":"rhel"'; then
    bad "this Termux host was detected as fedora or rhel"
else
    ok "this Termux host is not fedora or rhel"
fi

# Other platforms stay routed. Termux is an added arm, not a replacement.
for _arm in 'debian) tn5250_setup_unix "Debian" "apt"' \
    'ubuntu) tn5250_setup_unix "Ubuntu" "apt"' \
    'other-linux) tn5250_setup_unix "Linux" ""' \
    'alpine) tn5250_setup_unix "Alpine" "apk"' \
    'tn5250_setup_unix "Termux" "pkg"' \
    'tn5250_setup_unix "macOS" "brew"' \
    'fedora) tn5250_setup_unix "Fedora" "dnf"' \
    'rhel) tn5250_setup_unix "Red Hat Enterprise Linux" "dnf"' \
    'tn5250_setup_windows' \
    'dnf install -y' \
    'pkg install -y' \
    'apt-get install -y' \
    'HOMEBREW_NO_AUTO_UPDATE=1 brew install' \
    'xcode-select --install'; do
    if grep -F "${_arm}" "${CLI}" >/dev/null 2>&1; then
        ok "ship unit keeps ${_arm}"
    else
        bad "ship unit keeps ${_arm}"
    fi
done

# The pkg arm must not elevate. The apt arm still does.
if awk '
    $0 ~ /pkg\)/ { inpkg=1 }
    inpkg && /tn5250_run_elevated/ { print "elev"; exit }
    inpkg && /pkg install -y/ { exit }
' "${CLI}" | grep -q elev; then
    bad "pkg arm calls the sudo wrap"
else
    ok "pkg arm does not call the sudo wrap"
fi

if grep -n 'tn5250_run_elevated' "${CLI}" | grep -q 'apt-get'; then
    ok "apt arm still uses the sudo wrap"
else
    bad "apt arm still uses the sudo wrap"
fi

if grep -n 'tn5250_run_elevated' "${CLI}" | grep -q 'apk add --no-cache'; then
    ok "apk arm still uses the sudo wrap"
else
    bad "apk arm still uses the sudo wrap"
fi

if grep -n 'tn5250_run_elevated' "${CLI}" | grep -q 'dnf install -y'; then
    ok "dnf arm still uses the sudo wrap"
else
    bad "dnf arm still uses the sudo wrap"
fi

# The brew arm must not elevate. Darwin is checked before Termux.
if awk '
    $0 ~ /brew\)/ { inbrew=1 }
    inbrew && /tn5250_run_elevated/ { print "elev"; exit }
    inbrew && /brew install/ { exit }
' "${CLI}" | grep -q elev; then
    bad "brew arm calls the sudo wrap"
else
    ok "brew arm does not call the sudo wrap"
fi

if awk '
    /tn5250_detect_platform\(\)/ { infn=1 }
    infn && /^tn5250_self_path\(\)/ { exit }
    infn && /Darwin\)/ { darwin=NR }
    infn && /TERMUX_VERSION/ { termux=NR }
    END {
        if (darwin > 0 && termux > darwin) exit 0
        exit 1
    }
' "${CLI}"; then
    ok "Darwin check is before Termux"
else
    bad "Darwin check is before Termux"
fi

if awk '
    $0 ~ /^tn5250_package_family\(\)/ { infn=1 }
    infn && $0 ~ /^}/ { exit }
    infn && /brew/ { print "brew"; exit }
' "${CLI}" | grep -q brew; then
    bad "package family auto-detects brew"
else
    ok "package family does not auto-detect brew"
fi

if awk '
    $0 ~ /^tn5250_detect_platform\(\)/ { infn=1 }
    infn && $0 ~ /^tn5250_self_path\(\)/ { exit }
    infn && index($0, "\"alpine\"") { if (!alpine) alpine=NR }
    infn && index($0, "\"fedora\"") { if (!fedora) fedora=NR }
    infn && index($0, "\"rhel\"") { if (!rhel) rhel=NR }
    infn && index($0, "other-linux") { if (!other) other=NR }
    END {
        if (alpine > 0 && fedora > alpine && rhel > fedora && other > rhel) exit 0
        exit 1
    }
' "${CLI}"; then
    ok "Fedora and Red Hat checks are after Alpine and before other Linux"
else
    bad "Fedora and Red Hat checks are after Alpine and before other Linux"
fi

BOGUS=$(${CLI} build --bogus 2>&1)
BSTATUS=$?
if [ "${BSTATUS}" -eq 0 ]; then
    bad "unknown build option should fail"
else
    ok "unknown build option fails"
fi
case "${BOGUS}" in
    *"build --help"*) ok "unknown option names build --help" ;;
    *) bad "unknown option names build --help" ;;
esac


# Do not call setup with no channel. That fetches the network.
SETUP_HELP=$(${CLI} setup -h 2>&1)
SETUP_HELP_STATUS=$?
if [ "${SETUP_HELP_STATUS}" -eq 0 ]; then
    ok "setup -h exits 0"
else
    bad "setup -h exits 0: ${SETUP_HELP_STATUS}"
fi
case "${SETUP_HELP}" in
    *download*) ok "setup -h names download" ;;
    *) bad "setup -h names download: ${SETUP_HELP}" ;;
esac
case "${SETUP_HELP}" in
    *Configuring*|*pkg\ install*) bad "setup -h compiled" ;;
    *) ok "setup -h did not compile" ;;
esac

case "${TOP}" in
    *"setup downloads a published client"*) ok "help says setup downloads" ;;
    *) bad "help says setup downloads" ;;
esac
case "${TOP}" in
    *"  build "*) ok "help names the build verb" ;;
    *) bad "help names the build verb" ;;
esac
case "${TOP}" in
    *"  setup "*) ok "help names setup" ;;
    *) bad "help names setup" ;;
esac

if grep -F 'out_menu_choice "1" "build"' "${CLI}" >/dev/null 2>&1; then
    ok "front board row 1 is build"
else
    bad "front board row 1 is build"
fi
if grep -F 'out_menu_choice "2" "setup"' "${CLI}" >/dev/null 2>&1; then
    ok "front board row 2 is setup"
else
    bad "front board row 2 is setup"
fi
if grep -F 'out_menu_choice "7" "languages"' "${CLI}" >/dev/null 2>&1; then
    ok "front board row 7 is languages"
else
    bad "front board row 7 is languages"
fi
if grep -F 'out_menu_choice "1" "setup"' "${CLI}" >/dev/null 2>&1; then
    bad "front board still offers setup on row 1"
else
    ok "front board does not offer setup on row 1"
fi
if grep -F '1|build)' "${CLI}" >/dev/null 2>&1; then
    ok "menu choice build runs the compile"
else
    bad "menu choice build runs the compile"
fi
if grep -F '2|setup)' "${CLI}" >/dev/null 2>&1; then
    ok "menu choice setup is row 2"
else
    bad "menu choice setup is row 2"
fi
if grep -F '7|languages)' "${CLI}" >/dev/null 2>&1; then
    ok "menu choice languages is row 7"
else
    bad "menu choice languages is row 7"
fi
if grep -F 'out_menu_choice "71" "en" "English"' "${CLI}" >/dev/null 2>&1; then
    ok "language board row 71 is en"
else
    bad "language board row 71 is en"
fi
if grep -F 'The list is English. That is the only language.' "${CLI}" >/dev/null 2>&1; then
    ok "language board says English is the only language"
else
    bad "language board says English is the only language"
fi
if grep -F '71|en)' "${CLI}" >/dev/null 2>&1; then
    ok "menu choice en is row 71"
else
    bad "menu choice en is row 71"
fi
if grep -F 'set -- build --prefix' "${CLI}" >/dev/null 2>&1; then
    ok "sudo handoff re-executes build"
else
    bad "sudo handoff re-executes build"
fi
if grep -F 'set -- setup --prefix' "${CLI}" >/dev/null 2>&1; then
    bad "sudo handoff still re-executes setup"
else
    ok "sudo handoff does not re-execute setup"
fi
if grep -F 'Next: ${APP_NAME} setup.' "${CLI}" >/dev/null 2>&1; then
    ok "self-management next step names setup"
else
    bad "self-management next step names setup"
fi

if [ "${FAIL}" -ne 0 ]; then
    say "termux-platform: failed"
    exit 1
fi
say "termux-platform: passed"
exit 0
