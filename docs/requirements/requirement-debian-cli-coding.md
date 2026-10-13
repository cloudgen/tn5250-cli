**file**: docs/requirements/requirement-debian-cli-coding.md
**ID**: RQ-DEBIAN-CLI-CODING
**Status**: Active (Version 1.0.4)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Debian CLI coding requirement. It owns how the ship unit is written when the host is Debian 12 or Debian 13: detection, the `apt-get` install through the sudo wrap, where the installer is copied, and the launch of the curses client.

Those two releases are the Debian family in this product. Ubuntu is not this family.

It does not own the C compile, the link line, the package names, or the payload directory layout. Those belong to `docs/requirements/requirement-debian-build-payload.md`. The sudo wrap itself belongs to `docs/requirements/requirement-shell-sudo-command.md`. POSIX `/bin/sh` style belongs to `docs/requirements/requirement-shell-script-coding.md`.

### 1.1 Human-facing

**In one sentence:** On Debian 12 or 13 the installer detects the release pair, installs a missing compiler package with `apt-get` through the sudo wrap, copies itself to `~/.local/bin`, and launches the curses client from the payload directory.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person on Debian 12 or 13, with normal user privilege | `tn5250-cli build` |
| The other role | The curses client, owned by the payload requirement | `tn5250 HOST` |
| Not this file | CMake, the Debian package table, and the link line | `docs/requirements/requirement-debian-build-payload.md` |

