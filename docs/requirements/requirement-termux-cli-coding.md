**file**: docs/requirements/requirement-termux-cli-coding.md
**ID**: RQ-TERMUX-CLI-CODING
**Status**: Active (Version 1.0.6)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Termux CLI coding requirement. It owns how the ship unit is written when the host is Termux: detection, the `pkg` call, the refusal of sudo and Linux `apt`, help text, where the installer is copied, and the shell-start `PATH` marker.

It does not own the C compile, the link line, the package names, or the payload directory layout. Those belong to `docs/requirements/requirement-termux-build-payload.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`. Command names belong to `docs/requirements/requirement-shell-cli-interface.md`.

### 1.1 Human-facing

**In one sentence:** On Termux the installer script detects this phone, calls `pkg` as this login, copies itself to `~/.local/bin`, and adds that directory plus the payload directory to `PATH` in `~/.bashrc`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person editing or running the installer on Termux | `tn5250-cli build` |
| The other role | The built curses client, owned by the payload requirement | `tn5250 HOST` |
| Not this file | CMake, ncurses, OpenSSL, and the package table | `docs/requirements/requirement-termux-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Termux detection, the `pkg install -y` call, no sudo, the copy of `tn5250-cli` into `~/.local/bin`, and the `~/.bashrc` `PATH` marker | The C compiler, the link line, and copying `tn5250` into `~/.local/bin` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the Termux branch |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `~/.bashrc` | the shell start script | the marked `PATH` block |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open a new shell after build | The installer is on `PATH`, and so is the payload directory. The client file itself stays under `opt/tn5250` | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of Termux CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-termux-build-payload.md`. Debian stays on `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Alpine, macOS, and Git Bash stay on their own requirements. macOS stays on `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux stay on `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
2. `build` (except `build -h` and `build --help`) and launch **MUST** accept the host when `TERMUX_VERSION` is set and not empty. That check **MUST** run after the Git Bash pair and the Darwin check, and before the Debian, Ubuntu, Alpine, Fedora, Red Hat Enterprise Linux, and other-Linux checks. `uname -s` reporting `Darwin` is macOS, not Termux. `uname -s` reporting `Linux` does not make Termux the other-Linux situation, and it does not make Termux Alpine.
3. The presence of `apt-get` on a Termux `PATH` **MUST NOT** select the Debian or other-Linux package family. This situation **MUST NOT** call `apt-get`, `apt`, `sudo`, `apk`, `brew`, `dnf`, `pacman`, or `zypper`. Alpine's `apk` call is not this situation. macOS `brew` is not this situation.
4. A missing package named by the payload requirement **MUST** be installed with `pkg install -y` as this login. When every check already passes, build **MUST NOT** call `pkg`. Build **MUST NOT** run `pkg upgrade`, `pkg uninstall`, or an interactive search.
5. When `pkg` is missing, or `pkg install` exits non-zero, build **MUST** stop before git and the compile. The message **MUST** name `pkg install -y` and the missing packages.
6. `--msys2-root` **MUST** be rejected on Termux.
7. `help` and `build --help` **MUST** print without the Termux check. The text **MUST** name Termux and `pkg` and **MUST NOT** say the program refuses Termux.
8. The Debian, Ubuntu, other-Linux, Alpine, macOS, and Git Bash arms **MUST** remain in the ship unit. Those arms **MUST NOT** call this `pkg` list. The Alpine arm **MUST** keep `apk` through the sudo wrap. The macOS arm **MUST** keep `brew` and **MUST NOT** call the sudo wrap. The Fedora and Red Hat arms **MUST** keep `dnf install -y` through the sudo wrap. This arm **MUST NOT** call `apk`, `brew`, or `dnf`.
9. Build **MUST** copy the installer to `${TN5250_PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow the curses program. The default prefix is `${HOME}/.local`, so the installed command is `${HOME}/.local/bin/tn5250-cli`. Build **MUST NOT** copy the installer into the Termux userspace `PREFIX`.
10. Build **MUST NOT** copy the curses `tn5250`, or the other payload programs, into `${TN5250_PREFIX}/bin`. Those files stay in the payload directory owned by the build-payload requirement. The verb `setup` may save a published client at `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save.
11. When `${TN5250_PREFIX}/bin` and the payload directory are not already both on `PATH`, build **MUST** append this marked block to `${HOME}/.bashrc`, and **MUST NOT** append a second block when the marker is already present. The payload directory comes first.

```text
# >>> tn5250 >>>
export PATH="<payload-directory>:<prefix>/bin:$PATH"
# <<< tn5250 <<<
```

Build **MUST NOT** edit `${HOME}/.profile` for this marker. A bash login sees the block only when that login sources `~/.bashrc`.
12. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists. That file is the `setup` save. Otherwise launch **MUST** execute the payload `tn5250` named by the build-payload requirement. It **MUST NOT** append `.exe` and **MUST NOT** set `MSYS_NO_PATHCONV`. A missing program **MUST** name `tn5250-cli setup` or `tn5250-cli build`.
13. `about --json` **MUST** report `payload_platform` `termux` when `TERMUX_VERSION` is set. It **MUST** also report `payload_arch`, `payload_clib`, and `termux_version`. `TERMUX_VERSION` is the environment variable. This file does not calculate it, and it is not part of the payload filename. How arch and the C library are collected stays on `docs/requirements/requirement-payload-filename.md`. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `TERMUX_VERSION` set and not empty, before Debian, Ubuntu, Alpine, and other Linux |
| Installer copy | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250-cli` |
| Payload directory | owned by `docs/requirements/requirement-termux-build-payload.md`. Not `~/.local/bin` |
| Shell start file | `${HOME}/.bashrc` |
| Marker | `# >>> tn5250 >>>` through `# <<< tn5250 <<<` |
| `pkg` line | `pkg install -y` plus only the missing names from the payload requirement |
| Pointed | Shebang and `set -u`: `docs/requirements/requirement-shell-script-coding.md`. Compile and link: `docs/requirements/requirement-termux-build-payload.md` |
| Refused | sudo, Linux `apt`, copying `tn5250` into `~/.local/bin`, a second `PATH` policy in the coding-style file |

### 2.2 Current script behavior

On 2026-10-13 this Termux host had `tn5250-cli` at `~/.local/bin/tn5250-cli`. The curses client was not in that directory. `~/.bashrc` contained the marker and exported the payload directory, then `~/.local/bin`, then the previous `PATH`. This shell resolved `tn5250-cli` from `~/.local/bin` and `tn5250` from the payload directory. `~/.profile` already sourced `~/.bashrc`. Build did not write that profile line.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): Termux script coding has this file. The C build has the payload file.
- **CIAO Principle 2 – Intentional**: the installer location and the shell-start marker are written down.
- **CIAO Principle 9**: `pkg` as this login is not admin privilege.

