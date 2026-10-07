**file**: docs/requirements/requirement-shell-interactive-vs-noninteractive.md
**ID**: RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE
**Status**: Active (Version 1.0.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns when tn5250-cli may ask a question. A pipe does not wait. Setup does not interview the person for flags.

### 1.1 Human-facing

**In one sentence:** A piped install does not ask yes or no, and `setup` takes flags instead of a question walk.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at a terminal, or a pipe | `tn5250-cli` |
| The other role | Flags that replace questions | `tn5250-cli setup --prefix DIR` |
| Not this file | The build manual | `docs/requirements/requirement-debian.md` |

| Includes | Excludes |
|----------|----------|
| The first-install question, uninstall confirm, and the ban on a setup interview | A text-screen menu and a field-by-field wizard |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `inst_maybe_install` and `tn5250_setup` |
| `tn5250-cli setup --help` | command | flags, no questions |
| A pipe | non-interactive | no prompt |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Pipe the script | It must not wait for a key | `sh src/tn5250-cli </dev/null` |

## 2. Core Rules / Requirements (Mandatory)

1. Interactive **MUST** mean stdin and stdout are both terminals, recorded once in `TTY` before dispatch. Helpers **MUST** read `TTY`. They **MUST NOT** retest the terminal inside the prompt helper as a second policy.
2. First install on a terminal, when the CLI is absent and neither quiet nor JSON is set, **MAY** ask one yes/no question.
3. A pipe, `--quiet`, or `--json` **MUST** install or fail without reading an answer.
4. Uninstall on a terminal **MUST** confirm unless `--force` is set. A pipe **MUST NOT** block.
5. `setup` **MUST NOT** prompt for prefix, ref, jobs, or the MSYS2 root. Missing flags keep their defaults.
6. There is **no** numbered text menu.

### 2.1 Implementation Notes (this product)

| Situation | Ask? |
|-----------|------|
| Empty argv, not installed, TTY | One yes/no |
| Empty argv, pipe | No |
| `setup` | No |
| `self-uninstall`, TTY, no `--force` | Confirm |

## Under command line for normal user only

Questions do not raise privilege.

**This requirement:** a prompt must not offer sudo, apt, dnf, or Termux pkg as the way through. Git Bash must not be shown a sudo one-liner.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a pipe cannot hang on a question.
- **Intentional**: setup is flags.
- **Anti-fragile**: quiet and JSON skip the question.
- **Over-protect**: no text menu is added beside the prompts that already exist.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Add a setup question walk.
- Block a pipe on stdin.
- Add a numbered main menu.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-domain-tn5250.md` | Setup flags (RQ-DOMAIN-TN5250) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-INT-01 | Non-interactive empty argv does not wait for input | ran on the authoring host |
| TP-INT-02 | `setup -h` prints flags and does not prompt | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Pipe does not prompt. Setup does not interview. No text menu. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