| Includes | Excludes |
|----------|----------|
| Debian 12 and 13 detection, `apt-get` through the sudo wrap, the copy of `tn5250-cli` into `~/.local/bin`, and the launch of the curses `tn5250` | The package names, the C compile, copying `tn5250` into `~/.local/bin`, Ubuntu, and Termux `pkg` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the ship unit | the Debian branch |
| `~/.local/bin/tn5250-cli` | the installed installer | the command on `PATH` |
| `tn5250 HOST` | the built program | a 5250 session after build |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build on Debian | The payload requirement says what the compile must produce. This file says how the script recognizes Debian 12 or 13 and how it asks `apt-get` for a missing package | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of Debian CLI coding. The payload build **MUST** stay on `docs/requirements/requirement-debian-build-payload.md`. Ubuntu, other Linux, Alpine, Termux, macOS, and Git Bash stay on their own requirements. macOS stays on `docs/requirements/requirement-macos-cli-coding.md` and `docs/requirements/requirement-macos-build-payload.md`. Fedora and Red Hat Enterprise Linux stay on `docs/requirements/requirement-fedora-redhat-cli-coding.md` and `docs/requirements/requirement-fedora-redhat-build-payload.md`.
2. `build` (except `build -h` and `build --help`) and launch **MUST** accept the host only for these pairs from `/etc/os-release`: `ID=debian` with `VERSION_ID=12` and `VERSION_CODENAME=bookworm`, or `ID=debian` with `VERSION_ID=13` and `VERSION_CODENAME=trixie`. That check **MUST** run after the macOS check and the Termux check, and before the Ubuntu check. `uname -s` reporting `Linux` does not by itself select this situation. `version` is not this detect. Its CLI line is owned by `docs/requirements/requirement-shell-cli-interface.md`.
3. A mismatch **MUST** stop build and launch and **MUST NOT** fall through to other Linux. A mismatch is `ID=debian` together with `VERSION_ID` `12` or `13` whose `VERSION_CODENAME` is not the pair in rule 2, or `VERSION_CODENAME` `bookworm` or `trixie` whose `VERSION_ID` is not the pair in rule 2. The message **MUST** say this Debian release mixes version 12 or 13 with the wrong codename, **MUST** say it will not be treated as another Linux, and **MUST** name Debian 12 bookworm or Debian 13 trixie as the next step.
4. `ID_LIKE` containing `debian` does **NOT** select this situation. Ubuntu 22.04, 24.04, and 26.04 stay on `docs/requirements/requirement-ubuntu.md`. An `ID=debian` release that is neither a rule 2 pair nor a rule 3 mismatch is not this situation. Debian 11 is that case. It is not a mismatch stop.
5. A missing package named by the payload requirement **MUST** be installed through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. The argv **MUST** be `apt-get update`, then `DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends` and the missing names. When every check already passes, build **MUST NOT** call `apt-get` and **MUST NOT** call sudo. This situation **MUST NOT** call Termux `pkg`, `apk`, `brew`, `dnf`, `pacman`, or `zypper`. Ubuntu uses this same `apt-get` argv and remains the Ubuntu requirement.
6. When `apt-get` is missing, or the install exits non-zero, build **MUST** stop before git and the compile. The message **MUST** name the missing packages. Git and the compile stay with the person who started build. Help **MUST NOT** tell that person to prefix `build` with sudo.
7. `--msys2-root` **MUST** be rejected on Debian. The prefix **MUST NOT** be empty.
8. `help` **MUST** print without the Debian check. It **MUST** name Debian and **MUST NOT** say the program refuses Debian. `build -h` and `build --help` **MUST** print without that check. That text **MUST** name Debian 12 and 13 and **MUST** say missing compiler packages are installed with sudo from inside build.
9. The Ubuntu, other-Linux, Alpine, Termux, macOS, and Git Bash arms **MUST** remain. Termux **MUST NOT** call this `apt-get` list. The macOS arm **MUST NOT** call this `apt-get` list. The Fedora and Red Hat arms **MUST** remain and **MUST** keep `dnf install -y` through the sudo wrap. This situation **MUST NOT** call Termux `pkg` or `brew`.
10. Build **MUST** copy the installer to `${TN5250_PREFIX}/bin/tn5250-cli`, mark it executable, and keep the name `tn5250-cli` so it does not shadow the curses program. The default prefix is `${HOME}/.local`. Build **MUST NOT** copy the curses `tn5250`, or the other payload programs, into `${TN5250_PREFIX}/bin`. Build **MUST NOT** install into `/usr` or `/etc`. The verb `setup` may save a published client at `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250`. That save is owned by `docs/requirements/requirement-payload-filename.md`. Build **MUST NOT** perform that save.
11. When `${TN5250_PREFIX}/bin` and the payload directory are not already both on `PATH`, build uses the same `~/.bashrc` marker as `docs/requirements/requirement-termux-cli-coding.md`. This file **MUST NOT** invent a second export line.
12. Launch **MUST** prefer `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` when that file exists. That file is the `setup` save. Otherwise launch **MUST** execute the payload `tn5250` named by the build-payload requirement. It **MUST NOT** append `.exe` and **MUST NOT** set `MSYS_NO_PATHCONV`. A missing program **MUST** name `tn5250-cli setup` or `tn5250-cli build`.
13. `about --json` **MUST** report `payload_platform` `debian` when rule 2 matches. The `version` CLI line stays on `docs/requirements/requirement-shell-cli-interface.md`.
14. A host that matches no platform requirement **MUST** get a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, Termux, and macOS.

### 2.1 Implementation Notes (this project)

| Item | This product |
|------|----------------|
| Ship unit | `src/tn5250-cli` |
| Detect | `/etc/os-release` pairs in rule 2, after Termux, before Ubuntu |
| Mismatch | `debian-mismatch`. Does not fall through to other Linux |
| Install line | `apt-get update`, then `apt-get install -y --no-install-recommends`, through `tn5250_run_elevated` |
| Installer copy | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250-cli` |
| Payload directory | owned by `docs/requirements/requirement-debian-build-payload.md`. Not `~/.local/bin` |
| Shell start file | `${HOME}/.bashrc`, same marker as RQ-TERMUX-CLI-CODING |
| Refused | Termux `pkg`, `apt install tn5250`, copying `tn5250` into `~/.local/bin`, a second `PATH` policy |

**Commands**

```bash
tn5250-cli build
tn5250-cli build --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli build --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. It does not compile. `tn5250-cli build --help` shows help and does not compile.

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not Debian. No Debian compile was run. The ship unit routes a rule 2 pair to `tn5250_setup_unix "Debian" "apt"`. That arm calls the sudo wrap. It does not call Termux `pkg`. The authoring host recorded for the earlier combined Debian file was Ubuntu 24.04, which is not this situation.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): Debian script coding has this file. The C build has the payload file.
- **CIAO Principle 9**: `apt-get` may use the sudo wrap. Git and the compile stay with the person who started build.
- **CIAO Principle 1 – Caution**: only the two release pairs are Debian. A mismatched pair does not become other Linux.

