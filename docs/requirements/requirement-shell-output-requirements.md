**file**: docs/requirements/requirement-shell-output-requirements.md
**ID**: RQ-SHELL-OUTPUT-REQUIREMENTS
**Status**: Active (Version 1.0.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns person-facing and machine-facing output for tn5250-cli. Every product message goes through `out_*`.

### 1.1 Human-facing

**In one sentence:** Messages from tn5250-cli come from one output family, so quiet and JSON mode stay consistent for install and for setup.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person reading the terminal | `tn5250-cli version` |
| The other role | A program reading JSON | `tn5250-cli --json version` |
| Not this file | What the words mean for the build | `docs/requirements/requirement-domain-tn5250.md` |

| Includes | Excludes |
|----------|----------|
| `out_info`, `out_warn`, `out_error`, `out_die`, `out_plain`, `out_json` | A second `log`/`die` family, and the CMake arguments |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `out_text` |
| `tn5250-cli --json version` | command | one JSON object |
| `tn5250-cli version` | command | human lines |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Ask for JSON | One object on stdout, no human banner | `tn5250-cli --json version` |

## 2. Core Rules / Requirements (Mandatory)

1. Product messages **MUST** call `out_info`, `out_success`, `out_warn`, `out_error`, `out_die`, `out_plain`, or `out_json`. Domain code **MUST** use that same family.
2. `--quiet` **MUST** suppress info and success. Errors **MUST** still appear. Warnings **MUST** still appear.
3. `--json` **MUST** imply quiet for human lines. Success JSON **MUST** go to stdout. Error JSON **MUST** go to stderr through `out_json_error` or `out_die`.
4. JSON string values **MUST** be escaped. A key prefixed with `@` is raw nested JSON and is not used by the current domain fields.
5. A function may print a data return on stdout for `$(...)` capture. That return is not a banner. Callers pass it to `out_*` when a person should see it.
6. `help` in JSON mode **MUST NOT** dump the long human text.

### 2.1 Implementation Notes (this product)

| Item | Value |
|------|--------|
| Human emitter | `out_text` |
| Error exit | `out_die` |
| Version JSON keys | `app`, `version`, `payload_ref`, `payload_revision` |

## Under command line for normal user only

Output rules do not add privilege.

**This requirement:** messages must not instruct Git Bash to run sudo, apt, dnf, or Termux pkg. The Linux root one-liner text, when shown, stays in the zero-arguments requirement.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: JSON consumers never see a banner mixed into stdout.
- **Intentional**: one family for Type 0 and domain.
- **Anti-fragile**: quiet still shows errors.
- **Over-protect**: a new `printf` banner is a defect.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Add a parallel `log`/`die` family for product text.
- Print human help in JSON mode.
- Send error JSON to stdout.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-interface.md` | Flags (RQ-SHELL-CLI-INTERFACE) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-OUT-01 | `--json version` prints one JSON object and no `[INFO]` line | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | `out_*` is the only product output family. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
