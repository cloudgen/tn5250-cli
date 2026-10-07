**file**: docs/requirements/requirement-domain-tn5250.md
**ID**: RQ-DOMAIN-TN5250
**Status**: Active (Version 1.4.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the single domain law for tn5250-cli. It owns the TN5250 client verbs: `setup` and the host launch. It does not own Type 0 self-management, and it does not own the compiler, the link line, or the package list.

Windows compilation, link, and build stay on `docs/requirements/requirement-windows-git-bash.md`. Debian compilation, link, and build stay on `docs/requirements/requirement-debian.md`. Ubuntu compilation, link, and build stay on `docs/requirements/requirement-ubuntu.md`. Other Linux compilation, link, and build stay on `docs/requirements/requirement-other-linux.md`. The command map names every verb and points here for the domain catalog.

### 1.1 Human-facing

**In one sentence:** A person runs `tn5250-cli setup` to build the IBM i 5250 client, then `tn5250-cli HOST` to open it, while install and about stay the self-management commands.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege | `tn5250-cli setup` |
| The other role | The upstream TN5250 program after setup | `tn5250-cli myibmi.example.com` |
| Not this file | Type 0 install, and the platform compile manuals | `docs/requirements/requirement-shell-self-management.md` |

| Includes | Excludes |
|----------|----------|
| The setup verb, the host launch, domain help lines, and domain about fields | The CMake invocation, the link libraries, a text-screen menu, and CLI self-install |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `tn5250_*` functions |
| `tn5250-cli setup` | domain command | build owned by the detected platform |
| `tn5250-cli help` | usage | domain rows under the Type 0 rows |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build, then connect | Setup compiles for this machine. A later word that is not a command is the host | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialized CLI subcommands

1. Domain functions **MUST** use the `tn5250_` prefix. They **MUST NOT** be filed under `inst_`.
2. `setup` **MUST** build the upstream client for the detected platform. Git Bash follows the Git Bash requirement. Debian 12 and Debian 13 follow the Debian requirement. Ubuntu 22.04, 24.04, and 26.04 follow the Ubuntu requirement. Other Linux follows the other-Linux requirement. A machine that matches none of those **MUST** stop with a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, and other Linux. This file **MUST NOT** restate the generator, the link line, or the package list.
3. `setup -h` and `setup --help` **MUST** show setup usage and exit 0 before any platform check.
4. Setup options are `--prefix` / `TN5250_PREFIX` (default `${HOME}/.local`), `--ref` / `TN5250_REF` (default `v0.18.0`), `--jobs` / `TN5250_JOBS` (positive integer, default `nproc` or 4), and `--force`. Equals forms are accepted. `--msys2-root` / `TN5250_MSYS2_ROOT` is legal only on Git Bash. Debian, Ubuntu, and other Linux **MUST** reject it.
5. An unknown token after `setup` **MUST** fail non-zero and mention `tn5250-cli setup --help`.
6. A first token that is not a global flag and not a named verb **MUST** be the host. Git Bash **MUST** execute `tn5250.exe`. Debian, Ubuntu, and other Linux **MUST** execute the curses `tn5250`. A missing program **MUST** fail non-zero and mention `tn5250-cli setup`.
7. The installer name **MUST** stay `tn5250-cli` so it does not shadow the payload program.
8. Domain work **MUST** send person-facing text through the `out_*` family.

### 2.2 Specialized features

9. The payload is upstream `https://github.com/tn5250/tn5250.git` tag `v0.18.0`. `--ref` is a tag or branch. A raw commit SHA is outside the shallow clone this setup uses.
10. Outputs live under `${PREFIX}/opt/tn5250`. The CLI copy for the prefix lives at `${PREFIX}/bin/tn5250-cli`. Source and build caches live under `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250`.
11. Missing compiler packages **MUST** be installed only through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. The setup verb is the mixed elevated sudo model: the same command for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. When that launch is root, git and the compile return to the person who started it. A root login with no such person stops before git. Git, cmake, make, ninja, and the payload copy **MUST** stay with the person who started setup. Git Bash **MUST NOT** use that wrap. Termux `pkg` stays unused. Setup **MUST NOT** ask for prefix, ref, or jobs one field at a time.
12. There is **no** text screen inside this installer. Git Bash opens the upstream window. Debian, Ubuntu, and other Linux run the curses program in the current terminal.
13. There is **no** command that removes the payload. `self-uninstall` removes the CLI binary only, and that verb is owned by the self-management requirement.
14. On Git Bash the Windows GCC 14 patch and the UCRT64 link stay owned by the Git Bash requirement, including the recorded softer paths in that file. On Debian, Ubuntu, and other Linux those Windows steps **MUST NOT** run.

### 2.3 Specialized project help items

15. `help` **MUST** keep the Type 0 rows and add a domain section that names `setup`, `setup -h`, and host launch.
16. Domain help **MUST** say the installed program is the upstream client and that this installer remains `tn5250-cli`.
17. Domain help **MUST NOT** paste the CMake generator, the link libraries, or the package list.
18. `help` **MUST NOT** list `CHECKSUM` and **MUST NOT** show another product’s install URL as this product’s channel.

### 2.4 Specialized project about items

19. `about` **MUST** keep the Type 0 diagnostics and add payload platform, payload ref, payload revision, and payload directory.
20. JSON `about` **MUST** include `payload_platform`, `payload_ref`, and `payload_revision`.
21. `version` prints the CLI version and the payload ref line. The wording of that pair is owned by the command map. This file does not invent a second version command.

### 2.5 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Prefix | `tn5250_` |
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0` |
| Payload directory | `${PREFIX}/opt/tn5250` |
| Default prefix | `${HOME}/.local` |
| Windows owner | `docs/requirements/requirement-windows-git-bash.md` |
| Debian owner | `docs/requirements/requirement-debian.md` |
| Ubuntu owner | `docs/requirements/requirement-ubuntu.md` |
| Other Linux owner | `docs/requirements/requirement-other-linux.md` |
| Authoring host | Ubuntu 24.04. The Ubuntu branch is in the ship unit. The last setup command on that host is recorded in the Ubuntu requirement §2.8 |

## Under command line for normal user only

Setup and launch run as this login.

**This requirement:** on Git Bash the tool does not call the sudo wrap. On Debian, Ubuntu, and other Linux, missing compiler packages are installed with the wrap in `docs/requirements/requirement-shell-sudo-command.md`. The same `setup` verb is the mixed elevated sudo model for a normal user and for a sudo launch. Git and the compile stay with that person. Dedicated system user privilege stays unused. Termux `pkg` is not called. Windows cmd is not the shell that configures CMake.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: an unsupported machine does not start a compile.
- **Intentional**: one domain file, four platform owners.
- **Anti-fragile**: Type 0 install still works when the payload is absent.
- **Over-protect**: the link line is not copied into this file.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Open a second Active domain file.
- Paste a platform compile, link, or package table into this file.
- Route empty argv into `setup`.
- Add a text screen, a field-by-field setup interview, or a test-purpose verb.
- Rename the installer to `tn5250`.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Command map (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-windows-git-bash.md` | Windows compile, link, and build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-debian.md` | Debian compile, link, and build (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu compile, link, and build (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux compile, link, and build (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-shell-sudo-command.md` | The one sudo wrap for missing compiler packages (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (RQ-SHELL-SELF-MANAGEMENT) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Todo proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-DOM-01 | Help lists setup and host launch after the Type 0 rows | ran on the authoring host |
| TP-DOM-02 | `setup -h` exits 0 on a machine that is not Git Bash and not Debian 12 or 13 | ran on the authoring host |
| TP-DOM-03 | An unknown setup option exits non-zero | ran on the authoring host |
| TP-DOM-04 | A host token on an unsupported machine exits non-zero and does not configure CMake | ran on the authoring host |
| TP-DEB-05 | Debian setup does not apply the Windows GCC 14 patch | todo |
| TP-WGB-04 | Windows build is `cmake --build --parallel` | todo |

Proof home: `docs/reviews/test-plan.md`. The Ubuntu compile was run on the authoring host. Debian, other Linux, and Windows compiles were not run. TP-DOM-04 recorded the previous script.

## Terminologies

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Domain SSOT for setup and host launch. Compile, link, and build stay on the platform requirements. |
| 2026-10-07 | Active 1.1.0 | Setup and launch also follow RQ-UBUNTU and RQ-OTHER-LINUX. The generator and the link line stay on those files. The ship unit does not implement those branches yet. |
| 2026-10-07 | Active 1.2.0 | Missing compiler packages point at RQ-SHELL-SUDO-COMMAND. Git and the compile stay with the invoking person. Git Bash does not use the wrap. The Ubuntu and other-Linux branches are in the ship unit. |
| 2026-10-07 | Active 1.3.0 | The setup verb must be started without sudo. A root setup stops before git and the compile. |
| 2026-10-07 | Active 1.4.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. |
| 2026-10-07 | Active 1.4.1 | The setup arrangement is named the mixed elevated sudo model. Help does not recommend a sudo prefix. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
