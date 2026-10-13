# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2026-10-13

### Added

- `tn5250-cli setup` downloads a published client from the GitHub raw usercontent channel and saves it as `~/.local/bin/tn5250` (`tn5250.exe` on Windows), mode `0755`. It does not compile. `build` still compiles.
- A published name is `tn5250-<arch>-<clib>-<clib-version>.<app-version>`, plus `.exe` on Windows. This phone's name is `tn5250-arm64-bionic-30.1.1.0`. `TERMUX_VERSION` is read from the environment and is not part of the name.
- `about` shows the architecture and `<clib>-<clib-version>`. On Termux it also shows `TERMUX_VERSION`.
- The front board is row 1 `build`, row 2 `setup`, row 7 `languages`, row 8 `self-management`, and row 9 Exit. English is the only language.
- Published payload filenames live in `download/` and are owned by `RQ-PAYLOAD-FILENAME`. The C-library version is a floor: a newer glibc file is not sent to an older machine. Termux is `bionic`, and the floor is the compiler API, not the phone SDK. No payload bytes are committed yet. `build` is unchanged.
- Termux is a supported build. `tn5250-cli build` installs missing compiler packages with `pkg` as this user and does not call sudo. Debian, Ubuntu, other Linux, and Git Bash keep their existing builds.
- Termux law is two requirements: CLI coding (`RQ-TERMUX-CLI-CODING`) and the build payload (`RQ-TERMUX-BUILD-PAYLOAD`). The installer is copied to `~/.local/bin`. The curses client stays under `~/.local/opt/tn5250`.
- Windows Git Bash law is two requirements: CLI coding (`RQ-WINDOWS-GIT-BASH-CLI-CODING`) and the build payload (`RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD`). The installer is copied to `~/.local/bin`. The three Windows programs stay under `~/.local/opt/tn5250`.
- Alpine is a supported build. `tn5250-cli build` installs a missing compiler package with `apk add --no-cache` through the sudo wrap. It does not call Termux `pkg`. Debian, Ubuntu, other Linux, Termux, and Git Bash keep their existing builds.
- Alpine law is two requirements: CLI coding (`RQ-ALPINE-CLI-CODING`) and the build payload (`RQ-ALPINE-BUILD-PAYLOAD`). The installer is copied to `~/.local/bin`. The curses client stays under `~/.local/opt/tn5250`. No Alpine compile was run on the authoring host.
- Debian law is two requirements: CLI coding (`RQ-DEBIAN-CLI-CODING`) and the build payload (`RQ-DEBIAN-BUILD-PAYLOAD`). Detection, `apt-get` through the sudo wrap, and the installer path stay the CLI file. Compilation, link, and the package table stay the payload file. The Debian build itself is unchanged. No Debian compile was run on this host.
- macOS is a supported build. `tn5250-cli build` installs a missing formula with `brew` as this user and does not call sudo. The compiler is the Xcode Command Line Tools `gcc`, not Homebrew `gcc`. Debian, Ubuntu, other Linux, Alpine, Termux, and Git Bash keep their existing builds.
- macOS law is two requirements: CLI coding (`RQ-MACOS-CLI-CODING`) and the build payload (`RQ-MACOS-BUILD-PAYLOAD`). The installer is copied to `~/.local/bin`. The curses client stays under `~/.local/opt/tn5250`. No macOS compile was run on this host.
- Fedora and Red Hat Enterprise Linux are a supported build. `tn5250-cli build` installs a missing compiler package with `dnf install -y` through the sudo wrap. `ID=fedora` and `ID=rhel` are the family. CentOS, Rocky Linux, AlmaLinux, Amazon Linux, and Oracle Linux stay other Linux. Debian, Ubuntu, other Linux, Alpine, Termux, macOS, and Git Bash keep their existing builds.
- Fedora and Red Hat law is two requirements: CLI coding (`RQ-FEDORA-REDHAT-CLI-CODING`) and the build payload (`RQ-FEDORA-REDHAT-BUILD-PAYLOAD`). The installer is copied to `~/.local/bin`. The curses client stays under `~/.local/opt/tn5250`. No Fedora or Red Hat Enterprise Linux compile was run on this host.
- Front board row 1 is `build`. Choosing `1` or typing `build` runs the build verb. After it returns, the front board is shown again.
- The README explains that tn5250 is the 5250 telnet client for IBM i, and that this repository is the installer.

### Changed

- Launch prefers the file `setup` saved, then the client `build` copied. A missing client names `setup` or `build`.
- The self-management list tells you the next step is `tn5250-cli setup`.

## [1.0.2] - 2026-10-07

### Fixed

- `menu` and `main` open the numbered list. They are not passed to the terminal client as a host name.
- Setup applies a connect fix to upstream `lib5250/telnetstr.c` and `lib5250/sslstream.c` before configure. A failed `getaddrinfo` no longer calls `freeaddrinfo` on an undefined pointer, so a host name that does not resolve prints the client's session error instead of a segmentation fault.
- A payload that does not have `CONNECT-FIX` is rebuilt. The stamp is `addrinfo-1`. `HEAD` stays the upstream commit.

## [1.0.1] - 2026-10-07

### Added

- Published install channel: `curl -fsSL https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli | sh`.
- Default `REPO_USER` is `cloudgen` and default `REPO_NAME` is `tn5250-cli`. Unset `SCRIPT_URL` composes the raw URL of `src/tn5250-cli`.
- SHA-256 companion `src/tn5250-cli.sha256` is fetched as `${SCRIPT_URL}.sha256`. A match continues, a mismatch stops, and a missing companion warns and continues.
- A terminal with no command opens the numbered list (8 self-management, 9 Exit). A pipe, `--quiet`, or `--json` places this CLI.

### Changed

- Linux root install text is `sudo curl -fsSL … | sudo sh`. Git Bash stays on the command without sudo.
- An explicit empty `SCRIPT_URL` still refuses the download before curl.

## [1.0.0] - 2026-10-07

### Added

- First public baseline of `tn5250-cli` 1.0.0.
- `setup` builds upstream tn5250 v0.18.0 for Windows Git Bash, Debian 12 and 13, Ubuntu 22.04, 24.04, and 26.04, and other Linux.
- Mixed elevated sudo model: the person types `tn5250-cli setup`. Missing compiler packages are the only in-tool sudo. Git and the compile stay with that person. A sudo launch is recovered before git. Help does not tell the person to prefix setup with sudo.
- `help`, `version`, and a host token that launches the built tn5250 program.

### Notes

- The Ubuntu 24.04 setup was run on the authoring host with the compiler already present, so that run did not call sudo. Debian, other Linux, Ubuntu 22.04, Ubuntu 26.04, and Windows compiles were not run for this baseline. A closed terminal and the real return from a sudo launch were not executed.
