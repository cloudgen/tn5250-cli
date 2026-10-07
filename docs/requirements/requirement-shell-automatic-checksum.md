**file**: docs/requirements/requirement-shell-automatic-checksum.md
**ID**: RQ-SHELL-AUTOMATIC-CHECKSUM
**Status**: Active (Version 1.1.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns integrity for a download of the tn5250-cli script. The published channel is `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli`. Install and self-update verify the SHA-256 companion `src/tn5250-cli.sha256`.

### 1.1 Human-facing

**In one sentence:** An install of tn5250-cli checks the sibling `.sha256` file and stops on a mismatch.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person installing from a channel | `tn5250-cli install` |
| The other role | The publisher who ships the digest beside the script | `SCRIPT_URL.sha256` |
| Not this file | The TN5250 source tarball and the MSYS2 archive | `docs/requirements/requirement-windows-git-bash.md` |

| Includes | Excludes |
|----------|----------|
| Companion link, expected digest, and match or mismatch | Embedding the digest inside the script, and listing `CHECKSUM` in help |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | download verify |
| `tn5250-cli help` | command | channel vars, not `CHECKSUM` |
| Operator environment | `SCRIPT_URL` | the channel, when set |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Install with no channel | The tool stops. It does not pretend a digest exists | `tn5250-cli install` |

## 2. Core Rules / Requirements (Mandatory)

1. When `CHECKSUM` is set and `SCRIPT_URL` is set, the download **MUST** match that digest or the install **MUST** abort.
2. When `CHECKSUM` is empty and `SCRIPT_URL` is set, the tool **MUST** try `${SCRIPT_URL}.sha256`. A match **MUST** be reported as pass. A mismatch **MUST** abort. A missing companion **MUST** warn and may continue.
3. When `SCRIPT_URL` is empty, install and self-update **MUST** fail before any download. They **MUST NOT** invent a companion URL.
4. The script **MUST NOT** embed its own SHA-256 as the verify target.
5. `help` and `about` **MUST NOT** list `CHECKSUM`.
6. The companion file **MUST** be `src/tn5250-cli.sha256`, the digest of `src/tn5250-cli`. A published channel **MUST** ship that file in the same release. The script **MUST NOT** embed that digest.

### 2.1 Implementation Notes (this product)

| Item | Value |
|------|--------|
| Algorithm | SHA-256 |
| Channel | `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli` |
| Companion | `src/tn5250-cli.sha256` |
| MSYS2 archive | No checksum. That fact stays on the Git Bash requirement. This file does not own it |

## Under command line for normal user only

Checksum checks do not raise privilege.

**This requirement:** verification does not call sudo, apt, dnf, or Termux pkg.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a mismatch stops the install.
- **Intentional**: an empty channel is not a fake URL.
- **Anti-fragile**: a missing companion warns; a wrong companion fails.
- **Over-protect**: help does not teach `CHECKSUM` as a required flag.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Store the expected digest inside the script as the check target.
- Publish a digest for a channel that does not exist.
- List `CHECKSUM` in help or about.
- Treat the MSYS2 archive gap as closed by this file.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-self-management.md` | Install and update (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-windows-git-bash.md` | MSYS2 archive has no checksum (RQ-WINDOWS-GIT-BASH) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-SUM-01 | Install with an explicit empty `SCRIPT_URL` exits non-zero before curl | ran 2026-10-07. Exit 1. stderr: `SCRIPT_URL is empty. Refusing to download.` curl was not started |
| TP-SUM-02 | A mismatched companion aborts install | todo |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Automatic checksum

**Definition:** An automatic checksum is a digest file published beside the program. The installer downloads it, compares it, and reports the link, the value, and the result. The operator does not have to type the digest.

**Human daily-life explanation:** An automatic checksum is the packing slip next to the box. You compare the slip to the box. You do not write the slip on the box itself and then trust it.

**Daily-life example:** The store receipt sits beside the parcel. If the weight does not match, you refuse the parcel.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Companion verify is the mechanism. No digest is published because no channel is published. |
| 2026-10-07 | Active 1.1.0 | The published channel ships `src/tn5250-cli.sha256` beside `src/tn5250-cli`. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
