**file**: docs/requirements/requirement-fedora-redhat-cli-coding.md
**ID**: RQ-FEDORA-REDHAT-CLI-CODING
**Status**: Active (Version 1.0.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Fedora and Red Hat Enterprise Linux CLI coding requirement. It owns how the ship unit is written when the host is that family: detection, the `dnf` install through the sudo wrap, where the installer is copied, and the launch of the curses client.

It does not own the C compile, the link line, the package names, or the payload directory layout. Those belong to `docs/requirements/requirement-fedora-redhat-build-payload.md`. The sudo wrap itself belongs to `docs/requirements/requirement-shell-sudo-command.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`.

### 1.1 Human-facing

**In one sentence:** On Fedora or Red Hat Enterprise Linux the installer detects `ID=fedora` or `ID=rhel`, installs a missing compiler package with `dnf install -y` through the sudo wrap, copies itself to `~/.local/bin`, and launches the curses client from the payload directory.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person on Fedora or Red Hat Enterprise Linux, with normal user privilege | `tn5250-cli build` |
| The other role | The curses client, owned by the payload requirement | `tn5250 HOST` |
| Not this file | CMake, the `dnf` package table, and the link line | `docs/requirements/requirement-fedora-redhat-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Detection of `ID=fedora` and `ID=rhel`, `dnf install -y` through the sudo wrap, the copy of `tn5250-cli` into `~/.local/bin`, and the launch of the curses `tn5250` | The package names, the C compile, copying `tn5250` into `~/.local/bin`, Termux `pkg`, and `brew` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the Fedora and Red Hat arms |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `tn5250 HOST` | the built program | a 5250 session after build |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build on Fedora or Red Hat Enterprise Linux | The payload requirement says what the compile must produce. This file says how the script recognizes this family and how it asks `dnf` for a missing package | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of Fedora and Red Hat Enterprise Linux CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-fedora-redhat-build-payload.md`. Debian stays on `docs/requirements/requirement-debian-cli-coding.md` and `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Alpine, Termux, macOS, and Git Bash stay on their own requirements.
2. `build` (except `build -h` and `build --help`) and launch **MUST** accept the host when `/etc/os-release` `ID` is `fedora` or `rhel`. `ID=fedora` selects the detect string `fedora`. `ID=rhel` selects the detect string `rhel`. That check **MUST** run after the Git Bash pair, the Darwin check, the Termux check, the Debian check, the Ubuntu check, and the Alpine check, and before other Linux. `VERSION_ID` is not a detect key. There is no codename pair and no mismatch arm. `ID_LIKE` containing `fedora` or `rhel` does **NOT** select this family. `uname -s` reporting `Linux` does not by itself select it. `TERMUX_VERSION` does **NOT** select it. `uname -s` reporting `Darwin` does **NOT** select it.
3. Those two identities are this family. CentOS (`ID=centos`), Rocky Linux (`ID=rocky`), AlmaLinux (`ID=almalinux`), Amazon Linux (`ID=amzn`), and Oracle Linux (`ID=ol`) are not this family. They stay other Linux. Ubuntu is not this family.
4. A missing package named by the payload requirement **MUST** be installed with `dnf install -y` through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. The build arm **MUST** force family `dnf`, so `apt-get` or `apk` earlier on `PATH` does not win. When every check already passes, build **MUST NOT** call `dnf` and **MUST NOT** call sudo. This situation **MUST NOT** call Termux `pkg`, `brew`, `apk`, `apt-get`, `pacman`, or `zypper`. There is no `dnf update` and no `dnf5`-only flag.
5. When `dnf` is missing, or the install exits non-zero, build **MUST** stop before git and the compile. The message **MUST** name the missing packages. Git and the compile stay with the person who started build. Help **MUST NOT** tell that person to prefix `build` with sudo.
6. `--msys2-root` **MUST** be rejected on Fedora and on Red Hat Enterprise Linux.
7. `help` **MUST** print without this family's check. It **MUST** name Fedora and Red Hat Enterprise Linux and **MUST NOT** say the program refuses them. `build -h` and `build --help` **MUST** print without that check. That text **MUST** name Fedora, Red Hat Enterprise Linux, and `dnf`, and **MUST** say a missing compiler package on this family is installed with `dnf` through the sudo wrap.
8. The Debian, Ubuntu, other-Linux, Alpine, Termux, macOS, and Git Bash arms **MUST** remain. Termux **MUST NOT** call this `dnf` list. The macOS arm **MUST NOT** call this `dnf` list. This situation **MUST NOT** call Termux `pkg` or `brew`.
9. Build **MUST** copy the installer to `${TN5250_PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow the curses program. The default prefix is `${HOME}/.local`. Build **MUST NOT** copy the curses `tn5250`, or the other payload programs, into `${TN5250_PREFIX}/bin`. The verb `setup` may save a published client at `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save.
10. When `${TN5250_PREFIX}/bin` and the payload directory are not already both on `PATH`, build uses the same `~/.bashrc` marker as `docs/requirements/requirement-termux-cli-coding.md`. This file **MUST NOT** invent a second export line.
11. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists. That file is the `setup` save. Otherwise launch **MUST** execute the payload `tn5250` named by the build-payload requirement. It **MUST NOT** append `.exe` and **MUST NOT** set `MSYS_NO_PATHCONV`. A missing program **MUST** name `tn5250-cli setup` or `tn5250-cli build`.
12. `about --json` **MUST** report `payload_platform` `fedora` when `ID` is `fedora`, and `rhel` when `ID` is `rhel`. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `/etc/os-release` `ID` `fedora` or `rhel`, after Alpine, before other Linux |
| Build arms | `tn5250_setup_unix "Fedora" "dnf" 1` and `tn5250_setup_unix "Red Hat Enterprise Linux" "dnf" 1` |
| Install line | `dnf install -y` through `tn5250_run_elevated` |
| Installer copy | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250-cli` |
| Payload directory | owned by `docs/requirements/requirement-fedora-redhat-build-payload.md`. Not `~/.local/bin` |
| Shell start file | `${HOME}/.bashrc`, same marker as RQ-TERMUX-CLI-CODING |
| Refused | Termux `pkg`, `brew`, a direct `dnf` when the checks already pass, copying `tn5250` into `~/.local/bin`, a second `PATH` policy |

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

On 2026-10-13 this host was Termux, not Fedora and not Red Hat Enterprise Linux. No Fedora compile was run. No Red Hat Enterprise Linux compile was run. The ship unit routes `ID=fedora` to `tn5250_setup_unix "Fedora" "dnf" 1` and `ID=rhel` to `tn5250_setup_unix "Red Hat Enterprise Linux" "dnf" 1`. Both arms call the sudo wrap. They do not call Termux `pkg` and they do not call `brew`.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): this family's script coding has this file. The C build has the payload file.
- **CIAO Principle 9**: `dnf` may use the sudo wrap. Git and the compile stay with the person who started build.
- **CIAO Principle 2 – Intentional**: Fedora and Red Hat Enterprise Linux are not the other-Linux catch-all. `ID_LIKE=fedora` does not become this family.

## Under command line for normal user only

Fedora and Red Hat Enterprise Linux can have an administrator. Build borrows that role only for a missing compiler package, through the sudo wrap. The person still runs git and the compile.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: `ID_LIKE=fedora` or `ID_LIKE=rhel` does not become this family.
- **Intentional**: the installer lands in `~/.local/bin`. The client does not.
- **Anti-fragile**: a present toolchain does not call `dnf`.
- **Over-protect**: the payload compile is not restated here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this CLI coding back into one file with the payload build, or back into the other-Linux requirement.
- Treat CentOS, Rocky Linux, AlmaLinux, Amazon Linux, or Oracle Linux as this family.
- Copy the curses `tn5250` into `~/.local/bin` to satisfy this file.
- Call Termux `pkg` or `brew` from these arms, or call this `dnf` list from the Termux or macOS arm.
- Call `dnf` or sudo when the payload requirement's checks already pass.
- Pass git, cmake, make, or the payload copy through the sudo wrap.
- Invent a second `PATH` export. The marker text stays on the Termux CLI coding requirement.
- Delete the other platform arms while editing these branches.
- Claim a Fedora or Red Hat Enterprise Linux compile that was not run.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-fedora-redhat-build-payload.md` | The C client build and the `dnf` names (RQ-FEDORA-REDHAT-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. This family uses it for `dnf` only (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-termux-cli-coding.md` | The shared bashrc marker text (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-other-linux.md` | Other Linux. Does not own `ID=fedora` or `ID=rhel` (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | Detect and the `dnf` arms |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

This host is not Fedora and not Red Hat Enterprise Linux. These rows are not a compile on either member.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-FRH-01 | `ID=fedora` is `fedora` and `ID=rhel` is `rhel`, not other Linux. `ID_LIKE` does not select this family. `about --json` reports that detect string | todo. Not executed on Fedora or Red Hat Enterprise Linux |
| TP-FRH-02 | `tn5250-cli help` exits 0 and names Fedora and Red Hat Enterprise Linux. `tn5250-cli build -h` exits 0 and names Fedora, Red Hat Enterprise Linux, and `dnf`. Neither says the program refuses them. Neither compiles | ran on this Termux host as a help-text check. `tests/termux-platform.sh`. Not a Fedora or Red Hat Enterprise Linux compile |
| TP-FRH-07 | A missing package is `dnf install -y` through the sudo wrap. A present toolchain does not call `dnf` | the argv is in the ship unit. Not executed on Fedora or Red Hat Enterprise Linux |
| TP-FRH-09 | The installer is copied to `~/.local/bin`. The curses client is not. The bashrc marker is the Termux marker | the copy function is shared. Not executed on Fedora or Red Hat Enterprise Linux |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Fedora and Red Hat Enterprise Linux leave the other-Linux catch-all. This file owns detection of `ID=fedora` and `ID=rhel`, the `dnf install -y` call through the sudo wrap, the installer copy, and launch. The C build and the package names are RQ-FEDORA-REDHAT-BUILD-PAYLOAD. No compile was run on either member. |

| 2026-10-13 | Active 1.0.1 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.2 | Build still does not copy the client into `~/.local/bin`. `setup` may. Launch prefers that save, then the build copy. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
