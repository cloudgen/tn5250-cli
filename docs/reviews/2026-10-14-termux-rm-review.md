# Review: Termux remove and the glibc catalog name

**Date:** 2026-10-14
**Product version:** 1.2.3
**Scope:** Termux file removal, and the committed glibc client name.
**Ship unit:** `src/tn5250-cli`

## What was checked

On Termux, a remove uses `coreutils --coreutils-prog=rm` and does not exec `/bin/rm`. Android toybox and `safe-rm` do not print an error. A warning is acceptable. `setup` still saves a matched download. `build clean` still finishes.

`tests/build-menu.sh` exited 0. It reports `version 1.2.3`. The committed glibc file is `download/tn5250-amd64-glibc-2.34.1.2.3`, mode `0755`, one bare sha256 line, listed in `download/index.txt`. Its highest symbol is `GLIBC_2.34`. The bytes match the former `download/tn5250-amd64-glibc-2.34.1.2.0`. That older name is not in `download/`. The Termux file stays `download/tn5250-arm64-bionic-30.1.2.2`.

`tests/payload-setup.sh` exited 0. It does not compile and does not use the network.

`tests/termux-rm.sh` is the Termux proof for rule 14. It needs `TERMUX_VERSION` and `libtermux-exec.so`, so this host did not execute it. The test plan rows TP-TMX-10 and TP-TMX-11 record the 2026-10-14 Termux run of that remove. The later edit on this host is the product version line.

The menu pictures in the README show `tn5250-cli(1.2.3)`.

## Findings

| ID | Severity | Status | Note |
|----|----------|--------|------|
| TN5250-RM-01 | — | fixed | A Termux login rewrote `/bin/rm` and printed `Syntax error: Unterminated quoted string`. The ship unit no longer execs `/bin/rm` on Termux. |

No P0 or P1.
