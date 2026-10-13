**file**: docs/requirements/requirement-windows-git-bash-cli-coding.md
**ID**: RQ-WINDOWS-GIT-BASH-CLI-CODING
**Status**: Active (Version 1.0.6)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Git Bash CLI coding requirement. It owns how the ship unit is written when the host is Windows Git Bash: detection, the refusal of other shells, the `cmd.exe` isolation that starts MSYS2, the refusal of sudo and Termux `pkg`, where the installer is copied, and the launch of `tn5250.exe`.

It does not own the C compile, the link line, the UCRT64 package names, or the payload directory layout. Those belong to `docs/requirements/requirement-windows-git-bash-build-payload.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`.

### 1.1 Human-facing

**In one sentence:** In Git Bash the installer detects that shell, starts MSYS2 only through `cmd.exe //c`, copies itself to `~/.local/bin`, and launches `tn5250.exe` from the payload directory.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person in Git Bash, with normal user privilege | `tn5250-cli build` |
| The other role | The three Windows programs, owned by the payload requirement | `tn5250.exe` opens its own window |
| Not this file | CMake, UCRT64 packages, and the GCC 14 patch | `docs/requirements/requirement-windows-git-bash-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Git Bash detection, `cmd.exe //c` isolation, no sudo, the copy of `tn5250-cli` into `~/.local/bin`, and the launch of `tn5250.exe` | The UCRT64 link line, the package table, and copying `tn5250.exe` into `~/.local/bin` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the Git Bash branch |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `tn5250 HOST` | the built program | a 5250 session after build |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build on Git Bash | The payload requirement says what the compile must produce. This file says how the script recognizes Git Bash and how it starts MSYS2 | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of Git Bash CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-windows-git-bash-build-payload.md`. Debian stays on `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS stay on their own requirements. macOS stays on `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux stay on `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
2. The supported host is Git Bash on Windows x86_64. `build` (except `build -h` and `build --help`) and launch **MUST** continue only when both checks match: `OSTYPE` is `msys*` or `mingw*`, and `uname -s` is `MINGW*` or `MSYS*`. Otherwise they **MUST** exit non-zero and the message **MUST** name Git Bash on Windows. `version` is not this detect. A `/c` directory test is not a substitute for this pair.
3. `help` and `build --help` **MUST** print without that check.
4. WSL, Windows cmd, Cygwin, Termux, macOS, Fedora, and Red Hat Enterprise Linux are not this shell. This situation **MUST NOT** claim them, **MUST NOT** call Termux `pkg`, **MUST NOT** call `brew`, and **MUST NOT** call `dnf`. Termux is owned by `docs/requirements/requirement-termux-cli-coding.md` and `docs/requirements/requirement-termux-build-payload.md`. macOS is owned by `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux are owned by `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
5. Build **MUST NOT** invoke sudo, apt, dnf, or a dedicated system user. It writes under the user's prefix and the user's cache.
6. When the toolchain is an MSYS2 tree, package installs and other MSYS2 shell work **MUST** run as that tree's `usr/bin/bash.exe --login`, with Git Bash not the parent of that bash. The parent **MUST** be `cmd.exe` invoked as `cmd.exe //c`. The child **MUST** clear `MSYSTEM` and `CHERE_INVOKING` before starting MSYS2 bash. A single `/c` is forbidden. Windows cmd is only that short-lived parent. It is not the shell that configures CMake.
7. An explicit `--msys2-root` or `TN5250_MSYS2_ROOT` **MUST** point at a tree that already contains `usr/bin/bash.exe`, or build stops. `curl` **MUST** be present when a download of the private tree is required. The private tree path and the package names are owned by the payload requirement.
8. Build **MUST** copy the installer to `${PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow `tn5250.exe`. The default prefix is `${HOME}/.local`. The prefix **MUST** be converted with `cygpath -u` and **MUST NOT** be empty. Build **MUST NOT** copy `tn5250.exe`, `lp5250d.exe`, or `dftmap.exe` into `${PREFIX}/bin`. The verb `setup` may save a published client at `${PREFIX}/bin/tn5250.exe`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save.
9. When `${PREFIX}/bin` and the payload directory are not already both on `PATH`, build uses the same `~/.bashrc` marker as `docs/requirements/requirement-termux-cli-coding.md`. This file **MUST NOT** invent a second export line.
10. Launch **MUST** set `MSYS_NO_PATHCONV=1`. It **MUST** prefer `${PREFIX}/bin/tn5250.exe` when that file exists. That file is the `setup` save. Otherwise it **MUST** execute the payload `tn5250.exe`. A missing exe **MUST** stop with `tn5250 is not installed in this Git Bash yet. Next: tn5250-cli setup, or tn5250-cli build`.
11. There is no text screen in this installer. Help does not compile. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `OSTYPE` `msys*` or `mingw*`, and `uname -s` `MINGW*` or `MSYS*` |
| Installer copy | `${PREFIX}/bin/tn5250-cli`. Default prefix `${HOME}/.local` |
| Payload directory | owned by the build-payload requirement. Not `~/.local/bin` |
| MSYS2 parent | `cmd.exe //c` |
| Shell start file | `${HOME}/.bashrc`, same marker as RQ-TERMUX-CLI-CODING |
| Refused | sudo, apt, dnf, Termux `pkg`, a direct child `bash.exe`, copying the exe files into `bin` |

