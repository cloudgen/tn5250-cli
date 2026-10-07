**file**: docs/requirements/requirement-shell-cli-zero-arguments.md
**ID**: RQ-SHELL-CLI-ZERO-ARGUMENTS
**Status**: Active (Version 1.2.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns empty argv for tn5250-cli. No command after the program name is empty argv. A switch such as `--debug` is still no command. A pipe, `--quiet`, or `--json` places the CLI binary. A terminal opens the numbered list. Empty argv does not build the TN5250 client.

### 1.1 Human-facing

**In one sentence:** Running `tn5250-cli` with no command places this program when nobody is there to answer, and opens the numbered list when a person is at the terminal. It does not compile the terminal client.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who starts the program with no command | `tn5250-cli` |
| The other role | A pipe, explicit help, and the payload build | `sh src/tn5250-cli </dev/null` · `tn5250-cli help` · `tn5250-cli setup` |
| Not this file | The numbered list’s rows, and the compiler | `docs/requirements/requirement-shell-cli-default-interaction.md` |

| Includes | Excludes |
|----------|----------|
| A pipe, `--quiet`, or `--json` with no command places or confirms the CLI | The numbered list’s rows, payload compile, and help as the empty-argv result |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `app_main` empty-argv block |
| `tn5250-cli` | command | pipe places the CLI; a terminal opens the list |
| `tn5250-cli help` | command | usage, only when help is typed |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Start it at a terminal with no command | The numbered list opens. The CLI is not placed until you choose that row | `tn5250-cli` |
| Pipe it with no command | The CLI binary is placed or confirmed. The list does not open | `sh src/tn5250-cli </dev/null` |

## 2. Core Rules / Requirements (Mandatory)

1. Empty argv **MUST** mean no command token after global flags are parsed. `--debug`, `--quiet`, `--json`, and `--force` with no command are still empty argv. A host name is not empty argv.
2. Non-interactive empty argv **MUST** run self-install (`inst_perform_install`). Non-interactive means stdin or stdout is not a terminal, or `--quiet` is set, or `--json` is set. It **MUST NOT** print help. It **MUST NOT** open the numbered list. It **MUST NOT** call `setup`. It **MUST NOT** wait for an answer.
3. Interactive empty argv **MUST** open the numbered list. Interactive means stdin and stdout are both terminals, and neither quiet nor JSON is set. That list is owned by `docs/requirements/requirement-shell-cli-default-interaction.md`. Interactive empty argv **MUST NOT** place the CLI by itself and **MUST NOT** print help as its result.
4. Already installed under `${HOME}/.local/bin` or `/usr/local/bin`, with `--force` off, **MUST** be a success no-op on self-install. `--force` is not required for that second run.
5. Root (`id -u` 0) targets `/usr/local/bin/${APP_NAME}`. Any other login targets `${HOME}/.local/bin/${APP_NAME}`.
6. `REPO_USER` defaults to `cloudgen` and `REPO_NAME` defaults to `tn5250-cli`. An unset `SCRIPT_URL` **MUST** be `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli`. The `src/` segment is required because the ship unit is `src/tn5250-cli`. An explicit empty `SCRIPT_URL`, when the binary is not installed, **MUST** fail non-zero and **MUST NOT** call curl. It **MUST NOT** substitute another GitHub owner.
7. A failed download or checksum **MUST** be non-zero.
8. `app_main` **MUST** run even when the script is read on a pipe. A basename gate on `$0` is forbidden.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product | tn5250-cli |
| Ship unit | `src/tn5250-cli` |
| Channel | Unset `SCRIPT_URL` is `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli`. An explicit empty `SCRIPT_URL` fails before curl |
| Payload build | Not this path. `setup` is explicit |
| Interactive empty argv | Numbered list. Not this file’s rows |
| Non-interactive empty argv | `self-install`, same handler as `install` |

## Under command line for normal user only

Empty argv stays on this login.

**This requirement:** empty argv does not install compiler packages. That install belongs to `setup` and to `docs/requirements/requirement-shell-sudo-command.md`. Git Bash **MUST NOT** be shown a `sudo curl` one-liner. A Linux root login may still be shown the root one-liner on the self-install path. Empty argv does not switch to a dedicated system user.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a second run does not download again.
- **Intentional**: a pipe places the CLI. A terminal opens the list.
- **Anti-fragile**: a missing channel fails closed.
- **Over-protect**: payload setup cannot hide inside the empty path.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Return help from empty argv.
- Start `setup` from empty argv.
- Open the numbered list for a pipe, for `--quiet`, or for `--json` with no command.
- Place the CLI from an interactive empty argv before the person chooses that row.
- Point the default channel at another product.
- Require `--force` for an already-installed success.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Command map (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-self-management.md` | Install and self-install (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Numbered list for a terminal with no command (RQ-SHELL-CLI-DEFAULT-INTERACTION) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Companion digest (RQ-SHELL-AUTOMATIC-CHECKSUM) |
| `docs/requirements/requirement-shell-sudo-command.md` | Package install on `setup`, not on empty argv (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-ZERO-01 | Already installed non-interactive empty argv exits 0 and does not configure CMake | ran on the authoring host |
| TP-ZERO-02 | Not installed, explicit empty `SCRIPT_URL`, non-interactive empty argv exits non-zero and does not configure CMake | ran 2026-10-07. Exit 1. stderr: `SCRIPT_URL is empty. Refusing to download.` curl was not started |
| TP-ZERO-03 | Interactive empty argv opens the numbered list and does not place the CLI | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`.

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
| 2026-10-07 | Active 1.0.0 | Empty argv is Type O install-ensure of the CLI binary. Payload setup stays explicit. No published channel. |
| 2026-10-07 | Active 1.0.1 | Empty argv does not install compiler packages. That install belongs to setup and to RQ-SHELL-SUDO-COMMAND. |
| 2026-10-07 | Active 1.1.0 | Non-interactive empty argv is self-install. Interactive empty argv opens the numbered list. `--json` and `--quiet` with no command stay on self-install. |
| 2026-10-07 | Active 1.2.0 | Default channel is the raw URL of `src/tn5250-cli`. An explicit empty `SCRIPT_URL` still fails before curl. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
