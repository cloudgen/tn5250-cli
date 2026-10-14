**file**: docs/requirements/requirement-domain-tn5250.md
**ID**: RQ-DOMAIN-TN5250
**Status**: Active (Version 1.7.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the single domain law for tn5250-cli. tn5250 is the upstream 5250 telnet client for IBM i, the system that was called AS/400. This file owns how the installer builds that client, how `setup` is catalogued beside `build`, and how a host is opened. It does not define the 5250 data stream. It does not own Type 0 self-management, and it does not own the compiler, the link line, or the package list.

Windows Git Bash CLI coding stays on `docs/requirements/requirement-windows-git-bash-cli-coding.md`. Windows compilation, link, build, and the UCRT64 package list stay on `docs/requirements/requirement-windows-git-bash-build-payload.md`. Debian CLI coding stays on `docs/requirements/requirement-debian-cli-coding.md`. Debian compilation, link, build, and the `apt` package list stay on `docs/requirements/requirement-debian-build-payload.md`. Ubuntu compilation, link, and build stay on `docs/requirements/requirement-ubuntu.md`. Other Linux compilation, link, and build stay on `docs/requirements/requirement-other-linux.md`. Alpine CLI coding stays on `docs/requirements/requirement-alpine-cli-coding.md`. Alpine compilation, link, build, and the `apk` package list stay on `docs/requirements/requirement-alpine-build-payload.md`. Termux CLI coding stays on `docs/requirements/requirement-termux-cli-coding.md`. Termux compilation, link, build, and the named package list stay on `docs/requirements/requirement-termux-build-payload.md`. macOS CLI coding stays on `docs/requirements/requirement-macos-cli-coding.md`. macOS compilation, link, build, and the Homebrew formula table stay on `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux CLI coding stays on `docs/requirements/requirement-fedora-redhat-cli-coding.md`. That compilation, link, build, and the `dnf` package list stay on `docs/requirements/requirement-fedora-redhat-build-payload.md`. Published payload filenames in `download/` stay on `docs/requirements/requirement-payload-filename.md`. This file does not restate that grammar. The command map names every verb and points here for the domain catalog.

### 1.1 Human-facing

**In one sentence:** A person runs `tn5250-cli setup` to download a published client, or `tn5250-cli build local` or `tn5250-cli build global` to compile one and copy it into `download/`, then `tn5250-cli HOST` to open it. On Termux and on Windows, `build global` is not available.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege | `tn5250-cli build` |
| The other role | The upstream TN5250 program after build | `tn5250-cli myibmi.example.com` |
| Not this file | Type 0 install, and the platform compile manuals | `docs/requirements/requirement-shell-self-management.md` |

| Includes | Excludes |
|----------|----------|
| The build verb, the setup verb's place in the catalog, the host launch, domain help lines, and domain about fields | The CMake invocation, the link libraries, the filename grammar, the numbered CLI list, and CLI self-install |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `tn5250_*` functions |
| `tn5250-cli build` | domain command | build owned by the detected platform |
| `tn5250-cli help` | usage | domain rows under the Type 0 rows |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Download or build, then connect | Setup downloads a published client. Build compiles one. A later word that is not a command is the host | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialized CLI subcommands

1. Domain functions **MUST** use the `tn5250_` prefix. They **MUST NOT** be filed under `inst_`.
2. `build` **MUST** build the upstream client for the detected platform. Git Bash follows the Git Bash CLI coding requirement and the Git Bash payload requirement. Debian 12 and Debian 13 follow the Debian CLI coding requirement and the Debian payload requirement. Ubuntu 22.04, 24.04, and 26.04 follow the Ubuntu requirement. Other Linux follows the other-Linux requirement. Alpine follows the Alpine CLI coding requirement and the Alpine payload requirement. Termux follows the Termux CLI coding requirement and the Termux payload requirement. macOS follows the macOS CLI coding requirement and the macOS payload requirement. Fedora and Red Hat Enterprise Linux follow RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. A machine that matches none of those **MUST** stop with a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS. This file **MUST NOT** restate the generator, the link line, or the package list.
3. `build -h` and `build --help` **MUST** show build usage and exit 0 before any platform check.
4. Build options are `--prefix` / `TN5250_PREFIX`, `--ref` / `TN5250_REF` (default `v0.18.0`), `--jobs` / `TN5250_JOBS` (positive integer, default `nproc` or 4), and `--force`. Equals forms are accepted. `--msys2-root` / `TN5250_MSYS2_ROOT` is legal only on Git Bash. Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS **MUST** reject it. Scope tokens are `local`, `global`, `clean`, and `install` followed by `local` or `global`. `local` with no `--prefix` uses `${HOME}/.local`. `global` with no `--prefix` uses `/usr/local`, except on Termux and on Windows. On those two, scope `global` **MUST** stop with a non-zero status before a prefix is chosen, before clean, and before compile. The message **MUST** be `Global is not available on Termux. Next: tn5250-cli build local` or `Global is not available on Windows. Next: tn5250-cli build local`. `build global`, `build install global`, and `build clean global` are that stop, including when `--prefix` is set. `clean` with no scope uses local. On a terminal, `build` with no scope and no flag **MUST** open the build board owned by `docs/requirements/requirement-shell-cli-default-interaction.md`. Off a terminal, or when a flag is present and no scope token was given, the scope **MUST** be local.
5. An unknown token after `build` **MUST** fail non-zero and mention `tn5250-cli build --help`. `clean`, `local`, `global`, and `install` followed by `local` or `global` are known tokens. They **MUST NOT** be treated as unknown.
6. A first token that is not a global flag and not a named verb **MUST** be the host. Git Bash **MUST** execute `tn5250.exe`. Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS **MUST** execute the curses `tn5250`. A missing program **MUST** fail non-zero and name `tn5250-cli setup` or `tn5250-cli build`. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists, or `tn5250.exe` on Git Bash. Otherwise it **MUST** execute the program `build` copied under the payload directory. A host name that does not resolve **MUST NOT** end as a segmentation fault. The client prints its session error. The connect fix that makes that true is owned by the platform requirements. `menu` and `main` are named verbs. They are not host names. `setup` is a named verb. It downloads a published client. The filename, the choice, and the save path are owned by `docs/requirements/requirement-payload-filename.md`. `setup` **MUST NOT** compile and **MUST NOT** be passed to the client as a host name. `build` still compiles.
7. The installer name **MUST** stay `tn5250-cli` so it does not shadow the payload program.
8. Domain work **MUST** send person-facing text through the `out_*` family.

### 2.2 Specialized features

9. The payload is upstream `https://github.com/tn5250/tn5250.git` tag `v0.18.0`. `--ref` is a tag or branch. A raw commit SHA is outside the shallow clone this build uses.
10. Outputs live under `${PREFIX}/opt/tn5250`. The CLI copy for the prefix lives at `${PREFIX}/bin/tn5250-cli`. Source and build caches live under `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250`. Published names in `download/` are owned by `docs/requirements/requirement-payload-filename.md`. `build` still copies into `${PREFIX}/opt/tn5250`. After a successful local or global install, including when the client is already installed, `build` **MUST** copy that client into `download/` as that file requires.
11. On Debian, Ubuntu, other Linux, Alpine, Fedora, and Red Hat Enterprise Linux, missing compiler packages **MUST** be installed only through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. On Debian that install is `apt-get` through the wrap. The call is owned by `docs/requirements/requirement-debian-cli-coding.md`. The package names are owned by `docs/requirements/requirement-debian-build-payload.md`. On Alpine that install is `apk add --no-cache`. The call is owned by `docs/requirements/requirement-alpine-cli-coding.md`. The package names are owned by `docs/requirements/requirement-alpine-build-payload.md`. On Fedora and Red Hat Enterprise Linux that install is `dnf install -y`. The call is owned by `docs/requirements/requirement-fedora-redhat-cli-coding.md`. The package names are owned by `docs/requirements/requirement-fedora-redhat-build-payload.md`. The build verb is the mixed elevated sudo model: the same command for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. When that launch is root, git and the compile return to the person who started it. A root login with no such person stops before git. Git, cmake, make, and ninja **MUST** stay with the person who started build. A global place of the finished tree into a prefix this login cannot write **MAY** use the sudo wrap for `mkdir`, `cp`, `chmod`, and `rm`, as `docs/requirements/requirement-shell-sudo-command.md` requires. A local place **MUST NOT** use that wrap. The copy into `download/` **MUST NOT** use that wrap. A recovered sudo launch **MUST** keep the scope token when it returns to that person. Git Bash **MUST NOT** use that wrap. On Termux, missing compiler packages **MUST** be installed with `pkg` as this login. The call is owned by `docs/requirements/requirement-termux-cli-coding.md`. The package names are owned by `docs/requirements/requirement-termux-build-payload.md`. Termux **MUST NOT** use the sudo wrap and **MUST NOT** use Linux `apt` or Alpine `apk`. On macOS, missing formulae **MUST** be installed with `HOMEBREW_NO_AUTO_UPDATE=1 brew install` as this login. The call is owned by `docs/requirements/requirement-macos-cli-coding.md`. The formula names are owned by `docs/requirements/requirement-macos-build-payload.md`. macOS **MUST NOT** use the sudo wrap, Termux `pkg`, or Alpine `apk`. Build **MUST NOT** ask for prefix, ref, or jobs one field at a time.
12. There is **no** path-and-clock screen inside this installer. The numbered list is owned by `docs/requirements/requirement-shell-cli-default-interaction.md`. Git Bash opens the upstream window. Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS run the curses program in the current terminal.
13. `build clean` **MUST** remove `${PREFIX}/opt/tn5250` and the cmake cache `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build`. It **MUST NOT** remove `download/`, the CLI binary, or the git source cache. The default clean scope is local. `build clean global` with no `--prefix` cleans `/usr/local`, except on Termux and on Windows, where rule 4 stops it and it **MUST NOT** remove `/usr/local`. On Termux the removes use `docs/requirements/requirement-termux-cli-coding.md`. An Android toybox remove or a `safe-rm` remove **MUST NOT** print an error and **MUST NOT** stop the command. A warning is acceptable. `self-uninstall` removes the CLI binary only, and that verb is owned by the self-management requirement.
14. On Git Bash the Windows GCC 14 patch and the UCRT64 link stay owned by the Git Bash payload requirement, including the recorded softer paths in that file. On Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS those Windows steps **MUST NOT** run.

### 2.3 Specialized project help items

15. `help` **MUST** keep the Type 0 rows and add a domain section that names `setup`, `setup -h`, `build`, `build local`, `build global`, `build clean`, `build install local`, `build install global`, `build -h`, and host launch. That section **MUST** say that setup downloads a published client, that local and global compile one, and that those two copy the named client into `download/`. It **MUST** say that on Termux and on Windows, `build global` is not available.
16. Domain help **MUST** say the installed program is the upstream client and that this installer remains `tn5250-cli`.
17. Domain help **MUST NOT** paste the CMake generator, the link libraries, or the package list.
18. `help` **MUST NOT** list `CHECKSUM` and **MUST NOT** show another product’s install URL as this product’s channel.

### 2.4 Specialized project about items

19. `about` **MUST** keep the Type 0 diagnostics and add payload platform, payload arch, payload C library, payload ref, payload revision, and payload directory. Arch and `<clib>-<clib-version>` are collected by `docs/requirements/requirement-payload-filename.md`. `about` **MUST NOT** exit when this host has no payload name.
20. JSON `about` **MUST** include `payload_platform`, `payload_arch`, `payload_clib`, `termux_version`, `payload_ref`, and `payload_revision`. `termux_version` is the environment variable `TERMUX_VERSION` or an empty string. It is not calculated and it is not part of the payload filename.
21. `version` prints the CLI version and the payload ref line. The wording of that pair is owned by the command map. This file does not invent a second version command.

### 2.5 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Prefix | `tn5250_` |
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0` |
| Payload directory | `${PREFIX}/opt/tn5250` |
| Default prefix | `${HOME}/.local` for local. `/usr/local` for global when `--prefix` is absent. On Termux and Windows, global does not run |
| Windows CLI coding | `docs/requirements/requirement-windows-git-bash-cli-coding.md` |
| Windows payload | `docs/requirements/requirement-windows-git-bash-build-payload.md` |
| Debian CLI coding | `docs/requirements/requirement-debian-cli-coding.md` |
| Debian payload | `docs/requirements/requirement-debian-build-payload.md` |
| Ubuntu owner | `docs/requirements/requirement-ubuntu.md` |
| Other Linux owner | `docs/requirements/requirement-other-linux.md` |
| Alpine CLI coding | `docs/requirements/requirement-alpine-cli-coding.md` |
| Alpine payload | `docs/requirements/requirement-alpine-build-payload.md` |
| Termux CLI coding | `docs/requirements/requirement-termux-cli-coding.md` |
| Termux payload | `docs/requirements/requirement-termux-build-payload.md` |
| macOS CLI coding | `docs/requirements/requirement-macos-cli-coding.md` |
| macOS payload | `docs/requirements/requirement-macos-build-payload.md` |
| Fedora and Red Hat CLI coding | `docs/requirements/requirement-fedora-redhat-cli-coding.md` |
| Fedora and Red Hat payload | `docs/requirements/requirement-fedora-redhat-build-payload.md` |
| Authoring host | Ubuntu 24.04. The Ubuntu branch is in the ship unit. The last build command on that host is recorded in the Ubuntu requirement §2.8 |

### 2.6 Example (scope tokens)

```sh
# Known words before flags. Anything else is an unknown option.
case "$1" in
    clean) _clean=1 ;;
    local) _scope=local ;;
    global) _scope=global ;;
    install)
        shift
        case "${1-}" in
            local) _scope=local ;;
            global) _scope=global ;;
            *) out_die "build install needs local or global. Next: ${APP_NAME} build --help" ;;
        esac
        ;;
