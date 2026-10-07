**file**: docs/requirements/requirement-shell-cli-interface.md
**ID**: RQ-SHELL-CLI-INTERFACE
**Status**: Active (Version 1.6.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file names the commands of `tn5250-cli` and says which other requirement owns each command’s behavior. It is the dispatcher map. It is not the build manual.

Empty argv is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. Type 0 lifecycle verbs are owned by `docs/requirements/requirement-shell-self-management.md`. The domain catalog for `setup` and the host launch is owned by `docs/requirements/requirement-domain-tn5250.md`. Compilation, link, and build stay on `docs/requirements/requirement-windows-git-bash.md`, `docs/requirements/requirement-debian.md`, `docs/requirements/requirement-ubuntu.md`, and `docs/requirements/requirement-other-linux.md`. Output flags point at `docs/requirements/requirement-shell-output-requirements.md`. This file does not restate those bodies.

### 1.1 Human-facing

**In one sentence:** A person runs the Type 0 verbs, `tn5250-cli setup`, `tn5250-cli help`, `tn5250-cli version`, or `tn5250-cli HOST`. On Git Bash the Windows build is in the Git Bash requirement. On Debian, Ubuntu, or other Linux the Unix build is in that platform’s requirement.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person typing in the shell, with normal user privilege | `tn5250-cli help` |
| The other role | The upstream TN5250 program, after setup has built it | `tn5250-cli myibmi.example.com` |
| Not this file | Generators, libraries, and packages for each platform | `docs/requirements/requirement-windows-git-bash.md`, `docs/requirements/requirement-debian.md`, `docs/requirements/requirement-ubuntu.md`, and `docs/requirements/requirement-other-linux.md` |

| Includes | Excludes |
|----------|----------|
| The command map, empty-argv’s pointer, and the rule that setup’s flags are flags | The CMake arguments, the link line, a text-screen menu, and a field-by-field question walk |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | dispatcher |
| `tn5250-cli help` | usage text | the command list |
| `tn5250-cli setup` | build command | behavior owned by the detected platform requirement |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Ask what commands exist | Help lists the Type 0 verbs, setup, help, version, and a host launch. Setup is the command that compiles and links | `tn5250-cli help` |

## 2. Core Rules / Requirements (Mandatory)

1. The ship unit **MUST** expose one dispatcher. The first token selects the command. `app_main` **MUST** run even when the script is read on a pipe.
2. `setup`, `help`, `version`, and the host launch **MUST** also be named, with a full sample, on the platform requirement that owns that run: `docs/requirements/requirement-windows-git-bash.md` for Git Bash, `docs/requirements/requirement-debian.md` for Debian, `docs/requirements/requirement-ubuntu.md` for Ubuntu 22.04, 24.04, and 26.04, and `docs/requirements/requirement-other-linux.md` for other Linux. The Type 0 verbs **MUST** also be named on `docs/requirements/requirement-shell-self-management.md`. Empty argv **MUST** also be named on `docs/requirements/requirement-shell-cli-zero-arguments.md`. Help text in the script is not that second mention.
3. There are **no** test-purpose commands. Every command below is a command that runs the product.
4. Empty arguments (`tn5250-cli` with no token) are the Type O install-ensure of the CLI binary. That behavior is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. Empty arguments **MUST NOT** start `setup` or CMake.
5. `help`, `-h`, and `--help` as the first token **MUST** show usage and exit 0. They do not require a platform check.
6. `setup -h` and `setup --help` **MUST** show usage and exit 0 before any platform check.
7. `setup` with any other arguments **MUST** perform the build for the detected platform. Git Bash uses the Git Bash requirement. Debian 12 and Debian 13 use the Debian requirement. Ubuntu 22.04, 24.04, and 26.04 use the Ubuntu requirement. Other Linux uses the other-Linux requirement. A machine that matches none of those **MUST** stop with a non-zero status. This file **MUST NOT** define the compiler, the generator, the link libraries, or the package list.
8. Setup options are flags and environment variables. The ship unit **MUST NOT** ask for those fields one at a time on the terminal. A missing flag keeps its default. Non-interactive use **MUST NOT** wait for a prompt.
9. `version`, `--version`, and `-V` **MUST** print the CLI version from `VERSION`, then the payload line when the `REF` and `REVISION` files exist. A missing payload **MUST** warn and **MUST NOT** be a fatal error by itself. Version **MUST NOT** require a platform detect. The payload line is `tn5250 <ref> (<revision>)`.
10. A first token that is not a known flag and not a named verb **MUST** be treated as the host name and **MUST** launch the built `tn5250` program for that platform. On Git Bash that program is `tn5250.exe`. On Debian, Ubuntu, and other Linux it is the curses `tn5250`. That token is not an unknown-command error. A leading `-` or `--` that is not a known flag **MUST** fail with a non-zero status.
11. An unknown token after `setup` **MUST** fail with a non-zero status and mention `tn5250-cli setup --help`.
12. There is **no** text screen inside this installer. On Git Bash the upstream program opens its own window. On Debian, Ubuntu, and other Linux the curses program runs in the current terminal. There is no path-and-clock menu, no status line of name and version, and no bottom input box.
13. The global flags `--quiet`, `--json`, `--force`, and `--debug` exist. A leading flag is not a host name. The output contract, including JSON, is owned by `docs/requirements/requirement-shell-output-requirements.md`. This file **MUST NOT** define the JSON grammar. `tn5250-cli --quiet HOST` is global quiet, then launch. `tn5250-cli HOST --quiet` passes `--quiet` to the emulator.
14. Help **MUST** list `install`, `version-check`, `self-update`, `self-uninstall`, `about`, `help`, `version`, `setup`, and the host launch. Help **MUST** say that this installer remains `tn5250-cli`. Help **MUST NOT** list `CHECKSUM`. Help **MUST NOT** name another product’s channel.

### 2.1 Implementation Notes (this project)

| First token | Kind | Sample | Behavior owner |
|-------------|------|--------|----------------|
| (none) | runs the product | `tn5250-cli` | `docs/requirements/requirement-shell-cli-zero-arguments.md`. CLI binary only. Not `setup` |
| `install`, `version-check`, `self-update`, `self-uninstall`, `about` | runs the product | `tn5250-cli about` | `docs/requirements/requirement-shell-self-management.md` |
| `setup` | runs the product | `tn5250-cli setup` | Catalog: `docs/requirements/requirement-domain-tn5250.md`. Git Bash build: `docs/requirements/requirement-windows-git-bash.md`. Debian build: `docs/requirements/requirement-debian.md`. Ubuntu build: `docs/requirements/requirement-ubuntu.md`. Other Linux build: `docs/requirements/requirement-other-linux.md` |
| `help`, `-h`, `--help` | runs the product | `tn5250-cli help` | This file for the usage list. Each platform file names the same sample. Help does not require a platform check |
| `version`, `--version`, `-V` | runs the product | `tn5250-cli version` | This file for the CLI line. Payload line `tn5250 <ref> (<revision>)` when both files exist. A missing payload warns |
| anything else that is not a flag | runs the product | `tn5250-cli myibmi.example.com` | The platform file. Git Bash executes `tn5250.exe`. Debian, Ubuntu, and other Linux execute the curses `tn5250` |

Setup flags, all optional: `--prefix` / `TN5250_PREFIX`, `--ref` / `TN5250_REF`, `--jobs` / `TN5250_JOBS`, `--force`. Equals forms are accepted. `--quiet`, `--json`, and `--debug` are accepted after `setup`. `--msys2-root` / `TN5250_MSYS2_ROOT` is legal only for the Git Bash build. The Debian, Ubuntu, and other-Linux requirements reject it. Defaults and legal values are build law on the platform requirement.

The Debian, Ubuntu, and other-Linux branches are in the ship unit. Missing compiler packages use the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. Git and the compile stay with the person who started setup. The authoring host is Ubuntu 24.04 (noble). The last setup command on that host is recorded in `docs/requirements/requirement-ubuntu.md` §2.8. `self-uninstall` removes the CLI binary. It does not remove the payload directory.

No command is a test-purpose verb.

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): command names have one map, and the build has one owner.
- **CIAO Principle 2 – Intentional**: each token has one route.
- **CIAO Principle 16**: setup does not invent a question walk. Flags are enough.
- **CIAO Principle 21**: this file names `setup`. The platform file specifies it.

