#!/bin/sh
# Proves setup picks the newest app version for this machine's arch and C library.
# Uses a file:// index. Does not compile. Does not call sudo or pkg.

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
ARCH=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_arch":"\([^"]*\)".*/\1/p')
CLIB=$(printf '%s\n' "${ABOUT}" | sed -n 's/.*"payload_clib":"\([^"]*\)".*/\1/p')
case "${ARCH}" in
    amd64|arm64|arm|386|ppc64le|riscv64|s390x) ok "about arch ${ARCH}" ;;
    *) bad "about arch ${ARCH}" ;;
esac
case "${CLIB}" in
    *-*) ok "about clib ${CLIB}" ;;
    *) bad "about clib ${CLIB}" ;;
esac

TMP=$(mktemp -d) || exit 1
HOME_DIR=$(mktemp -d) || exit 1
# PATH rm is safe-rm on this host and spends many seconds on each directory.
trap 'test_rm_rf "${TMP}" "${HOME_DIR}"' EXIT

CLIB_NAME=${CLIB%%-*}
CLIB_VER=${CLIB#*-}
case "${CLIB_VER}" in
    *.*.*) HIGH_VER="99.${CLIB_VER#*.}" ;;
    *.*) HIGH_VER="99.${CLIB_VER#*.}" ;;
    *) HIGH_VER="99" ;;
esac
OLD="${TMP}/tn5250-${ARCH}-${CLIB}.1.0.0"
NEW="${TMP}/tn5250-${ARCH}-${CLIB}.1.1.0"
HIGH="${TMP}/tn5250-${ARCH}-${CLIB_NAME}-${HIGH_VER}.1.1.0"
OTHER="${TMP}/tn5250-amd64-glibc-2.35.9.9.9"
printf '%s\n' 'old-payload' > "${OLD}"
printf '%s\n' 'new-payload' > "${NEW}"
printf '%s\n' 'too-new' > "${HIGH}"
printf '%s\n' 'other-payload' > "${OTHER}"
if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "${OLD}" | awk '{ print $1 }' > "${OLD}.sha256"
    sha256sum "${NEW}" | awk '{ print $1 }' > "${NEW}.sha256"
    sha256sum "${HIGH}" | awk '{ print $1 }' > "${HIGH}.sha256"
    sha256sum "${OTHER}" | awk '{ print $1 }' > "${OTHER}.sha256"
else
    bad "sha256sum"
    exit 1
fi
{
    printf '%s\n' "$(basename "${OLD}")"
    printf '%s\n' "$(basename "${NEW}")"
    printf '%s\n' "$(basename "${HIGH}")"
    printf '%s\n' "$(basename "${OTHER}")"
} > "${TMP}/index.txt"

OUT=$(HOME="${HOME_DIR}" TN5250_PAYLOAD_BASE="file://${TMP}" "${CLI}" setup 2>&1)
STATUS=$?
if [ "${STATUS}" -ne 0 ]; then
    bad "setup exit ${STATUS}: ${OUT}"
else
    ok "setup exit 0"
fi
SAVED="${HOME_DIR}/.local/bin/tn5250"
if [ -x "${SAVED}" ]; then
    ok "saved executable"
else
    bad "saved executable"
fi
case "$(cat "${SAVED}" 2>/dev/null)" in
    new-payload)
        ok "newest app version"
        ok "newer clib-version was not saved"
        ;;
    too-new) bad "newer clib-version was saved" ;;
    *) bad "newest app version: $(cat "${SAVED}" 2>/dev/null)" ;;
esac
if [ -e "${HOME_DIR}/.local/bin/$(basename "${NEW}")" ]; then
    bad "long name was left on PATH"
else
    ok "long name was not saved"
fi

printf '%s\n' 'not-the-digest' > "${NEW}.sha256"
OUT2=$(HOME="${HOME_DIR}" TN5250_PAYLOAD_BASE="file://${TMP}" "${CLI}" setup 2>&1)
STATUS2=$?
if [ "${STATUS2}" -eq 0 ]; then
    bad "mismatch should stop"
else
    ok "mismatch stops"
fi
case "${OUT2}" in
    *Digest\ mismatch*) ok "mismatch names the digest" ;;
    *) bad "mismatch names the digest: ${OUT2}" ;;
esac

HELP=$(${CLI} setup -h 2>&1)
case "${HELP}" in
    *download*) ok "setup -h names download" ;;
    *) bad "setup -h names download" ;;
esac
case "${HELP}" in
    *Configuring*|*pkg\ install*) bad "setup -h compiled" ;;
    *) ok "setup -h did not compile" ;;
esac

if [ "${FAIL}" -ne 0 ]; then
    say "payload-setup: failed"
    exit 1
fi
say "payload-setup: passed"
exit 0
