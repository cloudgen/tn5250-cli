**file**: docs/requirements/requirement-shell-modular-function-design.md
**ID**: RQ-SHELL-MODULAR-FUNCTION-DESIGN
**Status**: Active (Version 1.0.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns function prefixes in the single ship unit. Each prefix has one job. The TN5250 work uses its own prefix.

### 1.1 Human-facing

**In one sentence:** The script keeps install functions, output functions, and TN5250 functions in separate name groups so a later edit does not mix them.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person editing the script | `src/tn5250-cli` |
| The other role | The person running a command | `tn5250-cli help` |
| Not this file | The CMake link line | `docs/requirements/requirement-windows-git-bash.md` |

| Includes | Excludes |
|----------|----------|
| Prefix names and the rule that domain code is `tn5250_` | Compiler flags and package lists |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | the functions |
| `docs/requirements/requirement-shell-script-coding.md` | writing style | shebang and `set -u` |
| `docs/requirements/requirement-domain-tn5250.md` | domain law | what `tn5250_` must do |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Add a payload step | Put it in a `tn5250_` function | edit `src/tn5250-cli` |

## 2. Core Rules / Requirements (Mandatory)

1. The ship unit **MUST** stay one file.
2. Prefixes **MUST** stay: `out_` messages, `inst_` CLI install lifecycle, `app_` dispatch and help, `util_` shared helpers, `ver_` version compare and check, `prompt_` questions, `tn5250_` payload setup and launch.
3. Payload compile, link, and build **MUST NOT** be implemented as `inst_` functions.
4. New product messages **MUST NOT** introduce an unprefixed `log` or `die`.
5. This file **MUST NOT** restate a generator, a link line, or a package list.

### 2.1 Implementation Notes (this product)

| Prefix | Examples |
|--------|----------|
| `out_` | `out_info`, `out_die`, `out_json` |
| `inst_` | `inst_perform_install`, `inst_self_update` |
| `app_` | `app_main`, `app_help`, `app_about` |
| `tn5250_` | `tn5250_setup`, `tn5250_launch` |

## Under command line for normal user only

Prefixes do not add privilege.

**This requirement:** no prefix is a sudo wrapper, an apt wrapper, or a Termux pkg wrapper.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a new helper joins an existing prefix.
- **Intentional**: payload code is visibly `tn5250_`.
- **Anti-fragile**: Type 0 functions stay findable after domain edits.
- **Over-protect**: one file, not a split that breaks `curl | sh`.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Flatten the prefixes into one style.
- Move payload build into `inst_`.
- Split the ship unit into a library plus a stub.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-script-coding.md` | Writing style (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-domain-tn5250.md` | Domain behavior (RQ-DOMAIN-TN5250) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-MOD-01 | `tn5250_setup` exists and `inst_perform_install` does not configure CMake | ran as a source read |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Prefixes inherited, with `tn5250_` for the client. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