## Under command line for normal user only

The person runs these commands with normal user privilege.

**This requirement:** on Git Bash the tool does not call the sudo wrap. On Debian, Ubuntu, and other Linux the only wrap is setup’s package install, owned by `docs/requirements/requirement-shell-sudo-command.md`. The same `setup` verb is the mixed elevated sudo model for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. Git and the compile are not wrapped and do not stay root. Termux `pkg` is not called. Help and version may run in another shell and only print text. Setup and launch require Git Bash, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, or other Linux, as specified by that platform requirement. Windows cmd is not this dispatcher’s shell.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a token that is not a flag and not a named verb is a host name, and the requirement says so.
- **Intentional**: setup’s build is pointed at the requirement for the machine that was detected.
- **Anti-fragile**: empty arguments install or confirm the CLI binary, and they do not start CMake.
- **Over-protect**: this file refuses to grow a second copy of the link line.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Leave `setup`, `help`, `version`, or the host launch named only in this file.
- Paste the CMake generator, the link libraries, the package names, or the GCC fixes into this file.
- Add a text screen, a field-by-field setup interview, or a test-purpose command.
- Treat `tn5250-cli` with no arguments as help, or as `setup`.
- Drop `install`, `version-check`, `self-update`, `self-uninstall`, or `about`.
- Add sudo outside the package wrap, or pass git or the compile through sudo.
- List `CHECKSUM` in help, or point help at another product’s channel.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-windows-git-bash.md` | Git Bash detect, compilation, link, build, and the second naming of every command (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-debian.md` | Debian detect, compilation, link, build, and the second naming of every command (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu detect, compilation, link, build, and the second naming of every command (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux detect, compilation, link, build, and the second naming of every command (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-shell-output-requirements.md` | Output and JSON (RQ-SHELL-OUTPUT-REQUIREMENTS) |
| `docs/requirements/requirement-domain-tn5250.md` | Domain catalog (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-sudo-command.md` | The one sudo wrap for setup’s missing compiler packages (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual (RQ-CLASS-SOFTWARE-DEV) |
| `src/tn5250-cli` | Dispatcher |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-CLI-01 | `setup`, `help`, `version`, and host launch are named in this file and in each platform requirement | ran as a document check |
| TP-CLI-05 | On Debian 12 or 13, `setup` is routed to the Debian requirement and does not start the Windows toolchain | todo |
| TP-CLI-06 | On Ubuntu 22.04, 24.04, or 26.04, `setup` is routed to the Ubuntu requirement and does not start the Windows toolchain | ran for 24.04 noble on the authoring host. The log says `Installing tn5250 v0.18.0 for Ubuntu`. 22.04 and 26.04 were not executed |
| TP-CLI-07 | On other Linux, `setup` is routed to the other-Linux requirement and does not start the Windows toolchain | todo |
| TP-CLI-02 | Empty argv does not configure CMake | ran on the authoring host |
| TP-CLI-03 | `setup -h` exits 0 without a platform check | ran on the authoring host |
| TP-CLI-04 | An unknown `setup` option exits non-zero | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`. The Ubuntu compile was run on the authoring host. Debian, other Linux, and Windows compiles were not run.

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

**Definition:** Git Bash is an instance of command line for normal user only. It is the MSYS/MINGW POSIX shell shipped with Git for Windows. The environment’s primary detect is a `/c/` or `/c` directory (Windows `C:` as Git Bash mounts it; default drive `/c/`). Secondary signals are `MSYSTEM` matching `MINGW*`, `MSYS*`, `UCRT*`, or `CLANG*`, or `uname -s` matching `MINGW*` or `MSYS*`. WSL is excluded. On detect, admin privilege and dedicated system user privilege stay unused. Git Bash has no Termux pkg. The ship unit’s own check is the narrower pair in the Git Bash requirement, not this directory test.

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

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
