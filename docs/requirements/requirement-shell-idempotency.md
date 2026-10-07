**file**: docs/requirements/requirement-shell-idempotency.md
**ID**: RQ-SHELL-IDEMPOTENCY
**Status**: Active (Version 1.1.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns re-run safety. A second successful install of the CLI binary is a no-op. A second setup of the same payload revision can skip the compile. `--force` is the deliberate repeat.

### 1.1 Human-facing

**In one sentence:** Running the installer again, after it has already succeeded, does not download or rebuild unless you pass `--force`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who runs the same command twice | `tn5250-cli` |
| The other role | A deliberate rebuild | `tn5250-cli setup --force` |
| Not this file | How the compile is invoked | `docs/requirements/requirement-windows-git-bash.md` |

| Includes | Excludes |
|----------|----------|
| Already-installed success, and setup skip when ref and revision match | A new package list, and a text-screen menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | install no-op and setup skip |
| `tn5250-cli` | command | second run |
| `tn5250-cli setup --force` | command | rebuild |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Pipe it again | Already installed, success, no download | `sh src/tn5250-cli </dev/null` |

## 2. Core Rules / Requirements (Mandatory)

1. A second `install` or `self-install`, or a non-interactive empty argv, when the CLI binary is already present and `--force` is off, **MUST** succeed and **MUST NOT** download. An interactive empty argv opens the numbered list and **MUST NOT** download.
2. `setup` with `--force` off **MUST** skip the compile when the payload directory already has the requested ref and the current checkout revision. The Windows file records that this skip does not include the patch text in the key. This file points there. It does not add a new fail-closed rule.
3. `--force` **MUST** be the switch for a deliberate CLI reinstall and for a deliberate payload rebuild.
4. A real failure **MUST** stay non-zero. “Already installed” is not a failure.

### 2.1 Implementation Notes (this product)

| Path | Repeat without `--force` |
|------|--------------------------|
| CLI install | Success no-op |
| Payload setup | Skip when `REF` and `REVISION` match |

## Under command line for normal user only

Re-runs stay on this login.

**This requirement:** idempotency does not add sudo, apt, dnf, or Termux pkg.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a retry after success is safe.
- **Intentional**: force is explicit.
- **Anti-fragile**: partial failure still fails.
- **Over-protect**: the Windows skip quirk stays written on the Windows file.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Make a second install fail because the file exists.
- Hide `--force` as the only way to get a success no-op.
- Turn the Windows patch-skip note into a new obligation from this file.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-windows-git-bash.md` | Rebuild skip note (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-domain-tn5250.md` | Setup (RQ-DOMAIN-TN5250) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-IDEM-01 | Second non-interactive empty argv on an installed binary exits 0 | ran on the authoring host |
| TP-IDEM-02 | Setup skip when ref and revision match | todo |

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
| 2026-10-07 | Active 1.0.0 | CLI re-run is a no-op. Payload skip points at the Windows note. |
| 2026-10-07 | Active 1.1.0 | The no-download repeat is `install`, `self-install`, and non-interactive empty argv. A terminal with no command opens the list and does not download. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
