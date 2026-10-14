# Review: no global build on Termux or Windows

**Date:** 2026-10-14
**Product version:** 1.2.1
**Scope:** `build global` on Termux and Windows, the build board, and the product version.
**Ship unit:** `src/tn5250-cli`

## What was checked

`tn5250-cli version` prints `tn5250-cli version 1.2.1`.

`tests/build-menu.sh` exited 0. On a Termux stand-in the build board omits row 13, prints `Global is not available on Termux.`, and `build global`, `build install global`, and `build clean global` exit non-zero and leave a marked prefix in place. A Windows `OSTYPE` and `uname -s` pair does the same and names Windows. The committed file stays `download/tn5250-amd64-glibc-2.34.1.2.0`. Its highest symbol is `GLIBC_2.34`.

`tests/payload-setup.sh` exited 0.

`tests/termux-platform.sh` still exits 1. Top-level `help` does not name Alpine, macOS, Fedora, or Red Hat. `build -h` does. That gap is already true of product version 1.2.0. This release does not change those lines.

The menu pictures in the README show `tn5250-cli(1.2.1)`.

## Findings

| ID | Severity | Status | Note |
|----|----------|--------|------|
| TN5250-GLB-01 | — | fixed | On Termux and Windows, `build global` used to choose `/usr/local`. It now stops before a prefix, a clean, or a compile, and names `build local`. |

No P0 or P1. A live Termux or Windows compile was not run.