## Under command line for normal user only

Debian can have an administrator. Build borrows that role only for a missing compiler package, through the sudo wrap. The person still runs git and the compile. Termux `pkg` is not called. This shell is not Git Bash and not Windows cmd.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: `ID_LIKE=debian` does not become this situation.
- **Intentional**: the installer lands in `~/.local/bin`. The client does not.
- **Anti-fragile**: a present toolchain does not call `apt-get`.
- **Over-protect**: the payload compile is not restated here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold Debian CLI coding back into one file with the payload build.
- Treat Ubuntu as Debian because `ID_LIKE` contains `debian`.
- Let a rule 3 mismatch fall through to other Linux.
- Copy the curses `tn5250` into `~/.local/bin` to satisfy this file.
- Call Termux `pkg` from the Debian arm, or call `apt-get` from the Termux arm.
- Call `brew` from the Debian arm, or call `apt-get` from the macOS arm.
- Call `apt-get` or sudo when the payload requirement's checks already pass.
- Pass git, cmake, make, or the payload copy through the sudo wrap.
- Invent a second `PATH` export. The marker text stays on the Termux CLI coding requirement.
- Claim `apt install tn5250` as the supported install.
- Delete the other platform arms while editing the Debian branch.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-debian-build-payload.md` | The C client build and the Debian package names (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. Debian uses it for `apt-get` only (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu. Same `apt-get` argv. Not these two release pairs (RQ-UBUNTU) |
| `docs/requirements/requirement-termux-cli-coding.md` | The shared bashrc marker text (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-other-linux.md` | Other Linux. Does not own Debian 12 or 13 (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | Debian detect and the `apt` arm |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

This host is not Debian. These rows are not a Debian compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-DEB-01 | The rule 2 pairs are Debian. A rule 3 mismatch stops and does not fall through. `ID_LIKE` does not select Debian. `about --json` reports `payload_platform` `debian` on a pair | todo |
| TP-DEB-06 | A missing package is `apt-get update` and `apt-get install -y --no-install-recommends` through the sudo wrap. A present toolchain does not call sudo | the argv is in the ship unit. Not executed on Debian. The present-toolchain observation was the Ubuntu run |
| TP-DEB-09 | The installer is copied to `~/.local/bin`. The curses client is not. The bashrc marker is the Termux marker | the copy function is shared. Not executed on Debian |
| TP-CLI-01 | `build`, `help`, `version`, and host launch are named here and in the command map | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from RQ-DEBIAN 1.5.6. This file owns detection of Debian 12 and 13, the `apt-get` call through the sudo wrap, the installer copy, and launch. The C build and the package names are RQ-DEBIAN-BUILD-PAYLOAD. Debian build behavior is unchanged. No Debian compile was run. |
| 2026-10-13 | Active 1.0.1 | macOS stays on RQ-MACOS-CLI-CODING and RQ-MACOS-BUILD-PAYLOAD. This Debian arm does not call `brew`. The macOS arm stays in the ship unit. |

| 2026-10-13 | Active 1.0.2 | Fedora and Red Hat Enterprise Linux stay on RQ-FEDORA-REDHAT-CLI-CODING and RQ-FEDORA-REDHAT-BUILD-PAYLOAD. This Debian arm does not call `dnf`. The Fedora and Red Hat arms stay in the ship unit. |
| 2026-10-13 | Active 1.0.3 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.0.4 | Build still does not copy the client into `~/.local/bin`. `setup` may. Launch prefers that save, then the build copy. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
