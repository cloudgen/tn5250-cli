# Review: published payload setup

**Date:** 2026-10-13
**Product version:** 1.1.0
**Scope:** Filename grammar, `setup` download, `about` fields, front row 7 languages.
**Ship unit:** `src/tn5250-cli`

## What was checked

`about --json` on this Termux host reported `payload_arch` `arm64`, `payload_clib` `bionic-30`, and `termux_version` `googleplay.2026.10.09`. The compiler target is `aarch64-unknown-linux-android30`. The phone SDK is 35. `TERMUX_VERSION` is not part of the filename.

`tests/payload-setup.sh` used a `file://` index. It saved the newest app-version as `~/.local/bin/tn5250`, mode executable, and did not leave the long name on `PATH`. The same index listed a newer C-library version (`bionic-99`). Setup did not save that file. A replaced digest stopped the save. `setup -h` named the download and did not compile. No network fetch and no `pkg` call were part of that test. Re-ran on 2026-10-13 after the newer-floor line was added. Exit 0.

`tests/termux-platform.sh` does not call `setup` against the network. It checks help, `setup -h`, and the menu source rows.

No payload bytes are in `download/`. `build` still compiles.

## Findings

| ID | Severity | Status | Note |
|----|----------|--------|------|
| TN5250-PAY-01 | — | fixed | Scratch files from `setup` are removed with `/bin/rm`. PATH `rm` on this host is `safe-rm` and takes about twenty seconds, which made the digest check look hung. |

No P0 or P1.
