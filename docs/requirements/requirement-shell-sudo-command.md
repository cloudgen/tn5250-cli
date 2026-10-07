**file**: docs/requirements/requirement-shell-sudo-command.md
**ID**: RQ-SHELL-SUDO-COMMAND
**Status**: Active (Version 1.3.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file is the only owner of in-tool sudo for `tn5250-cli`. Setup may use that one wrap to install missing compiler packages. Git, make, cmake, ninja, and the compile stay with the person who started setup. Without this file, a portable sudo lesson would arrive raw and either ban the package install or scatter `sudo` through the script.

The package names stay on the Debian, Ubuntu, and other-Linux requirements. This file owns the wrap, the probe, and the studied allow table. It does not restate the CMake invocation.

### 1.1 Human-facing

**In one sentence:** `tn5250-cli setup` is the mixed elevated sudo model: one command for a normal user and for a sudo launch. Missing compiler packages are the only part that uses sudo. Git and the compile stay with the person who started it. Help does not tell that person to prefix the verb with sudo.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who runs setup. Git and the compile use this login | `tn5250-cli setup` |
| The other role | The administrator password, used only for the package install | the sudo password prompt |
| Not this file | The CMake flags, the link line, and the Windows toolchain | `docs/requirements/requirement-ubuntu.md` |

| Includes | Excludes |
|----------|----------|
| One sudo wrap, a probe that skips sudo when the tools are already present, and password sudo on a terminal | Git, cmake, make, ninja, and copying the built programs through sudo. A sudoers file written by this tool. Termux `pkg`. Git Bash package installs |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `util_sudo` and the package install |
| `tn5250-cli setup` | command | install missing packages, then build as you |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Run setup on Debian, Ubuntu, or other Linux | The same command. As yourself, a missing package asks for the administrator password. Started with sudo, the package install uses that root, then git and the compile return to you | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

1. Every in-tool `sudo` **MUST** go through one wrapping function named `util_sudo`. Domain helpers **MUST NOT** write a raw `sudo`.
2. Before that wrap runs, setup **MUST** probe without sudo. The probe asks whether the compiler, the headers, CMake, a generator, package config, terminfo, and git are already present. When the probe matches, setup **MUST NOT** call `sudo`.
3. `sudo` **MAY** run only when the probe misses. The argv **MUST** be a package-manager install of the missing packages named by the platform requirement. Git, cmake, make, ninja, and the payload copy **MUST NOT** be passed to the wrap.
4. When the process is already root (`id -u` is 0), the package command **MUST** run directly and **MUST NOT** call `sudo`. Git and the compile still **MUST NOT** run in that root process.
5. The wrap **MUST NOT** pass `sudo -n`. The studied grant for this login is not NOPASSWD for the package managers.
6. Password sudo **MUST** run only when the process measured a terminal before any function ran, that terminal can be opened, and `--json` is off. Otherwise setup **MUST** stop with a non-zero status and a message that names the missing packages and the next command. It **MUST NOT** wait for a password.
7. The password prompt **MUST** use the open terminal. Setup **MUST NOT** add a second confirmation after that password.
8. `setup` **MUST** be the mixed elevated sudo model: one verb for a normal user and for a sudo launch. Help and errors **MUST NOT** present `sudo tn5250-cli setup` as a different setup command or as the way to start setup. A sudo launch is recovered. It is not a second command. A normal user stays that user: the wrap is the only sudo, and only for missing packages. When `id -u` is 0 and `SUDO_USER` is a person other than root, setup **MUST** install any missing packages as that root process, then return to that person with `runuser` before git, cmake, and the compile. The default prefix is that person’s home plus `/.local` when `--prefix` was not passed. When `id -u` is 0 and there is no such person, setup **MUST** stop before git and the compile. A failed return **MUST NOT** continue the compile as root.
9. This tool **MUST NOT** write a sudoers fragment and **MUST NOT** write under `/etc` for this purpose.
10. Git Bash and Termux **MUST NOT** call the wrap. Termux **MUST NOT** call `pkg`. Windows package install stays on the Git Bash requirement and uses MSYS2, not this wrap.
11. A missing package manager on other Linux **MUST** stop setup. The message **MUST** name the missing tools. It **MUST NOT** invent a package name for a manager this file does not list.
12. Setup **MUST NOT** ask for the prefix, the ref, or the job count one field at a time. The sudo password is the package manager’s prompt, not a product interview.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Wrap | `util_sudo` in `src/tn5250-cli` |
| Callers | The Unix package ensure used by Debian, Ubuntu, and other Linux setup. Windows setup does not call it |
| Probe | `gcc` runs, a small C compile works or the C header is present, `cmake` runs and is at least 3.12, `pkg-config` or `pkgconf` runs, ncurses and OpenSSL headers are present, `ninja` or `make` runs, a terminfo directory is present, `git` runs |
| Already root | The package argv runs directly and does not call `sudo`. Git and the compile do not stay in that process |
| Password sudo | `sudo` with the terminal as input. No `-n`. This is the package command only, from a normal user’s setup |
| Off terminal or `--json` | Non-zero stop. The message names the packages and tells the person to open a terminal or install the packages |
| Sudo launch | `runuser` returns git and the compile to `SUDO_USER` when that name is set and is not root. There is no second setup command |
| Fragment dest | None. This CLI has no print-sudoers and installs no file under `/etc/sudoers.d` |
| Git and compile | Not passed to `util_sudo` |

**Studied allow table**

Study on the authoring host: `sudo -n -l` lists `(ALL : ALL) ALL` without NOPASSWD on that line, and lists NOPASSWD only for other products’ binaries. No `tn5250-cli` fragment is installed under `/etc/sudoers.d`. `command -v apt-get` is `/usr/bin/apt-get`. `apk`, `dnf`, `pacman`, and `zypper` are not installed on that host. Those rows use the program name `command -v` finds at runtime.

| Binary | Verb | Operand | Fragment dest | NOPASSWD? | This wrap? | Study evidence |
|--------|------|---------|---------------|-----------|------------|----------------|
| `/usr/bin/apt-get` on the authoring host. Runtime: `command -v apt-get` | `update` | none | none | no | yes | `sudo -n -l` `(ALL : ALL) ALL` is not NOPASSWD. No product fragment |
| same `apt-get` | `install` | `-y --no-install-recommends` and the missing package names | none | no | yes | same study. `DEBIAN_FRONTEND=noninteractive` is set on that argv |
| `apk` from `command -v` | `add` | `--no-cache` and the Alpine names below | none | no | yes | Binary not on the authoring host. Names from Alpine packages |
| `dnf` from `command -v` | `install` | `-y` and the Fedora names below | none | no | yes | Binary not on the authoring host. `ncurses-devel`, `pkgconf-pkg-config`, and `ninja-build` are Fedora package names |
| `pacman` from `command -v` | `-S` | `--noconfirm --needed` and the Arch names below | none | no | yes | Binary not on the authoring host. Arch package `ninja` was read from the Arch package page |
| `zypper` from `command -v` | `--non-interactive` | `install` and the openSUSE names below | none | no | yes | Binary not on the authoring host. Names are the usual openSUSE development packages and were not run here |
| other products’ binaries listed by `sudo -n -l` | their own verbs | their own operands | their own fragments | yes, on those lines only | no | This wrap does not call them |

**Package names the wrap may install, and only when the matching probe misses**

| Family | Names |
|--------|--------|
| apt-get (Debian and Ubuntu, and other Linux that has apt-get) | `gcc`, `libc6-dev`, `cmake`, `ninja-build`, `pkgconf`, `libncurses-dev`, `libssl-dev`, `ncurses-base`, `git` |
| apk | `build-base`, `cmake`, `ninja`, `pkgconf`, `ncurses-dev`, `openssl-dev`, `ncurses-terminfo-base`, `git`. `ncurses-dev` and `ncurses-terminfo-base` are Alpine ncurses subpackages. `build-base` provides the compiler and C headers |
| dnf | `gcc`, `glibc-devel`, `cmake`, `ninja-build`, `pkgconf-pkg-config`, `ncurses-devel`, `openssl-devel`, `ncurses`, `git` |
| pacman | `gcc`, `glibc`, `cmake`, `ninja`, `pkgconf`, `ncurses`, `openssl`, `git` |
| zypper | `gcc`, `glibc-devel`, `cmake`, `ninja`, `pkgconf`, `ncurses-devel`, `libopenssl-devel`, `git` |

Git clone, git fetch, cmake, make, ninja, and the copy into the prefix are not rows in this table.

### 2.2 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 9** (https://github.com/cloudgen/ciao): package install is admin privilege. Git and the compile stay with the person who started setup.
- **CIAO Principle 10 – Least privilege**: sudo runs only after the probe misses, and only for the package argv.
- **CIAO Principle 16**: a pipe or `--json` does not wait for a password.
- **CIAO Principle 2 – Intentional**: one wrap and one studied table.

## Under command line for normal user only

Git Bash, Termux, and Windows cmd have no administrator install inside this tool.

**This requirement:** on those shells the wrap stays unused. Git Bash keeps the MSYS2 toolchain on the Git Bash requirement. Termux is refused and `pkg` is not called. Debian, Ubuntu, and other Linux are not this kind of shell. They may use the wrap for missing compiler packages.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: no `sudo -n`, because the studied package path is not NOPASSWD.
- **Intentional**: one function owns every in-tool sudo.
- **Anti-fragile**: a machine that already has the compiler never asks for a password.
- **Over-protect**: git and the compile are not elevated to make the package install convenient.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Scatter a raw `sudo` outside `util_sudo`.
- Pass git, cmake, make, ninja, or the payload copy through `util_sudo`.
- Present `sudo tn5250-cli setup` as a separate setup command or as the way to start setup. The mixed elevated sudo model is the design. A sudo launch is recovered, not recommended.
- Leave git, cmake, make, ninja, or the payload copy running as root.
- Default the wrap to `sudo -n`.
- Probe with `sudo true`, `sudo ls`, or `sudo stat`.
- Skip the probe because a password prompt is available.
- Write a sudoers fragment or guess a fragment path for this product.
- Mark another product’s NOPASSWD command as an argv this wrap may run.
- Use the wrap on Git Bash or Termux.
- Treat this file as the owner of the CMake invocation or the link line.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-script-coding.md` | Writing style. Points here for the wrap (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-debian.md` | Debian package names (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu package names (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux tools and which family installs them (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-windows-git-bash.md` | Git Bash. Does not use this wrap (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-domain-tn5250.md` | Setup and host launch (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here (RQ-CLASS-SOFTWARE-DEV) |
| `src/tn5250-cli` | `util_sudo` |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-SUDO-01 | The only executed `sudo` in `src/tn5250-cli` is inside `util_sudo`, and the package ensure is the caller | ran as a source read. The only `sudo "$@"` is inside `util_sudo`. `tn5250_run_elevated` is the caller |
| TP-SUDO-02 | When the compiler packages are already present, setup does not call `sudo` | ran on the authoring host. Ubuntu 24.04 setup exited 0 and did not print `Installing missing compiler packages` |
| TP-SUDO-03 | Git, cmake, and make are not arguments of `util_sudo` | ran as a source read. The elevated argv is apt-get, apk, dnf, pacman, or zypper |
| TP-SUDO-04 | `--json` or a closed terminal does not wait for a sudo password | todo |
| TP-SUDO-05 | One setup verb: a normal user continues; a root process with no person to return to stops before git; a sudo launch returns to that person before git | ran for the normal user and for root with nobody to return to. The `runuser` return was not executed on this host |
| TP-SUDO-06 | Help for setup names one command and does not tell the person to prefix setup with sudo | source read of `tn5250_setup_help`. The three plain lines name one command, in-tool sudo for missing packages, and git and the compile staying with the user |

Proof home: `docs/reviews/test-plan.md`. The authoring host’s `sudo -n -l` was read. No package install was started while writing this file. No NOPASSWD row for apt-get was present.

## Terminologies

### Mixed elevated sudo model

**Definition:** The mixed elevated sudo model is the only setup shape this file implements. The person types `tn5250-cli setup`. sudo covers each privileged command, and in this product that command is the missing compiler package install. Git, the compile, and the user prefix stay that person. Wrapping the whole setup command in sudo is a bad design. A process that is already root returns to that person before git. That return is recovery, not a second command.

**Human daily-life explanation:** You type setup. The administrator password is used only to bring in shared compiler packages. Your git checkout and the compile stay in your name.

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

In this product the probe is “are the compiler packages already installed?” When they are, setup does not ask for the administrator password.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`tn5250-cli setup` is the operational verb that may call the wrap.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | One wrap for missing compiler packages. Git and the compile stay with the invoking person. Studied sudo on the authoring host is password sudo for `(ALL : ALL) ALL`. No product sudoers fragment. No package install was run while writing this file. |
| 2026-10-07 | Active 1.1.0 | The setup verb must be started without sudo. A root setup stops before git and the compile. There is no runuser handoff. |
| 2026-10-07 | Active 1.2.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. Help does not offer a separate sudo setup command. |
| 2026-10-07 | Active 1.3.0 | The arrangement is named the mixed elevated sudo model. Help must not recommend prefixing setup with sudo. A sudo launch stays a recovery. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
