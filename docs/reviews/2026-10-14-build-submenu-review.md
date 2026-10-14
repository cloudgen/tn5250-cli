# Review: build submenu and published copy

**Date:** 2026-10-14
**Product version:** 1.2.0
**Scope:** Build board, `build local`, `build global`, `build clean`, the copy into `download/`, and the `/bin/sh` digit class.
**Ship unit:** `src/tn5250-cli`

## What was checked

`about --json` reports a host C library of the form `glibc-*`. The published name uses the highest `GLIBC_` symbol in the copied client, which is `GLIBC_2.34`. The committed file is `download/tn5250-amd64-glibc-2.34.1.2.0`. Its sibling digest is one bare hex line. `download/index.txt` lists that name.

`build local` on a machine that already had the client installed printed `Published tn5250-amd64-glibc-2.34.1.2.0` and wrote that file under `download/`. It did not recompile. The copy keeps the client's dynamic libraries.

`tests/build-menu.sh` exited 0. It checks syntax, the host C library, help text, an unknown build token, the build board on a pty, clean against a private prefix and a private cache, and the committed file. It does not call sudo and does not install into `/usr/local`. `tests/payload-setup.sh` exited 0.

The sudo place branch for an unwritable prefix is in the ship unit and was not executed. A writable prefix uses the direct copy.

## Findings

| ID | Severity | Status | Note |
|----|----------|--------|------|
| TN5250-BLD-01 | — | fixed | `/bin/sh` treated `^` inside `[]` as a literal, so the host C library parse cleared both numbers and `setup` stopped. The negation is `[!0-9]`. |

No P0 or P1. A live global install into `/usr/local` was not run.
