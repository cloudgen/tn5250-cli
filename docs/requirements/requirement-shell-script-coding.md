**file**: docs/requirements/requirement-shell-script-coding.md
**ID**: RQ-SHELL-SCRIPT-CODING
**Status**: Active (Version 1.4.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the writing-style home for the ship unit. Without this requirement, portable learned lessons arrive raw and get treated as this product’s law.

The ship unit is a POSIX `/bin/sh` program. That runtime was inherited when this product was specialized. Compilation of the Windows client, the library link, and the CMake build are not writing style. They are owned by `docs/requirements/requirement-windows-git-bash.md`. The Debian compile, link, and build are owned by `docs/requirements/requirement-debian.md`. The Ubuntu compile, link, and build are owned by `docs/requirements/requirement-ubuntu.md`. The other-Linux compile, link, and build are owned by `docs/requirements/requirement-other-linux.md`. This file points at those requirements.

### 1.1 Human-facing

**In one sentence:** A maintainer keeps `src/tn5250-cli` as a `/bin/sh` script with `set -u`, and leaves each platform’s compile, link, and build on that platform’s requirement.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person editing the installer script | Change the script only in the way this file allows |
| The other role | The person who runs setup, on Git Bash or on Linux | They meet the build rules, not this style sheet |
| Not this file | CMake generators, link libraries, and package lists for each platform | `docs/requirements/requirement-windows-git-bash.md`, `docs/requirements/requirement-debian.md`, `docs/requirements/requirement-ubuntu.md`, and `docs/requirements/requirement-other-linux.md` |

| Includes | Excludes |
|----------|----------|
| The `/bin/sh` shebang, `set -u`, the `out_*` messages, the function prefixes, and the rule that executed sudo is only `util_sudo` | The Windows UCRT64 build and the Linux ncurses builds |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | the script as it is written |
| `docs/requirements/requirement-windows-git-bash.md` | Windows build law | Windows compilation, link, and build |
| `docs/requirements/requirement-debian.md` | Debian build law | Debian compilation, link, and build |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu build law | Ubuntu compilation, link, and build |
| `docs/requirements/requirement-other-linux.md` | Other Linux build law | Other Linux compilation, link, and build |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Read the style home before editing the script | Adopt the rules below. Follow the pointer for anything that compiles C | `tn5250-cli help` |

## 2. Core Rules / Requirements (Mandatory)

1. The ship unit **MUST** be a `/bin/sh` script. The shebang **MUST** be `#!/bin/sh`. The script **MUST** set `-u`. It **MUST NOT** set `-e` for the whole file. Failures use explicit checks and the output helpers.
2. A missing command, a failed check, or a refused environment **MUST** be reported through `out_error` or `out_die` and **MUST** end with a non-zero status.
3. A tool lookup **MUST** use `command -v` (or a direct executable test). It **MUST NOT** depend on `which`.
4. In-tool `sudo` **MUST** go through `util_sudo` only, and only to install missing compiler packages. That arrangement is the mixed elevated sudo model. That wrap, the probe, and the allow table are owned by `docs/requirements/requirement-shell-sudo-command.md`. Help **MUST NOT** tell the person to prefix `setup` with sudo. Git, cmake, make, ninja, and the payload copy **MUST NOT** go through the wrap. The ship unit **MUST NOT** create a dedicated system user or invoke Termux `pkg`. A recommendation string may mention sudo only for a Linux root login. Git Bash **MUST NOT** be shown that one-liner and **MUST NOT** call the wrap.
5. Compilation, link, and build of the Windows client **MUST** stay on the Git Bash requirement. Compilation, link, and build of the Debian client **MUST** stay on the Debian requirement. Compilation, link, and build of the Ubuntu client **MUST** stay on the Ubuntu requirement. Compilation, link, and build of the other-Linux client **MUST** stay on the other-Linux requirement. This file **MUST NOT** restate a generator, a link line, or a package list.
6. Editors **MUST NOT** rewrite the ship unit into Python to match a portable lesson. Editors **MUST NOT** put back a Bash-only shebang or a global `set -euo pipefail` as a style cleanup. The specialize order replaced that older rule.
7. Function prefixes **MUST** stay `out_`, `inst_`, `app_`, `util_`, `ver_`, `prompt_`, and `tn5250_`. The payload work **MUST** use `tn5250_`. It **MUST NOT** be renamed onto `inst_`.
8. A portable lesson about Termux packages or a Unix autotools build **MUST** be refused here. The sudo wrap is adopted by pointing at `docs/requirements/requirement-shell-sudo-command.md`. The Linux CMake builds are law on the Debian, Ubuntu, and other-Linux requirements, not an autotools lesson in this file.
9. The user bashrc marker that setup may append is current behavior of `tn5250_install_cli`. A dedicated rc requirement is not opened. This file **MUST NOT** grow a second PATH policy.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Shebang | `#!/bin/sh` |
| Strict mode | `set -u`. No global `set -e` |
| Error helper | `out_error` and `out_die` |
| Info helper | `out_info` and the rest of the `out_*` family |
| Tool lookup | `command -v` |
| In-tool sudo | `docs/requirements/requirement-shell-sudo-command.md`. One wrap, package install only |
| Windows C compile, link, and build | `docs/requirements/requirement-windows-git-bash.md` |
| Debian C compile, link, and build | `docs/requirements/requirement-debian.md` |
| Ubuntu C compile, link, and build | `docs/requirements/requirement-ubuntu.md` |
| Other Linux C compile, link, and build | `docs/requirements/requirement-other-linux.md` |
| Command names | `docs/requirements/requirement-shell-cli-interface.md` |
| Prefixes | `out_` `inst_` `app_` `util_` `ver_` `prompt_` `tn5250_` |
| Adopted | `/bin/sh`, `set -u`, `out_*`, `command -v`, the prefixes above. Sudo only through `util_sudo` for missing compiler packages |
| Pointed | Windows: CMake, UCRT64 GCC, link libraries, runtime DLLs, MSYS2 isolation. Debian, Ubuntu, and other Linux: CMake, system GCC, ncurses, OpenSSL. The sudo wrap: `docs/requirements/requirement-shell-sudo-command.md` |
| Refused | A return to `#!/usr/bin/env bash` with global `set -euo pipefail`, a Python rewrite, sudo outside `util_sudo`, sudo of git or the compile, Termux `pkg`, Unix autotools as either platform’s build |
| Syntax check | `sh -n` and `dash -n` exit 0 on the authoring host. That is not a dash runtime run, and it is not a payload compile |

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 21 – Dual policies** (https://github.com/cloudgen/ciao): portable lessons are adopted, pointed, or refused here, in product language.
- **CIAO Principle 5 – SSOT**: writing style has one home. Each platform build has another.
- **CIAO Principle 9**: package install may use admin privilege through the sudo-command requirement. Git and the compile stay with the person who started setup.
- **CIAO Principle 2 – Intentional**: `/bin/sh` is required because the specialize order inherited that runtime.

## Under command line for normal user only

Git Bash, Debian, Ubuntu, and other Linux are places a person runs setup, version, and launch. On Git Bash, admin privilege and dedicated system user privilege stay unused.

**This requirement:** on Git Bash the writing style must not add an executed `sudo`, an apt wrap, a dedicated system user, or Termux `pkg`. On Debian, Ubuntu, and other Linux the only executed sudo is `util_sudo`, and only for missing compiler packages, as specified by `docs/requirements/requirement-shell-sudo-command.md`. Debian package names live on the Debian requirement. Ubuntu package names live on the Ubuntu requirement. Other Linux names the package family. Windows cmd is a peer environment and is not the language of this script. The Windows compile, link, and build are specified by `docs/requirements/requirement-windows-git-bash.md`. The Debian compile, link, and build are specified by `docs/requirements/requirement-debian.md`. The Ubuntu compile, link, and build are specified by `docs/requirements/requirement-ubuntu.md`. The other-Linux compile, link, and build are specified by `docs/requirements/requirement-other-linux.md`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a portable shell lesson is not product law until this file adopts it.
- **Intentional**: `/bin/sh` is named, and the C build is pointed elsewhere.
- **Anti-fragile**: the inherited prefixes stay.
- **Over-protect**: sudo outside the package wrap, and a Python rewrite, stay refused.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Delete this file and leave writing style only on the class residual.
- Move the CMake generator, the link libraries, or the UCRT64 package list into this file.
- Rewrite `src/tn5250-cli` into Python, or put back a Bash-only shebang, as a style cleanup.
- Add an executed `sudo` outside `util_sudo`, pass git or the compile through that wrap, or invoke Termux `pkg`.
- Treat this file as the owner of `tn5250-cli setup`’s compile, link, and build on Windows or on Linux.
- Move payload work onto the `inst_` prefix.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-class-software-dev.md` | Class residual points here (RQ-CLASS-SOFTWARE-DEV) |
| `docs/requirements/requirement-windows-git-bash.md` | Windows compilation, link, and build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-debian.md` | Debian compilation, link, and build (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu compilation, link, and build (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux compilation, link, and build (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-shell-sudo-command.md` | The one sudo wrap (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` contract (RQ-SHELL-OUTPUT-REQUIREMENTS) |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix ownership (RQ-SHELL-MODULAR-FUNCTION-DESIGN) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-SH-01 | `src/tn5250-cli` starts with `#!/bin/sh`, sets `-u`, and does not set `-e` globally | ran. `sh -n` and `dash -n` exit 0 |
| TP-SH-02 | Executed sudo is only `util_sudo`, and only for the package install | superseded by TP-SUDO-01. The earlier source read found no executed sudo |
| TP-SH-03 | This file does not restate the CMake generator or the link libraries | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Coding-style requirement

**Definition:** A coding-style requirement is the software-development specialize-in home for portable learned lessons about how the ship unit is written. Every software-development project must have an Active language-matched coding-style requirement. Without that file, agents bring portable learned lessons raw and treat them as this product’s law. The coding-style requirement is where those lessons are adopted, pointed at a peer, or refused.

**Human daily-life explanation:** A coding-style requirement is this product’s adopted writing-style home. Every software-development project must have one. Without it, helpers would treat portable lessons as this product’s law raw.

**Daily-life example:** A newsroom keeps one style sheet (“we write dates this way”). That adopted sheet is the coding-style requirement. The industry handbook on the shelf is not house law until the sheet says so.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Bash style home. Compile, link, and build point at RQ-WINDOWS-GIT-BASH. POSIX sh rewrite and sudo lessons refused. |
| 2026-10-07 | Active 1.1.0 | Debian compile, link, and build point at RQ-DEBIAN. |
| 2026-10-07 | Active 1.2.0 | Specialize order. The ship unit is `/bin/sh` with `set -u` and the inherited prefixes. The older Bash-only rule is replaced. Platform builds still point at their owners. |
| 2026-10-07 | Active 1.3.0 | Ubuntu and other Linux compile, link, and build point at RQ-UBUNTU and RQ-OTHER-LINUX. This file still does not restate the generator. |
| 2026-10-07 | Active 1.4.0 | In-tool sudo points at RQ-SHELL-SUDO-COMMAND. The wrap installs missing compiler packages. Git and the compile stay with the invoking person. |
| 2026-10-07 | Active 1.4.1 | The package wrap is named the mixed elevated sudo model. Help does not recommend a sudo prefix on setup. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
