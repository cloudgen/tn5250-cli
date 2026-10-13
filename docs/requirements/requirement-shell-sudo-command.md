**file**: docs/requirements/requirement-shell-sudo-command.md
**ID**: RQ-SHELL-SUDO-COMMAND
**Status**: Active (Version 1.3.8)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file is the only owner of in-tool sudo for `tn5250-cli`. Build may use that one wrap to install missing compiler packages. Git, make, cmake, ninja, and the compile stay with the person who started build. Without this file, a portable sudo lesson would arrive raw and either ban the package install or scatter `sudo` through the script.

Debian 12 and 13 apt names stay on `docs/requirements/requirement-debian-build-payload.md`. The `apt-get` call stays on `docs/requirements/requirement-debian-cli-coding.md`. Ubuntu's versioned table stays on `docs/requirements/requirement-ubuntu.md`. Other Linux that selects `apt-get` uses the Debian name table and does not become Debian. `pacman` and `zypper` names stay in this file. `dnf` names stay on `docs/requirements/requirement-fedora-redhat-build-payload.md`. Alpine `apk` names stay on `docs/requirements/requirement-alpine-build-payload.md`. Termux package names stay on `docs/requirements/requirement-termux-build-payload.md`. The Termux `pkg` call stays on `docs/requirements/requirement-termux-cli-coding.md`. macOS formula names stay on `docs/requirements/requirement-macos-build-payload.md`. The macOS `brew` call stays on `docs/requirements/requirement-macos-cli-coding.md`. macOS does not use this wrap. This file owns the wrap, the probe, and the studied allow table. It does not restate the CMake invocation.

### 1.1 Human-facing

**In one sentence:** `tn5250-cli build` is the mixed elevated sudo model: one command for a normal user and for a sudo launch. Missing compiler packages are the only part that uses sudo. Git and the compile stay with the person who started it. Help does not tell that person to prefix the verb with sudo.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who runs build. Git and the compile use this login | `tn5250-cli build` |
| The other role | The administrator password, used only for the package install | the sudo password prompt |
| Not this file | The CMake flags, the link line, and the Windows toolchain | `docs/requirements/requirement-ubuntu.md` |

