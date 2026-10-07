# Product review: tn5250-cli (mixed elevated sudo model)

**Date:** 2026-10-07  
**Reviewer:** implementation pass for the mixed elevated sudo model  
**Product:** tn5250-cli `VERSION=1.0.0`  
**Ship unit:** `src/tn5250-cli`  
**Scope:** The glossary term, the product law that names the model, the ship-unit setup verb, the test-plan rows for that verb, and the host-mutating checklist mold.  
**Method:** Disk read of the ship unit and the requirement registry. `sh -n` and `dash -n` on the ship unit. `src/tn5250-cli version` and `src/tn5250-cli setup -h`.  
**Baseline:** No separate test suite is in this tree. Proof is `docs/reviews/test-plan.md`.

## Summary

The setup verb already followed the mixed elevated sudo model. This pass names that model in the glossary, in the product requirements, and in the ship-unit comment, and it sets the first public product version to 1.0.0. Help still tells the person to type `tn5250-cli setup`. It does not tell them to prefix that verb with sudo. Two proof rows stay open: a closed terminal or `--json` was not executed, and the real `runuser` return was not executed.

## Strengths

| Area | Notes |
|------|--------|
| One verb | Help says setup is the same command for the user and for a sudo launch. Missing packages use sudo from inside setup. Git and the compile stay with the user. |
| One wrap | The only executed `sudo "$@"` is inside `util_sudo`. The package ensure is the caller. |
| Recovery | A root process with a non-root `SUDO_USER` returns with `runuser` before git. A root login with nobody to return to stops before git. |
| Law name | RQ-SHELL-SUDO-COMMAND 1.3.0 names the mixed elevated sudo model and forbids recommending a sudo prefix. |

## Findings

### TN5250-TEST-01 — Severity: P2 (medium)

- **Area:** TEST
- **Status:** open
- **Location:** `docs/reviews/test-plan.md` TP-SUDO-04
- **Description:** `--json` or a closed terminal was not executed against the password-sudo path.
- **Impact:** The fail-closed message for a missing package when nobody can type a password is specified and not shown on this host.
- **Suggestion:** Run that case on a host that is actually missing a compiler package, with `--json` or a closed terminal. Do not uninstall packages on a machine that already builds.
- **Cross-ref:** RQ-SHELL-SUDO-COMMAND rule 6

### TN5250-TEST-02 — Severity: P3 (low)

- **Area:** TEST
- **Status:** open
- **Location:** `tn5250_continue_as_login` and TP-SUDO-05
- **Description:** The real `runuser` return was not executed. Fakeroot covered the stop-before-git cases.
- **Impact:** The recovery branch is written and not shown succeeding on this host.
- **Suggestion:** A later operator run that starts setup with sudo, on a host where `runuser` exists, can close this row.
- **Cross-ref:** RQ-SHELL-SUDO-COMMAND rule 8

## Non-findings (explicitly OK)

| Check | Result |
|-------|--------|
| Help recommends `sudo tn5250-cli setup` | No. The three plain lines name one command, in-tool sudo for packages, and user-owned git and compile. |
| Whole-command sudo is the design | No. Law and the glossary call that a bad design. The `runuser` path is recovery. |
| Elev model used as a gate | No. A normal user continues. |
| Product version | `0.1.0` was the pre-commit provisional value. First public baseline is `1.0.0` in `VERSION="1.0.0"` and the two unset defaults. |
| Requirement bumps | Wording that names the model bumped RQ-SHELL-SUDO-COMMAND 1.2.0 to 1.3.0, RQ-SHELL-SCRIPT-CODING 1.4.0 to 1.4.1, RQ-SHELL-CLI-INTERFACE 1.6.0 to 1.6.1, RQ-DOMAIN-TN5250 1.4.0 to 1.4.1, RQ-DEBIAN 1.5.0 to 1.5.1, RQ-UBUNTU 1.3.0 to 1.3.1, and RQ-OTHER-LINUX 1.3.0 to 1.3.1. Windows Git Bash stays 1.3.1. It does not call the wrap. |
| Debian, jammy, resolute, other Linux, and Windows compiles | Not run on this host. Unchanged from the earlier test plan. |

## Priority remediation order

1. TP-SUDO-04 when a host is actually missing a compiler package.
2. A real `runuser` return when an operator starts setup with sudo.
3. Platform compiles that this host cannot run.

## Related

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-sudo-command.md` | Owner of the wrap and the model name |
| `docs/reviews/test-plan.md` | Proof rows |
| `src/tn5250-cli` | `util_sudo` and `tn5250_continue_as_login` |

**Written by:** the alignment pass on 2026-10-07  
**Review status:** partial. The naming and the ship unit match. Two proof rows stay open. No P0 or P1.
