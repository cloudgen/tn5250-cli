**file**: docs/requirements/requirement-shell-self-management.md
**ID**: RQ-SHELL-SELF-MANAGEMENT
**Status**: Active (Version 1.0.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns the Type 0 lifecycle of the tn5250-cli binary: install, version-check, self-update, self-uninstall, and about. It does not build the TN5250 client.

### 1.1 Human-facing

**In one sentence:** A person can install, check, update, remove, or inspect tn5250-cli itself, without compiling the terminal client.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person managing this program | `tn5250-cli about` |
| The other role | The payload build | `tn5250-cli setup` |
| Not this file | Compilers and libraries | `docs/requirements/requirement-domain-tn5250.md` |

| Includes | Excludes |
|----------|----------|
| install, version-check, self-update, self-uninstall, about | Payload removal, CMake, and a text-screen menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `inst_*` and `app_about` |
| `tn5250-cli about` | command | diagnostics |
| `tn5250-cli self-uninstall` | command | remove the CLI binary |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Inspect the install | About reports the CLI and the payload fields | `tn5250-cli about` |

## 2. Core Rules / Requirements (Mandatory)

1. The lifecycle verbs **MUST** be `install`, `version-check`, `self-update`, `self-uninstall`, and `about`. `help` and `version` are named on the command map.
2. `install` **MUST** place the CLI binary for this privilege: root to `/usr/local/bin`, otherwise `${HOME}/.local/bin`. An existing install without `--force` **MUST** succeed without a second download.
3. `version-check` and `self-update` **MUST** use `SCRIPT_URL`. An empty `SCRIPT_URL` **MUST** fail those network steps with a non-zero status. They **MUST NOT** invent a repository.
4. `self-update` **MUST NOT** downgrade unless `--force` is set.
5. `self-uninstall` **MUST** remove the managed CLI binary only. It **MUST NOT** delete `${PREFIX}/opt/tn5250`.
6. Interactive uninstall **MUST** confirm unless `--force` is set. A pipe **MUST NOT** block on stdin.
7. `about` **MUST** report install presence, global and local versions, the user from `id -un`, the shell, TTY, and storage fields. Domain payload fields are added by the domain requirement.
8. Person-facing text **MUST** use `out_*`.

### 2.1 Implementation Notes (this product)

| Item | Value |
|------|--------|
| Handlers | `inst_perform_install`, `ver_check`, `inst_self_update`, `inst_self_uninstall`, `app_about` |
| Channel | No published URL. `SCRIPT_URL` is empty unless exported |
| Payload uninstall | Not implemented |

## Under command line for normal user only

These verbs run as this login.

**This requirement:** install, version-check, self-update, self-uninstall, and about do not install compiler packages and do not call the sudo wrap. That wrap belongs to `setup` and to `docs/requirements/requirement-shell-sudo-command.md`. Git Bash is not told to use a sudo one-liner. A global install found at uninstall time may warn that removal can need admin privilege.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: network steps do nothing useful without a channel, and they say so.
- **Intentional**: the CLI binary and the payload have different verbs.
- **Anti-fragile**: a second install is a no-op.
- **Over-protect**: self-uninstall cannot be widened into payload deletion without a new requirement.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Drop install, version-check, self-update, self-uninstall, or about.
- Make self-uninstall delete the built client.
- Advertise another product’s raw URL as this channel.
- Bypass `out_*` for these messages.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Command map (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Companion digest (RQ-SHELL-AUTOMATIC-CHECKSUM) |
| `docs/requirements/requirement-domain-tn5250.md` | Payload about fields (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-sudo-command.md` | Package install on `setup`, not on these verbs (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-SM-01 | `about` exits 0 and includes payload fields | ran on the authoring host |
| TP-SM-02 | `self-update` with an empty `SCRIPT_URL` is non-zero | todo |
| TP-SM-03 | `self-uninstall` does not remove a payload directory | todo |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Self-management

**Definition:** Self-management is the lifecycle surface a person uses on the program itself: install, version check, update, uninstall, and about. It is not the product’s domain work.

**Human daily-life explanation:** Self-management is looking after the tool in your drawer: put it away, see which copy you have, replace it, or take it out. It is not the job the tool was hired to do.

**Daily-life example:** Sharpening your own pencil is self-management. Writing the letter is the job.

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
| 2026-10-07 | Active 1.0.0 | Type 0 lifecycle inherited for tn5250-cli. No published channel. Payload uninstall is not a verb. |
| 2026-10-07 | Active 1.0.1 | These verbs do not install compiler packages. That install belongs to setup and to RQ-SHELL-SUDO-COMMAND. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