| Includes | Excludes |
|----------|----------|
| One sudo wrap, a probe that skips sudo when the tools are already present, and password sudo on a terminal | Git, cmake, make, ninja, and copying the built programs through sudo. A sudoers file written by this tool. Termux `pkg`. Git Bash package installs |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `util_sudo` and the package install |
| `tn5250-cli build` | command | install missing packages, then build as you |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Run build on Debian, Ubuntu, other Linux, Alpine, Fedora, or Red Hat Enterprise Linux | The same command. As yourself, a missing package asks for the administrator password. Started with sudo, the package install uses that root, then git and the compile return to you | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. Every in-tool `sudo` **MUST** go through one wrapping function named `util_sudo`. Domain helpers **MUST NOT** write a raw `sudo`.
2. Before that wrap runs, build **MUST** probe without sudo. The probe asks whether the compiler, the headers, CMake, a generator, package config, terminfo, and git are already present. When the probe matches, build **MUST NOT** call `sudo`.
3. `sudo` **MAY** run only when the probe misses. The argv **MUST** be a package-manager install of the missing packages named by the platform requirement. Git, cmake, make, ninja, and the payload copy **MUST NOT** be passed to the wrap.
4. When the process is already root (`id -u` is 0), the package command **MUST** run directly and **MUST NOT** call `sudo`. Git and the compile still **MUST NOT** run in that root process.
5. The wrap **MUST NOT** pass `sudo -n`. The studied grant for this login is not NOPASSWD for the package managers.
6. Password sudo **MUST** run only when the process measured a terminal before any function ran, that terminal can be opened, and `--json` is off. Otherwise build **MUST** stop with a non-zero status and a message that names the missing packages and the next command. It **MUST NOT** wait for a password.
7. The password prompt **MUST** use the open terminal. Build **MUST NOT** add a second confirmation after that password.
8. `build` **MUST** be the mixed elevated sudo model: one verb for a normal user and for a sudo launch. Help and errors **MUST NOT** present `sudo tn5250-cli build` as a different build command or as the way to start build. A sudo launch is recovered. It is not a second command. A normal user stays that user: the wrap is the only sudo, and only for missing packages. When `id -u` is 0 and `SUDO_USER` is a person other than root, build **MUST** install any missing packages as that root process, then return to that person with `runuser` before git, cmake, and the compile. The default prefix is that person’s home plus `/.local` when `--prefix` was not passed. When `id -u` is 0 and there is no such person, build **MUST** stop before git and the compile. A failed return **MUST NOT** continue the compile as root.
9. This tool **MUST NOT** write a sudoers fragment and **MUST NOT** write under `/etc` for this purpose.
10. Git Bash, Termux, and macOS **MUST NOT** call the wrap. Git Bash **MUST NOT** call Termux `pkg`. On Termux, a missing compiler package is installed with `pkg` as this login. That call is owned by `docs/requirements/requirement-termux-cli-coding.md`. The package names are owned by `docs/requirements/requirement-termux-build-payload.md`. Windows package install stays on the Git Bash payload requirement and uses MSYS2, not this wrap. On Alpine, a missing compiler package **MUST** use this wrap with argv `apk add --no-cache`. That call is owned by `docs/requirements/requirement-alpine-cli-coding.md`. The package names are owned by `docs/requirements/requirement-alpine-build-payload.md`. This file **MUST NOT** keep a second copy of that table. Alpine **MUST NOT** call Termux `pkg`. On Debian, a missing compiler package **MUST** use this wrap. The argv is `apt-get update`, then `DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends` and the missing names. That call is owned by `docs/requirements/requirement-debian-cli-coding.md`. The package names are owned by `docs/requirements/requirement-debian-build-payload.md`. This file **MUST NOT** keep a second copy of that table. Ubuntu uses the same argv. Ubuntu's versioned table stays on the Ubuntu requirement. Other Linux that selects `apt-get` uses the Debian name table and does not become Debian. On Fedora and Red Hat Enterprise Linux, a missing compiler package **MUST** use this wrap with argv `dnf install -y`. That call is owned by `docs/requirements/requirement-fedora-redhat-cli-coding.md`. The package names are owned by `docs/requirements/requirement-fedora-redhat-build-payload.md`. This file **MUST NOT** keep a second copy of that table. Other Linux that selects `dnf` uses that name table and does not become that family. On macOS, a missing formula **MUST NOT** use this wrap. The call is `HOMEBREW_NO_AUTO_UPDATE=1 brew install` as this login, owned by `docs/requirements/requirement-macos-cli-coding.md`. The formula names are owned by `docs/requirements/requirement-macos-build-payload.md`. This file **MUST NOT** keep a second copy of that table. macOS **MUST NOT** call Termux `pkg`.
11. A missing package manager on other Linux **MUST** stop build. The message **MUST** name the missing tools. It **MUST NOT** invent a package name for a manager this file does not list.
12. Build **MUST NOT** ask for the prefix, the ref, or the job count one field at a time. The sudo password is the package manager’s prompt, not a product interview.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Wrap | `util_sudo` in `src/tn5250-cli` |
| Callers | The Unix package ensure used by Debian, Ubuntu, other Linux, Alpine, Fedora, and Red Hat Enterprise Linux build. Windows build does not call it. Termux build does not call it. macOS build does not call it |
| Probe | `gcc` runs, a small C compile works or the C header is present, `cmake` runs and is at least 3.12, `pkg-config` or `pkgconf` runs, ncurses and OpenSSL headers are present, `ninja` or `make` runs, a terminfo directory is present, `git` runs |
| Already root | The package argv runs directly and does not call `sudo`. Git and the compile do not stay in that process |
| Password sudo | `sudo` with the terminal as input. No `-n`. This is the package command only, from a normal user’s build |
| Off terminal or `--json` | Non-zero stop. The message names the packages and tells the person to open a terminal or install the packages |
| Sudo launch | `runuser` returns git and the compile to `SUDO_USER` when that name is set and is not root. There is no second build command |
| Fragment dest | None. This CLI has no print-sudoers and installs no file under `/etc/sudoers.d` |
| Git and compile | Not passed to `util_sudo` |

**Studied allow table**

Study on the authoring host: `sudo -n -l` lists `(ALL : ALL) ALL` without NOPASSWD on that line, and lists NOPASSWD only for other products’ binaries. No `tn5250-cli` fragment is installed under `/etc/sudoers.d`. `command -v apt-get` is `/usr/bin/apt-get`. `apk`, `dnf`, `pacman`, and `zypper` are not installed on that host. Those rows use the program name `command -v` finds at runtime.

