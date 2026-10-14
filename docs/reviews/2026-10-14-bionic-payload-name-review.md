# Review: Termux payload name

**Date:** 2026-10-14
**Product version:** 1.2.2
**Scope:** The published name of a Termux build. The Android linker is not glibc.
**Ship unit:** `src/tn5250-cli`

## What was checked

`tn5250-cli build local` on this phone found the client already installed at `v0.18.0` (`cd5980177b9468763bcaa669bf5cacbe7de5ec63`) and published it. It did not compile again. The line was `Published tn5250-arm64-bionic-30.1.2.2`.

That file is `download/tn5250-arm64-bionic-30.1.2.2`, mode `0755`, the same bytes as `~/.local/opt/tn5250/tn5250`. The sibling digest is one bare sha256 line and matches. `download/index.txt` lists it under the existing glibc name. The interpreter is `/system/bin/linker64`. The Android ident note begins `1e 00 00 00` (API 30). `objdump -T` shows no `GLIBC_` symbol.

`tests/build-menu.sh` exited 0, including those checks. `about` on this phone reports `bionic-30`.

## Findings

| ID | Severity | Status | Note |
|----|----------|--------|------|
| TN5250-PAY-01 | — | fixed | Publish treated `/system/bin/linker64` as glibc, found no `GLIBC_` symbol, and stopped after the client was installed. The name now comes from the Android ident note. |

No P0 or P1. The menu pictures in the README show `tn5250-cli(1.2.2)`.