**Commands**

```bash
tn5250-cli build
tn5250-cli build --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli build --msys2-root "${HOME}/.local/opt/msys64" --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. It does not compile.

**Softer current behavior.** These are facts. They are not extra fail-closed rules.

| Topic | What the script does today |
|-------|----------------------------|
| Toolchain search order | Explicit `--msys2-root`, else `${HOME}/.local/opt/msys64`, else `/c/msys64`, else `/c/tools/msys64`, else `gcc` and `cmake` already on `PATH`, else download the private tree |
| System MSYS2 trees | If `/c/msys64` or `/c/tools/msys64` is chosen and a payload toolchain file is missing, the script runs `pacman -Syu` on that tree through the isolation above |
| `pacman -Syu` errors | Each of the two updates ignores its own exit status. The payload requirement's later check still stops if gcc, cmake, or ninja is missing |

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): Git Bash script coding has this file. The Windows C build has the payload file.
- **CIAO Principle 9**: sudo and a dedicated system user stay unused. `cmd.exe` is only the MSYS2 parent.

## Under command line for normal user only

Git Bash is the shell this requirement detects. The person acts with normal user privilege. Build does not call sudo, apt, dnf, or Termux `pkg`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: WSL, cmd, Cygwin, and Termux are not this shell.
- **Intentional**: the installer lands in `~/.local/bin`. The exe files do not.
- **Anti-fragile**: MSYS2 bash is not a child of Git Bash.
- **Over-protect**: the payload compile is not restated here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold Git Bash CLI coding back into one file with the payload build.
- Copy `tn5250.exe` into `~/.local/bin` to satisfy this file.
- Start MSYS2 `bash.exe` as a direct child of Git Bash, or invoke `cmd.exe` with a single `/c`.
- Call sudo, apt, dnf, or Termux `pkg` from this situation.
- Delete the other platform arms while editing the Git Bash branch.
- Invent a second `PATH` export. The marker text stays on the Termux CLI coding requirement.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-windows-git-bash-build-payload.md` | The Windows C build (RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD) |
| `docs/requirements/requirement-termux-cli-coding.md` | The shared bashrc marker text (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-alpine-cli-coding.md` | Alpine CLI coding. Not this shell (RQ-ALPINE-CLI-CODING) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX writing style (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `src/tn5250-cli` | Git Bash detect, isolation, and installer copy |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

This host is not Git Bash. These rows are not a Windows compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-WGB-01 | build and launch stop when `OSTYPE` or `uname -s` is outside the Git Bash pair. version still prints the CLI line | ran on the authoring host. Not a Windows compile |
| TP-WGB-02 | `tn5250-cli help` and `tn5250-cli build -h` exit 0 without that detect | ran on the authoring host |
| TP-WGB-07 | MSYS2 bash is started with `cmd.exe //c`, with `MSYSTEM` and `CHERE_INVOKING` cleared | todo |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Git Bash

**Definition:** Git Bash is an instance of command line for normal user only. It is the MSYS/MINGW POSIX shell shipped with Git for Windows. The environment's primary detect is a `/c/` or `/c` directory. Secondary signals are `MSYSTEM` matching `MINGW*`, `MSYS*`, `UCRT*`, or `CLANG*`, or `uname -s` matching `MINGW*` or `MSYS*`. WSL is excluded (`WSL_DISTRO_NAME`). The ship unit's check is the `OSTYPE` plus `uname -s` pair above. Git Bash has no Termux `pkg`.

**Human daily-life explanation:** Git Bash is a Windows drawer that only opens with your keys. It looks like a Unix shell. It is not a Linux superintendent desk.

**Daily-life example:** You run git and this program as yourself. The program must not grow sudo apt or a dedicated system-user switch because you opened Git Bash.

Must not confuse Git Bash with Termux, Windows cmd, Cygwin, WSL, a Git object store, or the `winpty` console helper.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from RQ-WINDOWS-GIT-BASH 1.3.4. This file owns detection on Windows x86_64, `cmd.exe` isolation, the installer copy, and launch. The C build moved to RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.0.1 | Alpine stays on RQ-ALPINE-CLI-CODING and RQ-ALPINE-BUILD-PAYLOAD. This Git Bash script is unchanged. |
| 2026-10-13 | Active 1.0.2 | Debian stays on RQ-DEBIAN-CLI-CODING and RQ-DEBIAN-BUILD-PAYLOAD. This Git Bash script is unchanged. |
| 2026-10-13 | Active 1.0.3 | macOS is not Git Bash. macOS stays on RQ-MACOS-CLI-CODING and RQ-MACOS-BUILD-PAYLOAD. This Git Bash script does not call `brew`. |

| 2026-10-13 | Active 1.0.4 | Fedora and Red Hat Enterprise Linux are not Git Bash. They stay on RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. This Git Bash script does not call `dnf`. |
| 2026-10-13 | Active 1.0.5 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.6 | Build still does not copy `tn5250.exe` into the prefix `bin`. `setup` may. Launch prefers that save, then the payload exe, and still sets `MSYS_NO_PATHCONV`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
