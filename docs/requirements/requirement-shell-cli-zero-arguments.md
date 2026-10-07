**file**: docs/requirements/requirement-shell-cli-zero-arguments.md
**ID**: RQ-SHELL-CLI-ZERO-ARGUMENTS
**Status**: Active (Version 1.0.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns empty argv for tn5250-cli. Empty argv installs or confirms the CLI binary. It does not build the TN5250 client.

### 1.1 Human-facing

**In one sentence:** Running `tn5250-cli` with no words places this program for the current login, or says it is already installed, and does not compile the terminal client.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who starts the program with no extra words | `tn5250-cli` |
| The other role | Explicit help, and the payload build | `tn5250-cli help` · `tn5250-cli setup` |
| Not this file | The compiler and the link line | `docs/requirements/requirement-domain-tn5250.md` |

| Includes | Excludes |
|----------|----------|
| Not installed, already installed locally, and already installed globally | Payload compile, a text-screen menu, and help as the empty-argv result |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `app_main` empty-argv block |
| `tn5250-cli` | command | install-ensure |
| `tn5250-cli help` | command | usage, only when help is typed |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Start it with no words | The CLI binary is ensured. The TN5250 sources are not fetched | `tn5250-cli` |

## 2. Core Rules / Requirements (Mandatory)

1. Empty argv **MUST** mean install-ensure of `${APP_NAME}`. It **MUST NOT** print help as its success path. It **MUST NOT** call `setup`.
2. Not installed, a terminal on stdin and stdout, and neither quiet nor JSON: the program may ask once, then install or skip. A pipe, quiet, or JSON **MUST NOT** wait for an answer.
3. Already installed under `${HOME}/.local/bin` or `/usr/local/bin` **MUST** be a success no-op. `--force` is not required for that second run.
4. Root (`id -u` 0) targets `/usr/local/bin/${APP_NAME}`. Any other login targets `${HOME}/.local/bin/${APP_NAME}`.
5. When `SCRIPT_URL` is empty and the binary is not installed, install **MUST** fail non-zero and **MUST NOT** call curl with an empty URL. It **MUST NOT** invent a GitHub owner.
6. A failed download or checksum **MUST** be non-zero.
7. `app_main` **MUST** run even when the script is read on a pipe. A basename gate on `$0` is forbidden.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product | tn5250-cli |
| Ship unit | `src/tn5250-cli` |
| Channel | `SCRIPT_URL` empty unless the operator exports it, or exports both `REPO_USER` and `REPO_NAME` |
| Payload build | Not this path. `setup` is explicit |

## Under command line for normal user only

Empty argv stays on this login.

**This requirement:** empty argv does not install compiler packages. That install belongs to `setup` and to `docs/requirements/requirement-shell-sudo-command.md`. Git Bash **MUST NOT** be shown a `sudo curl` one-liner. A Linux root login may still be shown the root one-liner. Empty argv does not switch to a dedicated system user.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a second run does not download again.
- **Intentional**: empty argv has one meaning.
- **Anti-fragile**: a missing channel fails closed.
- **Over-protect**: payload setup cannot hide inside the empty path.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Return help from empty argv.
- Start `setup` from empty argv.
- Point the default channel at another product.
- Require `--force` for an already-installed success.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Command map (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-self-management.md` | Install verb (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Companion digest (RQ-SHELL-AUTOMATIC-CHECKSUM) |
| `docs/requirements/requirement-shell-sudo-command.md` | Package install on `setup`, not on empty argv (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-ZERO-01 | Already installed empty argv exits 0 and does not configure CMake | ran on the authoring host |
| TP-ZERO-02 | Not installed, empty `SCRIPT_URL`, non-interactive empty argv exits non-zero and does not configure CMake | ran on the authoring host. Exit 1. curl was not started |

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

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