## Under command line for normal user only

On Termux the person runs the installer as this login. The shell-start change is an edit to that login's `~/.bashrc`, not a system profile.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: `apt-get` on Termux does not select the apt arm.
- **Intentional**: the CLI lands in `~/.local/bin`. The client does not.
- **Anti-fragile**: a present marker is not appended again.
- **Over-protect**: the payload compile is not restated here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold Termux CLI coding back into one file with the payload build.
- Copy the curses `tn5250` into `~/.local/bin` to satisfy this file.
- Call `sudo` or Linux `apt` from the Termux arm.
- Call `pkg` when the payload requirement's checks already pass.
- Delete the other platform arms while editing the Termux branch.
- Grow a second `PATH` policy in `docs/requirements/requirement-shell-script-coding.md`.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-termux-build-payload.md` | The C client build (RQ-TERMUX-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX writing style. Does not own this marker (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. Termux does not use it (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-alpine-cli-coding.md` | Alpine `apk` through that wrap. Not this file (RQ-ALPINE-CLI-CODING) |
| `src/tn5250-cli` | `tn5250_install_cli` and the Termux build arm |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-TMX-01 | A set `TERMUX_VERSION` is Termux, not other Linux, and `about --json` reports `payload_platform` `termux` | ran. `tests/termux-platform.sh` |
| TP-TMX-02 | `build -h` exits 0, names Termux and `pkg`, and does not compile | ran. Exit 0 |
| TP-TMX-06 | A missing package is installed with `pkg install -y` and not with sudo. A present toolchain does not call `pkg` | ran. First setup installed `cmake`. Second setup did not call `pkg` |
| TP-TMX-07 | Debian, Ubuntu, other Linux, Alpine, and Git Bash case arms remain | ran as a source read, also checked by `tests/termux-platform.sh` |
| TP-TMX-09 | The installer is in `~/.local/bin`. The client is not. `~/.bashrc` has the `PATH` marker | ran on this host. `tn5250-cli` is `~/.local/bin/tn5250-cli`. `tn5250` resolves from the payload directory |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from the single Termux requirement. This file owns detection, `pkg`, the installer copy, and the bashrc marker. The C build moved to RQ-TERMUX-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.0.1 | Alpine is a neighbor, owned by RQ-ALPINE-CLI-CODING. Termux still does not call `apk` or the sudo wrap. The Alpine arm stays in the ship unit. |
| 2026-10-13 | Active 1.0.2 | Debian stays on RQ-DEBIAN-CLI-CODING and RQ-DEBIAN-BUILD-PAYLOAD. Termux still does not call `apt-get` or the sudo wrap. |
| 2026-10-13 | Active 1.0.3 | Darwin is checked before Termux. macOS stays on RQ-MACOS-CLI-CODING and RQ-MACOS-BUILD-PAYLOAD. Termux still does not call `brew`. |

| 2026-10-13 | Active 1.0.4 | Fedora and Red Hat Enterprise Linux stay on RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. Termux still does not call `dnf`. Those arms stay in the ship unit. |
| 2026-10-13 | Active 1.0.5 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.6 | Build still does not copy `tn5250` into `~/.local/bin`. `setup` may. Launch prefers that save, then the build copy. `TERMUX_VERSION` is the environment variable and is not calculated. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
