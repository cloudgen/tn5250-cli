# Product review: tn5250-cli (Termux build)

**Date:** 2026-10-13
**Reviewer:** implementation pass for the Termux build
**Product:** tn5250-cli `VERSION=1.0.2`
**Ship unit:** `src/tn5250-cli`
**Scope:** RQ-TERMUX-CLI-CODING, RQ-TERMUX-BUILD-PAYLOAD, the Termux branch in the ship unit, the other platform arms that must stay, `tests/termux-platform.sh`, and a live session to pub400.com.
**Method:** `sh -n` and `tests/termux-platform.sh`. `setup -h` and `about --json`. Read of the CMake cache, the link lines, `ldd`, and the install stamps. Two setup runs on this Termux host. A curses session started with `src/tn5250-cli pub400.com`.
**Baseline:** Product version stays 1.0.2. Debian, Ubuntu, other Linux, Alpine, Git Bash, macOS, Fedora, and Red Hat Enterprise Linux were not compiled on this host.

## Summary

Termux is a first-class build. A set `TERMUX_VERSION` takes the `pkg` path before Debian, Ubuntu, and other Linux. On this host that path built the curses client from tag `v0.18.0` and linked it to the Termux ncurses and OpenSSL. A second setup did not install packages again and did not rebuild. The client opened pub400.com on port 23 and painted the IBM i 7.5 sign-on screen. The operator's account was submitted, including a Field Exit after the password so trailing nulls are stripped. The typed password was in the outbound record and was not followed by blanks. A corrected password was submitted the same way. The host answered `CPF1120` each time and did not show the Main Menu. That refusal is the host's answer, not a failed compile.

## Strengths

| Area | Notes |
|------|--------|
| Detect order | Termux is decided before Debian, Ubuntu, and other Linux. `apt-get` on `PATH` does not become a sudo apt build. |
| Packages | Missing tools use `pkg install -y` as this login. The sudo wrap is not called. A present toolchain does not call `pkg`. |
| Build | Unix Makefiles and `Release` when Ninja is absent. `CMAKE_PREFIX_PATH` is the Termux userspace prefix. No `MSYS_NO_PATHCONV`, no Windows GCC 14 patch, no `Ws2_32`, no `Winmm`. |
| Other platforms | The Debian, Ubuntu, other-Linux, and Git Bash arms remain. The apt arm still uses the sudo wrap. |
| Session | Port 23 reached the sign-on screen. The outbound record carried the profile in uppercase and the typed password without folding. |

## Findings

### TN5250-TMX-01 — Severity: P2 (medium)

- **Area:** SESSION
- **Status:** open
- **Location:** live session, TP-TMX-08
- **Description:** The built client reached the pub400.com sign-on screen and submitted the operator's account. The host answered `CPF1120` (user does not exist, or the password is not correct) and did not show the Main Menu.
- **Impact:** The Termux build can open the host. It did not complete a signed-on session with the account that was tried. The password was not stored in this tree.
- **Suggestion:** Confirm that profile and password with the operator outside this repository. Do not write the password into requirements, the review, or the changelog.
- **Cross-ref:** RQ-TERMUX-BUILD-PAYLOAD TP-TMX-08

### TN5250-TMX-02 — Severity: P3 (low)

- **Area:** TEST
- **Status:** deferred
- **Location:** `docs/reviews/test-plan.md` Debian, Ubuntu, other Linux, Alpine, Git Bash, macOS, Fedora, and Red Hat Enterprise Linux compile rows
- **Description:** Those builds were not compiled on this Termux host. Their case arms were read and checked by `tests/termux-platform.sh`. Alpine uses `apk` through the sudo wrap. That argv was not executed here. macOS uses `brew` as this login and does not call sudo. That argv was not executed here. No macOS compile was run. Fedora and Red Hat Enterprise Linux use `dnf install -y` through the sudo wrap. That argv was not executed here. No Fedora or Red Hat Enterprise Linux compile was run.
- **Impact:** A Termux-only edit could still break a platform this host cannot compile.
- **Suggestion:** Keep the next Debian, Ubuntu, other-Linux, Alpine, Git Bash, macOS, Fedora, or Red Hat Enterprise Linux proof on a host that owns that requirement.
- **Cross-ref:** RQ-DEBIAN-CLI-CODING, RQ-DEBIAN-BUILD-PAYLOAD, RQ-UBUNTU, RQ-OTHER-LINUX, RQ-ALPINE-CLI-CODING, RQ-ALPINE-BUILD-PAYLOAD, RQ-WINDOWS-GIT-BASH-CLI-CODING, RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD, RQ-MACOS-CLI-CODING, RQ-MACOS-BUILD-PAYLOAD

## Non-findings (explicitly OK)

| Check | Result |
|-------|--------|
| Termux routed through sudo apt | No. The Termux arm calls `pkg`. The first setup log did not call `sudo`. |
| Windows libraries or the GCC 14 patch | No. `int ioctlarg` remains. `CONNECT-FIX` is `addrinfo-1`. |
| Install prefix confused with the Termux userspace prefix | No. The userspace prefix is `PREFIX`. The install prefix stays `${HOME}/.local`. |
| Password written into the ship unit or the law | No. |
| Product version bumped for this platform | No. `VERSION` stays `1.0.2`. The Unreleased changelog names Termux. |
| Ninja required | No. Unix Makefiles ran because Ninja was not installed. |

## Priority remediation order

1. Confirm the operator's pub400.com profile outside this tree. The client already delivers the sign-on record.
2. Compile Debian, Ubuntu, other Linux, or Git Bash only on a host that owns that requirement.

## Related

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-termux-cli-coding.md` | Termux CLI coding (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-termux-build-payload.md` | Termux payload build (RQ-TERMUX-BUILD-PAYLOAD) |
| `docs/reviews/test-plan.md` | TP-TMX-01 through TP-TMX-08 |
| `tests/termux-platform.sh` | Detect, help, and platform-arm checks. No compile and no `pkg` |
| `src/tn5250-cli` | Termux setup and curses launch |

**Written by:** the alignment pass on 2026-10-13
**Review status:** partial. The Termux build matches the requirement. The host refused the sign-on. No P0 or P1.
