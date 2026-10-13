**file**: docs/requirements/requirement-macos-cli-coding.md
**ID**: RQ-MACOS-CLI-CODING
**Status**: Active (Version 1.0.3)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the macOS CLI coding requirement. It owns how the ship unit is written when the host is macOS: detection, the `brew` call, the refusal of sudo, help text, where the installer is copied, and launch of the curses client.

It does not own the C compile, the link line, the Homebrew formula names, or the payload directory layout. Those belong to `docs/requirements/requirement-macos-build-payload.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`. Command names belong to `docs/requirements/requirement-shell-cli-interface.md`. The `~/.bashrc` marker text belongs to `docs/requirements/requirement-termux-cli-coding.md`. This file uses that marker. It does not invent a second one.

### 1.1 Human-facing

**In one sentence:** On macOS the installer detects Darwin, installs a missing compiler package with `brew` as this login, copies itself to `~/.local/bin`, and launches the curses client from the payload directory.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person editing or running the installer on macOS | `tn5250-cli build` |
| The other role | The built curses client, owned by the payload requirement | `tn5250 HOST` |
| Not this file | CMake, ncurses, OpenSSL, and the formula table | `docs/requirements/requirement-macos-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Darwin detection, `brew install` as this login, no sudo, the copy of `tn5250-cli` into `~/.local/bin`, and launch of the curses `tn5250` | The formula names, the C compile, copying `tn5250` into `~/.local/bin`, and a `~/.zshrc` writer |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the macOS branch |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `~/.bashrc` | the shell start script | the same marked `PATH` block the Termux CLI file owns |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build on a Mac | The payload requirement says what the compile must produce. This file says how the script recognizes Darwin and how it asks Homebrew for a missing formula | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of macOS CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-macos-build-payload.md`. Debian stays on `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Alpine, Termux, and Git Bash stay on their own requirements. Fedora and Red Hat Enterprise Linux stay on `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
2. `build` (except `build -h` and `build --help`) and launch **MUST** accept the host when `uname -s` is `Darwin`. That check **MUST** run after the Git Bash pair and before the Termux, Debian, Ubuntu, Alpine, Fedora, Red Hat Enterprise Linux, and other-Linux checks. `uname -s` reporting `Linux` does **NOT** select macOS. `TERMUX_VERSION` does **NOT** select macOS. `/etc/os-release` `ID` does **NOT** select macOS. Homebrew installed on Linux does **NOT** select macOS.
3. This situation **MUST NOT** call `sudo`, `apt-get`, `apt`, `apk`, `pkg`, `dnf`, `pacman`, or `zypper`. Termux `pkg` is not this situation. Alpine `apk` is not this situation.
4. A missing formula named by the payload requirement **MUST** be installed with `brew install` as this login. The environment **MUST** include `HOMEBREW_NO_AUTO_UPDATE=1`. Build **MUST NOT** run `brew update`, `brew upgrade`, or `brew uninstall`. When every check already passes, build **MUST NOT** call `brew`.
5. The compiler is not a Homebrew formula. When the probe reports `gcc` or `c-headers` missing, build **MUST** stop before `brew` and before git. The message **MUST** name `xcode-select --install`. Build **MUST NOT** run `xcode-select` and **MUST NOT** call sudo for that compiler.
6. When `brew` is missing, or `brew install` exits non-zero, build **MUST** stop before git and the compile. The message **MUST** name `brew install` and the missing formulae.
7. `--msys2-root` **MUST** be rejected on macOS. The prefix **MUST NOT** be empty.
8. `help` **MUST** print without the Darwin check. It **MUST** name macOS and **MUST NOT** say the program refuses macOS. `build -h` and `build --help` **MUST** print without that check. That text **MUST** name macOS and `brew`, and **MUST** say macOS does not call sudo.
9. The Debian, Ubuntu, other-Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and Git Bash arms **MUST** remain. Those arms **MUST NOT** call this `brew` list. The Fedora and Red Hat arms **MUST** keep `dnf install -y` through the sudo wrap. This arm **MUST NOT** call Termux `pkg` or `dnf`.
10. Before the shared Unix probe, when `brew` is on `PATH`, this arm **MUST** set `TN5250_PROBE_PREFIX` to the colon-separated list `brew --prefix openssl@3`, `brew --prefix ncurses`, and `brew --prefix`, so a formula that is already installed counts as present. It **MUST** export `CMAKE_PREFIX_PATH` and `PKG_CONFIG_PATH` from those same prefixes for the shared CMake command. It **MUST NOT** pass a semicolon inside an unquoted CMake argument.
11. Build **MUST** copy the installer to `${TN5250_PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow the curses program. The default prefix is `${HOME}/.local`. Build **MUST NOT** copy the curses `tn5250`, or the other payload programs, into `${TN5250_PREFIX}/bin`. The verb `setup` may save a published client at `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save. macOS has no payload name, so `setup` stops and names `build`.
12. When `${TN5250_PREFIX}/bin` and the payload directory are not already both on `PATH`, build uses the same `~/.bashrc` marker as `docs/requirements/requirement-termux-cli-coding.md`. This file **MUST NOT** invent a second export line and **MUST NOT** write `${HOME}/.zshrc`. The default macOS shell is zsh. A zsh login sees the block only when that login sources `~/.bashrc`.
13. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists. That file is the `setup` save. Otherwise launch **MUST** execute the payload `tn5250` named by the build-payload requirement. It **MUST NOT** append `.exe` and **MUST NOT** set `MSYS_NO_PATHCONV`. A missing program **MUST** name `tn5250-cli setup` or `tn5250-cli build`.
14. `about --json` **MUST** report `payload_platform` `macos` when `uname -s` is `Darwin`. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `uname -s` is `Darwin`, after the Git Bash pair, before Termux |
| Build arm | `tn5250_setup_unix "macOS" "brew" 1` |
| Install line | `HOMEBREW_NO_AUTO_UPDATE=1 brew install` plus only the missing formulae. Not `sudo` |
| Compiler stop | `xcode-select --install` is named and not executed |
| Installer copy | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250-cli` |
| Shell start file | `${HOME}/.bashrc`, the Termux marker. Not `~/.zshrc` |
| Pointed | Compile, link, and formula names: `docs/requirements/requirement-macos-build-payload.md` |
| Refused | sudo, Termux `pkg`, copying `tn5250` into `~/.local/bin`, `brew install gcc` |

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not macOS. No macOS compile was run. `uname -s` here is not `Darwin`. The ship unit routes Darwin to `tn5250_setup_unix "macOS" "brew" 1`. That arm calls `brew install` and does not call `sudo`. The four syslog programs are optional on this arm.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): macOS detection and the `brew` call have this file. The formula table has the other file.
- **CIAO Principle 9**: `brew` runs as this login. Git and the compile stay with the person who started build.
- **CIAO Principle 2 – Intentional**: Darwin is not other Linux, and Homebrew on Linux is not macOS.

## Under command line for normal user only

macOS can have an administrator. This build does not borrow that role. Homebrew refuses a root install, and this arm does not call sudo. The person still runs git and the compile. Termux `pkg` is not called. This shell is not Git Bash and not Windows cmd.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a present toolchain does not call `brew`.
- **Intentional**: one detect string, `macos`, and one `brew install` line.
- **Anti-fragile**: the Command Line Tools compiler is not replaced with Homebrew `gcc`.
- **Over-protect**: sudo, `pkg`, and a second PATH export stay off this arm.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this file back into the payload file, or into the other-Linux requirement.
- Call `sudo` or `xcode-select` from the macOS arm.
- `brew install gcc` as the supported compiler.
- Call Termux `pkg` from the macOS arm, or call `brew` from the Termux arm.
- Auto-detect Homebrew on Linux and treat that host as macOS.
- Copy the curses client into `~/.local/bin`.
- Write a second PATH export, including one in `~/.zshrc`.
- Pass git, cmake, make, or the payload copy through sudo.
- Claim a macOS compile that was not run.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-macos-build-payload.md` | The C client build and the Homebrew formula names (RQ-MACOS-BUILD-PAYLOAD) |
| `docs/requirements/requirement-termux-cli-coding.md` | The shared bashrc marker text (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. This situation does not use it (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-other-linux.md` | Other Linux. Does not own Darwin (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | Darwin detect and the `brew` arm |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

This host is not macOS. These rows are not a macOS compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-MAC-01 | `uname -s` `Darwin` is macOS, not other Linux. `about --json` reports `payload_platform` `macos` | todo. Not executed on macOS |
| TP-MAC-02 | `tn5250-cli help` exits 0 and names macOS. `tn5250-cli build -h` exits 0, names macOS and `brew`, and does not say the program refuses macOS | ran on this Termux host as a help-text check. `tests/termux-platform.sh`. Not a macOS compile |
| TP-MAC-06 | A missing formula is `brew install` with `HOMEBREW_NO_AUTO_UPDATE=1`. A missing `gcc` stops before `brew` and names `xcode-select --install`. A present toolchain does not call `brew` | the argv is in the ship unit. Not executed on macOS |
| TP-MAC-09 | The installer is copied to `~/.local/bin`. The curses client is not. The bashrc marker is the Termux marker | the copy function is shared. Not executed on macOS |
| TP-CLI-01 | `build`, `help`, `version`, and host launch are named here and in the command map | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | macOS leaves the refused-host path. This file owns Darwin detection, `brew install` as this login, the installer copy, and launch. The C build and the formula names are RQ-MACOS-BUILD-PAYLOAD. No macOS compile was run. |

| 2026-10-13 | Active 1.0.1 | Fedora and Red Hat Enterprise Linux stay on RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. This macOS arm does not call `dnf`. The Fedora and Red Hat arms stay in the ship unit. |
| 2026-10-13 | Active 1.0.2 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.3 | Build still does not copy the client into `~/.local/bin`. macOS has no payload name, so `setup` stops and names `build`. Launch prefers a save when one exists, then the build copy. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
