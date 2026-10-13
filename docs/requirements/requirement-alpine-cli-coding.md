**file**: docs/requirements/requirement-alpine-cli-coding.md
**ID**: RQ-ALPINE-CLI-CODING
**Status**: Active (Version 1.0.5)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Alpine CLI coding requirement. It owns how the ship unit is written when the host is Alpine Linux: detection, the `apk` install through the sudo wrap, where the installer is copied, and the launch of the curses client.

It does not own the C compile, the link line, the package names, or the payload directory layout. Those belong to `docs/requirements/requirement-alpine-build-payload.md`. The sudo wrap itself belongs to `docs/requirements/requirement-shell-sudo-command.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`.

### 1.1 Human-facing

**In one sentence:** On Alpine the installer detects `ID=alpine`, installs a missing compiler package with `apk add --no-cache` through the sudo wrap, copies itself to `~/.local/bin`, and launches the curses client from the payload directory.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person on Alpine Linux, with normal user privilege | `tn5250-cli build` |
| The other role | The curses client, owned by the payload requirement | `tn5250 HOST` |
| Not this file | CMake, the `apk` package table, and the link line | `docs/requirements/requirement-alpine-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Alpine detection, `apk add --no-cache` through the sudo wrap, the copy of `tn5250-cli` into `~/.local/bin`, and the launch of the curses `tn5250` | The package names, the C compile, copying `tn5250` into `~/.local/bin`, and Termux `pkg` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the Alpine branch |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `tn5250 HOST` | the built program | a 5250 session after build |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build on Alpine | The payload requirement says what the compile must produce. This file says how the script recognizes Alpine and how it asks `apk` for a missing package | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of Alpine CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-alpine-build-payload.md`. Debian stays on `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Termux, macOS, and Git Bash stay on their own requirements. macOS stays on `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux stay on `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
2. `build` (except `build -h` and `build --help`) and launch **MUST** accept the host when `/etc/os-release` `ID` is `alpine`. That check **MUST** run after the Termux, Debian, and Ubuntu checks, and before the Fedora, Red Hat Enterprise Linux, and other-Linux checks. `VERSION_ID` is not a detect key. `ID_LIKE` containing `alpine` does **NOT** select this situation. `uname -s` reporting `Linux` does not by itself select it.
3. A missing package named by the payload requirement **MUST** be installed with `apk add --no-cache` through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, build **MUST NOT** call `apk` and **MUST NOT** call sudo. This situation **MUST NOT** call Termux `pkg`, `brew`, `apt-get`, `dnf`, `pacman`, or `zypper`.
4. When `apk` is missing, or the install exits non-zero, build **MUST** stop before git and the compile. The message **MUST** name the missing packages. Git and the compile stay with the person who started build. Help **MUST NOT** tell that person to prefix `build` with sudo.
5. `--msys2-root` **MUST** be rejected on Alpine.
6. `help` **MUST** print without the Alpine check. It **MUST** name Alpine and **MUST NOT** say the program refuses Alpine. `build -h` and `build --help` **MUST** print without that check. That text **MUST** name Alpine and `apk`.
7. The Debian, Ubuntu, other-Linux, Termux, macOS, and Git Bash arms **MUST** remain. Termux **MUST NOT** call this `apk` list. The macOS arm **MUST NOT** call this `apk` list. The Fedora and Red Hat arms **MUST** remain and **MUST** keep `dnf install -y` through the sudo wrap. This situation **MUST NOT** call Termux `pkg`, `brew`, or `dnf`.
8. Build **MUST** copy the installer to `${TN5250_PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow the curses program. The default prefix is `${HOME}/.local`. Build **MUST NOT** copy the curses `tn5250`, or the other payload programs, into `${TN5250_PREFIX}/bin`. The verb `setup` may save a published client at `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save.
9. When `${TN5250_PREFIX}/bin` and the payload directory are not already both on `PATH`, build uses the same `~/.bashrc` marker as `docs/requirements/requirement-termux-cli-coding.md`. This file **MUST NOT** invent a second export line.
10. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists. That file is the `setup` save. Otherwise launch **MUST** execute the payload `tn5250` named by the build-payload requirement. It **MUST NOT** append `.exe` and **MUST NOT** set `MSYS_NO_PATHCONV`. A missing program **MUST** name `tn5250-cli setup` or `tn5250-cli build`.
11. `about --json` **MUST** report `payload_platform` `alpine` when `ID` is `alpine`. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `/etc/os-release` `ID` `alpine`, after Termux, Debian, and Ubuntu, before other Linux |
| Install line | `apk add --no-cache` through `tn5250_run_elevated` |
| Installer copy | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250-cli` |
| Payload directory | owned by `docs/requirements/requirement-alpine-build-payload.md`. Not `~/.local/bin` |
| Shell start file | `${HOME}/.bashrc`, same marker as RQ-TERMUX-CLI-CODING |
| Refused | Termux `pkg`, a direct `apk` when the checks already pass, copying `tn5250` into `~/.local/bin`, a second `PATH` policy |

**Commands**

```bash
tn5250-cli build
tn5250-cli build --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli build --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. It does not compile.

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not Alpine. No Alpine compile was run. The ship unit routes `ID=alpine` to `tn5250_setup_unix "Alpine" "apk"`. That arm calls the sudo wrap. It does not call Termux `pkg`.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): Alpine script coding has this file. The C build has the payload file.
- **CIAO Principle 9**: `apk` may use the sudo wrap. Git and the compile stay with the person who started build.
- **CIAO Principle 2 – Intentional**: Alpine is not the other-Linux catch-all.

## Under command line for normal user only

Alpine can have an administrator. Build borrows that role only for a missing compiler package, through the sudo wrap. The person still runs git and the compile.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: `ID_LIKE=alpine` does not become this situation.
- **Intentional**: the installer lands in `~/.local/bin`. The client does not.
- **Anti-fragile**: a present toolchain does not call `apk`.
- **Over-protect**: the payload compile is not restated here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold Alpine CLI coding back into one file with the payload build, or back into the other-Linux requirement.
- Copy the curses `tn5250` into `~/.local/bin` to satisfy this file.
- Call Termux `pkg` from the Alpine arm, or call `apk` from the Termux arm.
- Call `brew` from the Alpine arm, or call `apk` from the macOS arm.
- Call `apk` or sudo when the payload requirement's checks already pass.
- Pass git, cmake, make, or the payload copy through the sudo wrap.
- Invent a second `PATH` export. The marker text stays on the Termux CLI coding requirement.
- Delete the other platform arms while editing the Alpine branch.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-alpine-build-payload.md` | The C client build and the `apk` names (RQ-ALPINE-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. Alpine uses it for `apk` only (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-termux-cli-coding.md` | The shared bashrc marker text (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-other-linux.md` | Other Linux. Does not own `ID=alpine` (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | Alpine detect and the `apk` arm |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

This host is not Alpine. These rows are not an Alpine compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-ALP-01 | `ID=alpine` is Alpine, not other Linux. `ID_LIKE` does not select Alpine. `about --json` reports `payload_platform` `alpine` | todo |
| TP-ALP-02 | `tn5250-cli help` exits 0 and names Alpine. `tn5250-cli build -h` exits 0 and names Alpine and `apk`. Neither compiles | ran on this Termux host as a help-text check. `tests/termux-platform.sh`. Not an Alpine compile |
| TP-ALP-07 | A missing package is `apk add --no-cache` through the sudo wrap. A present toolchain does not call `apk` | the argv is in the ship unit. Not executed on Alpine |
| TP-ALP-09 | The installer is copied to `~/.local/bin`. The curses client is not. The bashrc marker is the Termux marker | the copy function is shared. Not executed on Alpine |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Alpine leaves the other-Linux catch-all. This file owns detection, the `apk` call through the sudo wrap, the installer copy, and launch. The C build and the package names are RQ-ALPINE-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.0.1 | Debian stays on RQ-DEBIAN-CLI-CODING and RQ-DEBIAN-BUILD-PAYLOAD. This Alpine script is unchanged. |
| 2026-10-13 | Active 1.0.2 | macOS stays on RQ-MACOS-CLI-CODING and RQ-MACOS-BUILD-PAYLOAD. This Alpine arm does not call `brew`. The macOS arm stays in the ship unit. |

| 2026-10-13 | Active 1.0.3 | Fedora and Red Hat Enterprise Linux stay on RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. This Alpine arm does not call `dnf`. The Fedora and Red Hat arms stay in the ship unit. |
| 2026-10-13 | Active 1.0.4 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.5 | Build still does not copy the client into `~/.local/bin`. `setup` may. Launch prefers that save, then the build copy. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