esac

# After the scope is known, and before a prefix is chosen.
if [ "${_scope}" = "global" ]; then
    tn5250_refuse_global
fi
```

## Under command line for normal user only

Build and launch run as this login.

**This requirement:** on Git Bash the tool does not call the sudo wrap. On Debian, Ubuntu, other Linux, Alpine, Fedora, and Red Hat Enterprise Linux, missing compiler packages are installed with the wrap in `docs/requirements/requirement-shell-sudo-command.md`. On Alpine that install is `apk add --no-cache`. On Fedora and Red Hat Enterprise Linux that install is `dnf install -y`. The same `build` verb is the mixed elevated sudo model for a normal user and for a sudo launch. Git and the compile stay with that person. Dedicated system user privilege stays unused. On Termux, missing compiler packages are installed with `pkg` as this login. Termux does not call the sudo wrap and does not call `apk`. On macOS, missing formulae are installed with `brew` as this login. macOS does not call the sudo wrap and does not call `pkg`. Windows cmd is not the shell that configures CMake. Git Bash and Windows cmd do not call Termux `pkg`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: an unsupported machine does not start a compile.
- **Intentional**: one domain file, six platform owners.
- **Anti-fragile**: Type 0 install still works when the payload is absent.
- **Over-protect**: the link line is not copied into this file.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Open a second Active domain file.
- Paste a platform compile, link, or package table into this file.
- Route empty argv into `build`.
- Add a path-and-clock screen, a field-by-field build interview, or a test-purpose verb.
- Rename the installer to `tn5250`.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Command map (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-windows-git-bash-cli-coding.md` | Git Bash CLI coding (RQ-WINDOWS-GIT-BASH-CLI-CODING) |
| `docs/requirements/requirement-windows-git-bash-build-payload.md` | Windows compile, link, and build (RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD) |
| `docs/requirements/requirement-debian-cli-coding.md` | Debian CLI coding (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | Debian compile, link, build, and the apt package table (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu compile, link, and build (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux compile, link, and build (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-alpine-cli-coding.md` | Alpine CLI coding (RQ-ALPINE-CLI-CODING) |
| `docs/requirements/requirement-alpine-build-payload.md` | Alpine compile, link, build, and the apk package table (RQ-ALPINE-BUILD-PAYLOAD) |
| `docs/requirements/requirement-termux-cli-coding.md` | Termux CLI coding (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-termux-build-payload.md` | Termux compile, link, build, and the pkg package table (RQ-TERMUX-BUILD-PAYLOAD) |
| `docs/requirements/requirement-macos-cli-coding.md` | macOS CLI coding (RQ-MACOS-CLI-CODING) |
| `docs/requirements/requirement-macos-build-payload.md` | macOS compile, link, build, and the Homebrew formula table (RQ-MACOS-BUILD-PAYLOAD) |
| `docs/requirements/requirement-fedora-redhat-cli-coding.md` | Fedora and Red Hat CLI coding (RQ-FEDORA-REDHAT-CLI-CODING) |
| `docs/requirements/requirement-fedora-redhat-build-payload.md` | Fedora and Red Hat compile, link, build, and the `dnf` table (RQ-FEDORA-REDHAT-BUILD-PAYLOAD) |
| `docs/requirements/requirement-payload-filename.md` | Published payload filename in `download/` (RQ-PAYLOAD-FILENAME) |
| `docs/requirements/requirement-shell-sudo-command.md` | The one sudo wrap for missing compiler packages (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (RQ-SHELL-SELF-MANAGEMENT) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Todo proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-DOM-01 | Help lists build and host launch after the Type 0 rows | ran on the authoring host |
| TP-DOM-02 | `build -h` exits 0 on a machine that is not Git Bash and not Debian 12 or 13 | ran on the authoring host |
| TP-DOM-03 | An unknown build option exits non-zero | ran on the authoring host |
| TP-DOM-04 | A host token on an unsupported machine exits non-zero and does not configure CMake | ran on the authoring host |
| TP-DEB-05 | Debian build does not apply the Windows GCC 14 patch. The connect fix is applied | todo |
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
| 2026-10-07 | Active 1.4.2 | The numbered list is not this file. This file still forbids a path-and-clock screen and a setup question walk. |
| 2026-10-07 | Active 1.4.3 | A host name that does not resolve must not be a segmentation fault. `menu` and `main` stay named verbs. |
| 2026-10-08 | Active 1.4.4 | This file names tn5250 as the upstream 5250 telnet client for IBM i. The data stream stays out of this file. |
| 2026-10-12 | Active 1.5.0 | Termux setup and launch point at RQ-TERMUX. Termux `pkg` is that file’s install. The sudo wrap stays off Termux. |
| 2026-10-13 | Active 1.5.1 | Termux setup points at RQ-TERMUX-CLI-CODING for the `pkg` call and RQ-TERMUX-BUILD-PAYLOAD for the package names and the compile. |
| 2026-10-13 | Active 1.5.2 | Git Bash setup points at RQ-WINDOWS-GIT-BASH-CLI-CODING for detection and launch, and at RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD for the compile and the package names. |
| 2026-10-13 | Active 1.5.3 | Alpine setup points at RQ-ALPINE-CLI-CODING for detection and the `apk` call, and at RQ-ALPINE-BUILD-PAYLOAD for the compile and the package names. Alpine uses the sudo wrap. |
| 2026-10-13 | Active 1.5.4 | Debian setup points at RQ-DEBIAN-CLI-CODING for detection and the `apt-get` call, and at RQ-DEBIAN-BUILD-PAYLOAD for the compile and the package names. Debian 12 and 13 behavior is unchanged. |
| 2026-10-13 | Active 1.5.5 | macOS setup points at RQ-MACOS-CLI-CODING for detection and the `brew` call, and at RQ-MACOS-BUILD-PAYLOAD for the compile and the formula names. macOS does not use the sudo wrap. |

| 2026-10-13 | Active 1.5.6 | Fedora and Red Hat Enterprise Linux setup points at RQ-FEDORA-REDHAT-CLI-CODING for detection and the `dnf` call, and at RQ-FEDORA-REDHAT-BUILD-PAYLOAD for the compile and the package names. That family uses the sudo wrap. |
| 2026-10-13 | Active 1.5.7 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.5.8 | Published payload filenames point at RQ-PAYLOAD-FILENAME. This file does not restate the grammar. `build` still copies into `opt/tn5250`. |
| 2026-10-13 | Active 1.6.0 | `setup` downloads a published client. `build` still compiles. Launch prefers the setup save, then the build copy. `about` adds arch and the C library. |
| 2026-10-14 | Active 1.7.0 | `build local`, `build global`, and `build clean` are named. Local and global copy the installed client into `download/`. Clean removes the payload directory and the compile tree. |
| 2026-10-14 | Active 1.7.1 | On Termux and Windows, `build global`, `build install global`, and `build clean global` stop before a prefix, clean, or compile. The message names `build local`. |
| 2026-10-14 | Active 1.7.2 | On Termux, `build clean` removes through RQ-TERMUX-CLI-CODING. Android toybox and `safe-rm` must not print an error. A warning is acceptable. The command continues. |

**Last Updated**: 2026-10-14
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