| Binary | Verb | Operand | Fragment dest | NOPASSWD? | This wrap? | Study evidence |
|--------|------|---------|---------------|-----------|------------|----------------|
| `/usr/bin/apt-get` on the authoring host. Runtime: `command -v apt-get` | `update` | none | none | no | yes | `sudo -n -l` `(ALL : ALL) ALL` is not NOPASSWD. No product fragment |
| same `apt-get` | `install` | `-y --no-install-recommends` and the missing package names | none | no | yes | same study. `DEBIAN_FRONTEND=noninteractive` is set on that argv |
| `apk` from `command -v` | `add` | `--no-cache` and the names owned by the Alpine payload requirement | none | no | yes | Binary not on the authoring host. This file does not copy the names |
| `dnf` from `command -v` | `install` | `-y` and the names owned by the Fedora and Red Hat payload requirement | none | no | yes | Binary not on the authoring host. This file does not copy the names |
| `pacman` from `command -v` | `-S` | `--noconfirm --needed` and the Arch names below | none | no | yes | Binary not on the authoring host. Arch package `ninja` was read from the Arch package page |
| `zypper` from `command -v` | `--non-interactive` | `install` and the openSUSE names below | none | no | yes | Binary not on the authoring host. Names are the usual openSUSE development packages and were not run here |
| other products’ binaries listed by `sudo -n -l` | their own verbs | their own operands | their own fragments | yes, on those lines only | no | This wrap does not call them |

**Package names the wrap may install, and only when the matching probe misses**

| Family | Names |
|--------|--------|
| apt-get (Debian 12 and 13, Ubuntu, and other Linux that has apt-get) | Owned by `docs/requirements/requirement-debian-build-payload.md` for Debian 12 and 13 and for other Linux that selects `apt-get`. That other Linux does not become Debian. Ubuntu's versioned table stays on `docs/requirements/requirement-ubuntu.md`. The argv is `apt-get update`, then `DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends`. This file does not restate the names |
| apk | Owned by `docs/requirements/requirement-alpine-build-payload.md`. The argv is `apk add --no-cache`. This file does not restate the names |
| dnf | Owned by `docs/requirements/requirement-fedora-redhat-build-payload.md`. Fedora, Red Hat Enterprise Linux, and other Linux that selects `dnf` use that table. That other Linux does not become this family. The argv is `dnf install -y`. This file does not restate the names |
| pacman | `gcc`, `glibc`, `cmake`, `ninja`, `pkgconf`, `ncurses`, `openssl`, `git` |
| zypper | `gcc`, `glibc-devel`, `cmake`, `ninja`, `pkgconf`, `ncurses-devel`, `libopenssl-devel`, `git` |

