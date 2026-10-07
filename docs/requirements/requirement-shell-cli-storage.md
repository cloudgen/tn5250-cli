**file**: docs/requirements/requirement-shell-cli-storage.md
**ID**: RQ-SHELL-CLI-STORAGE
**Status**: Active (Version 1.0.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns the scratch directory `app_main` creates for one run of tn5250-cli. Payload source and build caches are not this directory. Those paths stay on the domain requirement.

### 1.1 Human-facing

**In one sentence:** Each run picks a private scratch folder and `about` tells you which one it picked.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose login name is taken from `id -un` | `tn5250-cli about` |
| The other role | The payload cache under the home cache directory | `tn5250-cli setup` |
| Not this file | The TN5250 build tree | `docs/requirements/requirement-domain-tn5250.md` |

| Includes | Excludes |
|----------|----------|
| The scratch tier order and the about fields | The payload source cache, and a shared folder for every login |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `util_resolve_storage` |
| `tn5250-cli about` | command | effective storage line |
| Process environment | `TMPDIR` | later `mktemp` calls |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Ask where scratch went | About names the directory for this run | `tn5250-cli about` |

## 2. Core Rules / Requirements (Mandatory)

1. `app_main` **MUST** resolve storage before dispatch and export `TMPDIR` to that directory.
2. The first usable tier **MUST** win: a writable `/dev/shm`, else a writable `/tmp`, else `${XDG_CACHE_HOME:-${HOME}/.cache}`.
3. The leaf **MUST** be `${APP_NAME}-` plus the login from `id -un`. Two logins **MUST NOT** share one leaf.
4. The directory **MUST** be created. Failure **MUST** stop the run.
5. `about` **MUST** show the effective directory and the fallback field.
6. This file **MUST NOT** record a session login or a `/home/<login>/…` path.

### 2.1 Implementation Notes (this product)

| Item | Value |
|------|--------|
| Resolver | `util_resolve_storage` |
| Payload cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250`, owned by the domain requirement |
| MSYS2 sfx cache | `${HOME}/.cache/tn5250`, owned by the Git Bash requirement |

## Under command line for normal user only

Scratch stays in directories this login can write.

**This requirement:** the resolver does not use sudo, apt, dnf, or Termux pkg.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a failed create stops the run.
- **Intentional**: scratch and payload cache are different trees.
- **Anti-fragile**: a missing ram disk falls through to `/tmp` and then the home cache.
- **Over-protect**: the leaf includes the login so two people do not share it.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Point every login at one shared scratch leaf.
- Store the payload build inside the scratch leaf.
- Write a session login into this requirement.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-domain-tn5250.md` | Payload cache (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-self-management.md` | About (RQ-SHELL-SELF-MANAGEMENT) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-STO-01 | `about` prints an effective storage line | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Scratch tiers for one run. Payload cache stays on the domain requirement. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
