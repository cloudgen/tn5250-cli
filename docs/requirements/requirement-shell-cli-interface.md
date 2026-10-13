**file**: docs/requirements/requirement-shell-cli-interface.md
**ID**: RQ-SHELL-CLI-INTERFACE
**Status**: Active (Version 1.9.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file names the commands of `tn5250-cli` and says which other requirement owns each command’s behavior. It is the dispatcher map. It is not the build manual.

Empty argv is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. Type 0 lifecycle verbs are owned by `docs/requirements/requirement-shell-self-management.md`. The domain catalog for `build` and the host launch is owned by `docs/requirements/requirement-domain-tn5250.md`. Compilation, link, and build stay on `docs/requirements/requirement-windows-git-bash-build-payload.md`, `docs/requirements/requirement-debian-build-payload.md`, `docs/requirements/requirement-ubuntu.md`, `docs/requirements/requirement-other-linux.md`, `docs/requirements/requirement-alpine-build-payload.md`, `docs/requirements/requirement-termux-build-payload.md`, `docs/requirements/requirement-macos-build-payload.md`, and `docs/requirements/requirement-fedora-redhat-build-payload.md`. Git Bash CLI coding stays on `docs/requirements/requirement-windows-git-bash-cli-coding.md`. Debian CLI coding stays on `docs/requirements/requirement-debian-cli-coding.md`. Alpine CLI coding stays on `docs/requirements/requirement-alpine-cli-coding.md`. Termux CLI coding stays on `docs/requirements/requirement-termux-cli-coding.md`. macOS CLI coding stays on `docs/requirements/requirement-macos-cli-coding.md`. Fedora and Red Hat Enterprise Linux CLI coding stays on `docs/requirements/requirement-fedora-redhat-cli-coding.md`. Output flags point at `docs/requirements/requirement-shell-output-requirements.md`. This file does not restate those bodies.

### 1.1 Human-facing

**In one sentence:** A person runs the Type 0 verbs, `tn5250-cli setup`, `tn5250-cli build`, `tn5250-cli help`, `tn5250-cli version`, `tn5250-cli menu`, or `tn5250-cli HOST`. With no command, a terminal opens the numbered list and a pipe places the CLI. On Git Bash, CLI coding and the Windows build are the two Git Bash requirements. On Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, or macOS the Unix build is in that platform’s requirement.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person typing in the shell, with normal user privilege | `tn5250-cli help` |
| The other role | The upstream TN5250 program, after the build has produced it | `tn5250-cli myibmi.example.com` |
| Not this file | Generators, libraries, and packages for each platform | `docs/requirements/requirement-windows-git-bash-cli-coding.md`, `docs/requirements/requirement-windows-git-bash-build-payload.md`, `docs/requirements/requirement-debian-cli-coding.md`, `docs/requirements/requirement-debian-build-payload.md`, `docs/requirements/requirement-ubuntu.md`, `docs/requirements/requirement-other-linux.md`, `docs/requirements/requirement-alpine-cli-coding.md`, `docs/requirements/requirement-alpine-build-payload.md`, `docs/requirements/requirement-termux-cli-coding.md`, and `docs/requirements/requirement-termux-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| The command map, empty-argv’s pointer, and the rule that build’s flags are flags | The CMake arguments, the link line, the numbered list’s rows, and a field-by-field question walk |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | dispatcher |
| `tn5250-cli help` | usage text | the command list |
| `tn5250-cli build` | build command | behavior owned by the detected platform requirement |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Ask what commands exist | Help lists the Type 0 verbs, setup, build, help, version, and a host launch. Setup downloads a published client. Build compiles and links | `tn5250-cli help` |

## 2. Core Rules / Requirements (Mandatory)

1. The ship unit **MUST** expose one dispatcher. The first token selects the command. `app_main` **MUST** run even when the script is read on a pipe.
2. `build`, `help`, `version`, and the host launch **MUST** also be named, with a full sample, on the platform requirement that owns that run: `docs/requirements/requirement-windows-git-bash-cli-coding.md` and `docs/requirements/requirement-windows-git-bash-build-payload.md` for Git Bash, `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md` for Debian 12 and 13, `docs/requirements/requirement-ubuntu.md` for Ubuntu 22.04, 24.04, and 26.04, `docs/requirements/requirement-other-linux.md` for other Linux, `docs/requirements/requirement-alpine-cli-coding.md` and `docs/requirements/requirement-alpine-build-payload.md` for Alpine, `docs/requirements/requirement-termux-cli-coding.md` and `docs/requirements/requirement-termux-build-payload.md` for Termux, `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md` for macOS, `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md` for Fedora and Red Hat Enterprise Linux. The Type 0 verbs **MUST** also be named on `docs/requirements/requirement-shell-self-management.md`. Empty argv **MUST** also be named on `docs/requirements/requirement-shell-cli-zero-arguments.md`. Help text in the script is not that second mention.
3. There are **no** test-purpose commands. Every command below is a command that runs the product.
4. No command after the program name is empty argv. A switch such as `--debug` is still no command. Non-interactive empty argv places the CLI binary. Interactive empty argv opens the numbered list. `--json` or `--quiet` with no command is the non-interactive place, not the list and not help. That behavior is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md` and, for the list, by `docs/requirements/requirement-shell-cli-default-interaction.md`. Empty argv **MUST NOT** start `build` or CMake.
5. `help`, `-h`, and `--help` as the first token **MUST** show usage and exit 0. They do not require a platform check.
6. `build -h` and `build --help` **MUST** show usage and exit 0 before any platform check.
7. `build` with any other arguments **MUST** perform the build for the detected platform. Git Bash uses the Git Bash CLI coding requirement and the Git Bash payload requirement. Debian 12 and Debian 13 use the Debian CLI coding requirement and the Debian payload requirement. Ubuntu 22.04, 24.04, and 26.04 use the Ubuntu requirement. Other Linux uses the other-Linux requirement. Alpine uses the Alpine CLI coding requirement and the Alpine payload requirement. Termux uses the Termux CLI coding requirement and the Termux payload requirement. macOS uses the macOS CLI coding requirement and the macOS payload requirement. Fedora and Red Hat Enterprise Linux use RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. A machine that matches none of those **MUST** stop with a non-zero status. This file **MUST NOT** define the compiler, the generator, the link libraries, or the package list.
8. Build options are flags and environment variables. The ship unit **MUST NOT** ask for those fields one at a time on the terminal. A missing flag keeps its default. Non-interactive use **MUST NOT** wait for a prompt.
9. `version`, `--version`, and `-V` **MUST** print the CLI version from `VERSION`, then the payload line when the `REF` and `REVISION` files exist. A missing payload **MUST** warn and **MUST NOT** be a fatal error by itself. Version **MUST NOT** require a platform detect. The payload line is `tn5250 <ref> (<revision>)`.
10. A first token that is not a known flag and not a named verb **MUST** be treated as the host name and **MUST** launch the built `tn5250` program for that platform. On Git Bash that program is `tn5250.exe`. On Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS it is the curses `tn5250`. That token is not an unknown-command error. A leading `-` or `--` that is not a known flag **MUST** fail with a non-zero status. The token `setup` is a named verb. It **MUST** download a published client as `docs/requirements/requirement-payload-filename.md` requires. It **MUST NOT** compile, and it **MUST NOT** be passed to the client as a host name. `build` still compiles.
11. An unknown token after `build` **MUST** fail with a non-zero status and mention `tn5250-cli build --help`.
12. There is **no** path-and-clock screen inside this installer. The numbered list, when a terminal has no command, is owned by `docs/requirements/requirement-shell-cli-default-interaction.md`. On Git Bash the upstream program opens its own window. On Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS the curses program runs in the current terminal. There is no path-and-clock menu and no bottom input box.
13. The global flags `--quiet`, `--json`, `--force`, and `--debug` exist. A leading flag is not a host name. The output contract, including JSON, is owned by `docs/requirements/requirement-shell-output-requirements.md`. This file **MUST NOT** define the JSON grammar. `tn5250-cli --quiet HOST` is global quiet, then launch. `tn5250-cli HOST --quiet` passes `--quiet` to the emulator.
14. Help **MUST** list `install`, `self-install`, `menu`, `main`, `version-check`, `self-update`, `self-uninstall`, `about`, `help`, `version`, `setup`, `build`, and the host launch. Help **MUST** say that setup downloads a published client and that build compiles one. Help **MUST** say that a terminal with no command opens the numbered list and that a pipe, `--quiet`, or `--json` places this CLI. Help **MUST** say that this installer remains `tn5250-cli`. Help **MUST NOT** list `CHECKSUM`. Help **MUST NOT** name another product’s channel. `about` **MUST** include `payload_arch` and `payload_clib` as `docs/requirements/requirement-payload-filename.md` requires.

### 2.1 Implementation Notes (this project)

| First token | Kind | Sample | Behavior owner |
|-------------|------|--------|----------------|
| (none) | runs the product | `tn5250-cli` | `docs/requirements/requirement-shell-cli-zero-arguments.md`. A pipe places the CLI. A terminal opens the list. Not `build` |
| `install`, `self-install`, `version-check`, `self-update`, `self-uninstall`, `about` | runs the product | `tn5250-cli about` | `docs/requirements/requirement-shell-self-management.md`. `self-install` places the CLI the same way as `install` |
| `menu`, `main` | runs the product | `tn5250-cli menu` | `docs/requirements/requirement-shell-cli-default-interaction.md`. Needs a terminal |
| `setup` | runs the product | `tn5250-cli setup` | Download: `docs/requirements/requirement-payload-filename.md`. Catalog: `docs/requirements/requirement-domain-tn5250.md`. `setup` does not compile |
| `build` | runs the product | `tn5250-cli build` | Catalog: `docs/requirements/requirement-domain-tn5250.md`. Git Bash CLI coding: `docs/requirements/requirement-windows-git-bash-cli-coding.md`. Git Bash build: `docs/requirements/requirement-windows-git-bash-build-payload.md`. Debian CLI coding: `docs/requirements/requirement-debian-cli-coding.md`. Debian build: `docs/requirements/requirement-debian-build-payload.md`. Ubuntu build: `docs/requirements/requirement-ubuntu.md`. Other Linux build: `docs/requirements/requirement-other-linux.md`. Alpine CLI coding: `docs/requirements/requirement-alpine-cli-coding.md`. Alpine build: `docs/requirements/requirement-alpine-build-payload.md`. Termux CLI coding: `docs/requirements/requirement-termux-cli-coding.md`. Termux build: `docs/requirements/requirement-termux-build-payload.md`. macOS CLI coding: `docs/requirements/requirement-macos-cli-coding.md`. macOS build: `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat CLI coding: `docs/requirements/requirement-fedora-redhat-cli-coding.md`. Fedora and Red Hat build: `docs/requirements/requirement-fedora-redhat-build-payload.md` |
| `help`, `-h`, `--help` | runs the product | `tn5250-cli help` | This file for the usage list. Each platform file names the same sample. Help does not require a platform check |
| `version`, `--version`, `-V` | runs the product | `tn5250-cli version` | This file for the CLI line. Payload line `tn5250 <ref> (<revision>)` when both files exist. A missing payload warns |
| anything else that is not a flag | runs the product | `tn5250-cli myibmi.example.com` | The platform file. Git Bash executes `tn5250.exe`. Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS execute the curses `tn5250` |

Build flags, all optional: `--prefix` / `TN5250_PREFIX`, `--ref` / `TN5250_REF`, `--jobs` / `TN5250_JOBS`, `--force`. Equals forms are accepted. `--quiet`, `--json`, and `--debug` are accepted after `build`. `--msys2-root` / `TN5250_MSYS2_ROOT` is legal only for the Git Bash build. The Debian, Ubuntu, other-Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS requirements reject it. Defaults and legal values are build law on the platform requirement.

The Debian, Ubuntu, other-Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS branches are in the ship unit. On Debian, Ubuntu, other Linux, Alpine, Fedora, and Red Hat Enterprise Linux, missing compiler packages use the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. On Alpine the `apk` call is owned by `docs/requirements/requirement-alpine-cli-coding.md` and the package names by `docs/requirements/requirement-alpine-build-payload.md`. On Fedora and Red Hat Enterprise Linux the `dnf` call is owned by `docs/requirements/requirement-fedora-redhat-cli-coding.md` and the package names by `docs/requirements/requirement-fedora-redhat-build-payload.md`. On Termux, missing compiler packages use `pkg` as this login, owned by `docs/requirements/requirement-termux-cli-coding.md`. The package names are owned by `docs/requirements/requirement-termux-build-payload.md`. On macOS, missing formulae use `brew` as this login and do not call sudo. That call is owned by `docs/requirements/requirement-macos-cli-coding.md`. The formula names are owned by `docs/requirements/requirement-macos-build-payload.md`. Git and the compile stay with the person who started build. The authoring host is Ubuntu 24.04 (noble). The last build command on that host is recorded in `docs/requirements/requirement-ubuntu.md` §2.8. `self-uninstall` removes the CLI binary. It does not remove the payload directory.

No command is a test-purpose verb.

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): command names have one map, and the build has one owner.
- **CIAO Principle 2 – Intentional**: each token has one route.
- **CIAO Principle 16**: build does not invent a question walk. Flags are enough.
- **CIAO Principle 21**: this file names `build`. The platform file specifies it.

## Under command line for normal user only

The person runs these commands with normal user privilege.

**This requirement:** on Git Bash the tool does not call the sudo wrap. On Debian, Ubuntu, other Linux, Alpine, Fedora, and Red Hat Enterprise Linux the only wrap is build’s package install, owned by `docs/requirements/requirement-shell-sudo-command.md`. On Debian that install is `apt-get`, and the names stay on the Debian payload requirement. On Alpine that install is `apk add --no-cache`, and the names stay on the Alpine payload requirement. On Fedora and Red Hat Enterprise Linux that install is `dnf install -y`, and the names stay on the Fedora and Red Hat payload requirement. The same `build` verb is the mixed elevated sudo model for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. Git and the compile are not wrapped and do not stay root. On Termux, build’s missing packages use `pkg` as this login. That is not the sudo wrap, and Git Bash and Windows cmd do not call it. On macOS, build’s missing formulae use `brew` as this login. That is not the sudo wrap. Help and version may run in another shell and only print text. Build and launch require Git Bash, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, or macOS, as specified by that platform requirement. Windows cmd is not this dispatcher’s shell.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a token that is not a flag and not a named verb is a host name, and the requirement says so.
- **Intentional**: build’s build is pointed at the requirement for the machine that was detected.
- **Anti-fragile**: a pipe with no command places or confirms the CLI binary, and it does not start CMake.
- **Over-protect**: this file refuses to grow a second copy of the link line.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Leave `build`, `help`, `version`, or the host launch named only in this file.
- Paste the CMake generator, the link libraries, the package names, or the GCC fixes into this file.
- Add a path-and-clock screen, a field-by-field build interview, or a test-purpose command.
- Treat `tn5250-cli` with no arguments as help, or as `build`.
- Treat a pipe with no command as the numbered list.
- Drop `install`, `version-check`, `self-update`, `self-uninstall`, or `about`.
- Add sudo outside the package wrap, or pass git or the compile through sudo.
- List `CHECKSUM` in help, or point help at another product’s channel.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-windows-git-bash-cli-coding.md` | Git Bash detect, installer path, launch, and the second naming of every command (RQ-WINDOWS-GIT-BASH-CLI-CODING) |
| `docs/requirements/requirement-windows-git-bash-build-payload.md` | Git Bash compilation, link, and build (RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD) |
| `docs/requirements/requirement-debian-cli-coding.md` | Debian detect, the `apt-get` call, installer path, launch, and the second naming of every command (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | Debian compilation, link, and build (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu detect, compilation, link, build, and the second naming of every command (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux detect, compilation, link, build, and the second naming of every command (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-alpine-cli-coding.md` | Alpine detect, the `apk` call, installer path, launch, and the second naming of every command (RQ-ALPINE-CLI-CODING) |
| `docs/requirements/requirement-alpine-build-payload.md` | Alpine compilation, link, and build (RQ-ALPINE-BUILD-PAYLOAD) |
| `docs/requirements/requirement-macos-cli-coding.md` | macOS detect, the `brew` call, installer path, launch, and the second naming of every command (RQ-MACOS-CLI-CODING) |
| `docs/requirements/requirement-macos-build-payload.md` | macOS compilation, link, and build (RQ-MACOS-BUILD-PAYLOAD) |
| `docs/requirements/requirement-fedora-redhat-cli-coding.md` | Fedora and Red Hat detect, the `dnf` call, installer path, launch, and the second naming of every command (RQ-FEDORA-REDHAT-CLI-CODING) |
| `docs/requirements/requirement-fedora-redhat-build-payload.md` | Fedora and Red Hat compilation, link, and build (RQ-FEDORA-REDHAT-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Numbered list (RQ-SHELL-CLI-DEFAULT-INTERACTION) |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-shell-output-requirements.md` | Output and JSON (RQ-SHELL-OUTPUT-REQUIREMENTS) |
| `docs/requirements/requirement-domain-tn5250.md` | Domain catalog (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-sudo-command.md` | The one sudo wrap for build’s missing compiler packages (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual (RQ-CLASS-SOFTWARE-DEV) |
| `src/tn5250-cli` | Dispatcher |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-CLI-01 | `build`, `help`, `version`, and host launch are named in this file and in each platform requirement | ran as a document check |
| TP-CLI-05 | On Debian 12 or 13, `build` is routed to the Debian CLI coding requirement and the Debian payload requirement and does not start the Windows toolchain | todo |
| TP-CLI-06 | On Ubuntu 22.04, 24.04, or 26.04, `build` is routed to the Ubuntu requirement and does not start the Windows toolchain | ran for 24.04 noble on the authoring host. The log says `Installing tn5250 v0.18.0 for Ubuntu`. 22.04 and 26.04 were not executed |
| TP-CLI-07 | On other Linux, `build` is routed to the other-Linux requirement and does not start the Windows toolchain | todo |
| TP-CLI-02 | Empty argv does not configure CMake | ran on the authoring host |
| TP-CLI-03 | `build -h` exits 0 without a platform check | ran on the authoring host |
| TP-CLI-04 | An unknown `build` option exits non-zero | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`. The Ubuntu compile was run on the authoring host. Debian, other Linux, Alpine, and Windows compiles were not run.

## Terminologies

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

### Git Bash

**Definition:** Git Bash is an instance of command line for normal user only. It is the MSYS/MINGW POSIX shell shipped with Git for Windows. The environment’s primary detect is a `/c/` or `/c` directory (Windows `C:` as Git Bash mounts it; default drive `/c/`). Secondary signals are `MSYSTEM` matching `MINGW*`, `MSYS*`, `UCRT*`, or `CLANG*`, or `uname -s` matching `MINGW*` or `MSYS*`. WSL is excluded. On detect, admin privilege and dedicated system user privilege stay unused. Git Bash has no Termux pkg. The ship unit’s own check is the narrower pair in the Git Bash CLI coding requirement, not this directory test.

**Human daily-life explanation:** Git Bash is a Windows drawer that only opens with your keys. It looks like a Unix shell. It is not a Linux superintendent desk.

**Daily-life example:** You run git and this program as yourself. The program must not grow sudo apt or a dedicated system-user switch because you opened Git Bash.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Dispatcher map. Setup’s compile, link, and build stay on RQ-WINDOWS-GIT-BASH. |
| 2026-10-07 | Active 1.1.0 | Debian 12 and 13 setup points at RQ-DEBIAN. The script still refuses Debian. |
| 2026-10-07 | Active 1.2.0 | Specialize order. Empty argv is Type O for the CLI binary. Version prints the CLI line and the payload line. Type 0 verbs stay. Global flags point at the output requirement. The Debian branch is in the ship unit and was not compiled on Ubuntu 24.04. |
| 2026-10-07 | Active 1.3.0 | Ubuntu setup points at RQ-UBUNTU. Other Linux setup points at RQ-OTHER-LINUX. Those branches are not in the ship unit. The authoring host still exits 1 before CMake. |
| 2026-10-07 | Active 1.4.0 | The only sudo wrap is setup’s package install, owned by RQ-SHELL-SUDO-COMMAND. Git and the compile are not wrapped. The Ubuntu and other-Linux branches are in the ship unit. |
| 2026-10-07 | Active 1.5.0 | The person starts setup without sudo. A root setup stops before git and the compile. |
| 2026-10-07 | Active 1.6.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. |
| 2026-10-07 | Active 1.6.1 | The setup arrangement is named the mixed elevated sudo model. Help does not recommend a sudo prefix. |
| 2026-10-07 | Active 1.7.0 | No command splits by mode. A pipe places the CLI. A terminal opens the numbered list. `menu`, `main`, and `self-install` are named. |
| 2026-10-12 | Active 1.8.0 | Termux setup and launch point at RQ-TERMUX. The other platform routes stay. |
| 2026-10-13 | Active 1.8.1 | Termux setup and launch point at RQ-TERMUX-CLI-CODING and RQ-TERMUX-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.8.2 | Git Bash setup and launch point at RQ-WINDOWS-GIT-BASH-CLI-CODING and RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.8.3 | Alpine setup and launch point at RQ-ALPINE-CLI-CODING and RQ-ALPINE-BUILD-PAYLOAD. Alpine uses `apk` through the sudo wrap. |
| 2026-10-13 | Active 1.8.4 | Debian setup and launch point at RQ-DEBIAN-CLI-CODING and RQ-DEBIAN-BUILD-PAYLOAD. Debian uses `apt-get` through the sudo wrap. |
| 2026-10-13 | Active 1.8.5 | macOS setup and launch point at RQ-MACOS-CLI-CODING and RQ-MACOS-BUILD-PAYLOAD. macOS uses `brew` and does not call the sudo wrap. |

| 2026-10-13 | Active 1.8.6 | Fedora and Red Hat Enterprise Linux setup and launch point at RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. That family uses `dnf install -y` through the sudo wrap. |
| 2026-10-13 | Active 1.8.7 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.9.0 | `setup` is the download verb. `build` still compiles. Help lists both. `about` includes `payload_arch` and `payload_clib`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