Git clone, git fetch, cmake, make, ninja, and the copy into the prefix are not rows in this table.

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 9** (https://github.com/cloudgen/ciao): package install is admin privilege. Git and the compile stay with the person who started build.
- **CIAO Principle 10 – Least privilege**: sudo runs only after the probe misses, and only for the package argv.
- **CIAO Principle 16**: a pipe or `--json` does not wait for a password.
- **CIAO Principle 2 – Intentional**: one wrap and one studied table.

## Under command line for normal user only

Git Bash, Termux, macOS, and Windows cmd have no administrator install inside this tool.

**This requirement:** on those shells the wrap stays unused. Git Bash keeps the MSYS2 toolchain on the Git Bash payload requirement. Git Bash CLI coding stays on the Git Bash CLI coding requirement. Termux does not use this wrap. Named `pkg` install as this login is owned by `docs/requirements/requirement-termux-cli-coding.md`. The package names are owned by `docs/requirements/requirement-termux-build-payload.md`. Git Bash and Windows cmd do not call `pkg`. Debian, Ubuntu, other Linux, and Alpine are not this kind of shell. They may use the wrap for missing compiler packages. On Debian the argv is `apt-get update`, then `DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends`, and the names stay on the Debian payload requirement. Ubuntu uses that same argv and keeps its own versioned table. Other Linux that selects `apt-get` uses the Debian name table and does not become Debian. On Alpine the argv is `apk add --no-cache` and the names stay on the Alpine payload requirement. On Fedora and Red Hat Enterprise Linux the argv is `dnf install -y` and the names stay on the Fedora and Red Hat payload requirement. Other Linux that selects `dnf` uses that name table and does not become that family. On macOS the wrap stays unused. A missing formula is `brew install` as this login. The formula names stay on the macOS payload requirement.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: no `sudo -n`, because the studied package path is not NOPASSWD.
- **Intentional**: one function owns every in-tool sudo.
- **Anti-fragile**: a machine that already has the compiler never asks for a password.
- **Over-protect**: git and the compile are not elevated to make the package install convenient.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Scatter a raw `sudo` outside `util_sudo`.
- Pass git, cmake, make, ninja, or the payload copy through `util_sudo`.
- Present `sudo tn5250-cli build` as a separate build command or as the way to start build. The mixed elevated sudo model is the design. A sudo launch is recovered, not recommended.
- Leave git, cmake, make, ninja, or the payload copy running as root.
- Default the wrap to `sudo -n`.
- Probe with `sudo true`, `sudo ls`, or `sudo stat`.
- Skip the probe because a password prompt is available.
- Write a sudoers fragment or guess a fragment path for this product.
- Mark another product’s NOPASSWD command as an argv this wrap may run.
- Use the wrap on Git Bash or Termux.
- Keep a second copy of the Alpine `apk` package table in this file.
- Keep a second copy of the Debian apt package table in this file.
- Keep a second copy of the `dnf` package table in this file.
- Treat this file as the owner of the CMake invocation or the link line.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-script-coding.md` | Writing style. Points here for the wrap (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-debian-cli-coding.md` | Debian `apt-get` call through this wrap (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | Debian 12 and 13 package names (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu package names (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux tools and which family installs them (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-alpine-cli-coding.md` | Alpine `apk add --no-cache` through this wrap (RQ-ALPINE-CLI-CODING) |
| `docs/requirements/requirement-alpine-build-payload.md` | Alpine `apk` package names (RQ-ALPINE-BUILD-PAYLOAD) |
| `docs/requirements/requirement-termux-cli-coding.md` | Termux `pkg` call. Does not use this wrap (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-termux-build-payload.md` | Termux package names (RQ-TERMUX-BUILD-PAYLOAD) |
| `docs/requirements/requirement-macos-cli-coding.md` | macOS `brew` call. Does not use this wrap (RQ-MACOS-CLI-CODING) |
| `docs/requirements/requirement-macos-build-payload.md` | macOS Homebrew formula names. This file does not copy that table (RQ-MACOS-BUILD-PAYLOAD) |
| `docs/requirements/requirement-fedora-redhat-cli-coding.md` | Fedora and Red Hat `dnf install -y` through this wrap (RQ-FEDORA-REDHAT-CLI-CODING) |
| `docs/requirements/requirement-fedora-redhat-build-payload.md` | Fedora and Red Hat `dnf` package names (RQ-FEDORA-REDHAT-BUILD-PAYLOAD) |
| `docs/requirements/requirement-windows-git-bash-cli-coding.md` | Git Bash. Does not use this wrap (RQ-WINDOWS-GIT-BASH-CLI-CODING) |
| `docs/requirements/requirement-windows-git-bash-build-payload.md` | Windows package names. MSYS2, not this wrap (RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD) |
| `docs/requirements/requirement-domain-tn5250.md` | Build and host launch (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here (RQ-CLASS-SOFTWARE-DEV) |
| `src/tn5250-cli` | `util_sudo` |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-SUDO-01 | The only executed `sudo` in `src/tn5250-cli` is inside `util_sudo`, and the package ensure is the caller | ran as a source read. The only `sudo "$@"` is inside `util_sudo`. `tn5250_run_elevated` is the caller |
| TP-SUDO-02 | When the compiler packages are already present, build does not call `sudo` | ran on the authoring host. Ubuntu 24.04 build exited 0 and did not print `Installing missing compiler packages` |
| TP-SUDO-03 | Git, cmake, and make are not arguments of `util_sudo` | ran as a source read. The elevated argv is apt-get, apk, dnf, pacman, or zypper |
| TP-SUDO-04 | `--json` or a closed terminal does not wait for a sudo password | todo |
| TP-SUDO-05 | One build verb: a normal user continues; a root process with no person to return to stops before git; a sudo launch returns to that person before git | ran for the normal user and for root with nobody to return to. The `runuser` return was not executed on this host |
| TP-SUDO-06 | Help for build names one command and does not tell the person to prefix build with sudo | source read of `tn5250_setup_help`. The three plain lines name one command, in-tool sudo for missing packages, and git and the compile staying with the user |

Proof home: `docs/reviews/test-plan.md`. The authoring host’s `sudo -n -l` was read. No package install was started while writing this file. No NOPASSWD row for apt-get was present.

## Terminologies

### Mixed elevated sudo model

**Definition:** The mixed elevated sudo model is the only build shape this file implements. The person types `tn5250-cli build`. sudo covers each privileged command, and in this product that command is the missing compiler package install. Git, the compile, and the user prefix stay that person. Wrapping the whole build command in sudo is a bad design. A process that is already root returns to that person before git. That return is recovery, not a second command.

**Human daily-life explanation:** You type build. The administrator password is used only to bring in shared compiler packages. Your git checkout and the compile stay in your name.

**Daily-life example:** You ask for the workshop to be set up. The super unlocks the supply cage. You still sign the drawings and run the tools.

### Sudo-wrapping function

**Definition:** A sudo-wrapping function is a prefixed shell helper that is the only place the ship unit invokes in-tool sudo. It must run check before sudo first. If the probe matches (this login already can), it runs the tool without sudo. Worked example: chmod. The wrapping function (or a chmod helper that calls it) probes whether this login owns the path and must not sudo chmod when this login owns the path.

**Human daily-life explanation:** A sudo-wrapping function is the one hallway where the tool may ask for the site key. First it checks whether your own keys already open that door. If you already own the drawer, it must not bother the site key.

**Daily-life example:** Before calling the superintendent to relabel a box, the helper looks: “Is this already my box?” If yes, it just writes the new label itself.

In this product the hallway is `util_sudo`. The door it may open is the package install. Git and the compile stay with your own keys.

### Check before sudo

**Definition:** Check before sudo is the portable shell coding rule that before writing sudo and a command, the script must run a non-sudo probe that asks whether this login can already do the job. If the probe matches (this login already can), the script must not sudo. There is no further elevated step. Worked example: sudo chmod. The probe is whether this login owns the path. If this login owns the path, do not sudo chmod.

**Human daily-life explanation:** Check before sudo means: try your own key first. If this login can already do the job, do not ask for the master key. Example: if you already own the file, do not sudo chmod.

**Daily-life example:** Before asking the building super to unlock a closet, you try your own key. If it opens, you do not bother the super. That is check before sudo.

In this product the probe is “are the compiler packages already installed?” When they are, build does not ask for the administrator password.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`tn5250-cli build` is the operational verb that may call the wrap.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | One wrap for missing compiler packages. Git and the compile stay with the invoking person. Studied sudo on the authoring host is password sudo for `(ALL : ALL) ALL`. No product sudoers fragment. No package install was run while writing this file. |
| 2026-10-07 | Active 1.1.0 | The setup verb must be started without sudo. A root setup stops before git and the compile. There is no runuser handoff. |
| 2026-10-07 | Active 1.2.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. Help does not offer a separate sudo setup command. |
| 2026-10-07 | Active 1.3.0 | The arrangement is named the mixed elevated sudo model. Help must not recommend prefixing setup with sudo. A sudo launch stays a recovery. |
| 2026-10-12 | Active 1.3.1 | Termux still does not call this wrap. Named `pkg` install points at RQ-TERMUX. |
| 2026-10-13 | Active 1.3.2 | Termux still does not call this wrap. The `pkg` call points at RQ-TERMUX-CLI-CODING. Package names point at RQ-TERMUX-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.3.3 | Git Bash still does not call this wrap. CLI coding points at RQ-WINDOWS-GIT-BASH-CLI-CODING. The MSYS2 package names point at RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD. |
| 2026-10-13 | Active 1.3.4 | Alpine uses this wrap for `apk add --no-cache`. The `apk` names point at RQ-ALPINE-BUILD-PAYLOAD. The call points at RQ-ALPINE-CLI-CODING. This file no longer lists those names. |
| 2026-10-13 | Active 1.3.5 | Debian uses this wrap for `apt-get update` and `apt-get install -y --no-install-recommends`. The call points at RQ-DEBIAN-CLI-CODING. The Debian 12 and 13 names point at RQ-DEBIAN-BUILD-PAYLOAD. Ubuntu keeps its versioned table. Other Linux that selects `apt-get` uses the Debian name table and does not become Debian. This file no longer lists those apt names. |
| 2026-10-13 | Active 1.3.6 | macOS does not call this wrap. The `brew` call points at RQ-MACOS-CLI-CODING. The formula names point at RQ-MACOS-BUILD-PAYLOAD. This file does not list those names. |

| 2026-10-13 | Active 1.3.7 | Fedora and Red Hat Enterprise Linux use this wrap for `dnf install -y`. The call points at RQ-FEDORA-REDHAT-CLI-CODING. The `dnf` names point at RQ-FEDORA-REDHAT-BUILD-PAYLOAD. This file no longer lists those names. Other Linux that selects `dnf` uses that table and does not become that family. |
| 2026-10-13 | Active 1.3.8 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
