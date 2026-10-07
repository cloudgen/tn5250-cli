# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.1] - 2026-10-07

### Added

- Published install channel: `curl -fsSL https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli | sh`.
- Default `REPO_USER` is `cloudgen` and default `REPO_NAME` is `tn5250-cli`. Unset `SCRIPT_URL` composes the raw URL of `src/tn5250-cli`.
- SHA-256 companion `src/tn5250-cli.sha256` is fetched as `${SCRIPT_URL}.sha256`. A match continues, a mismatch stops, and a missing companion warns and continues.
- A terminal with no command opens the numbered list (8 self-management, 9 Exit). A pipe, `--quiet`, or `--json` places this CLI.

### Changed

- Linux root install text is `sudo curl -fsSL … | sudo sh`. Git Bash stays on the command without sudo.
- An explicit empty `SCRIPT_URL` still refuses the download before curl.

## [1.0.0] - 2026-10-07

### Added

- First public baseline of `tn5250-cli` 1.0.0.
- `setup` builds upstream tn5250 v0.18.0 for Windows Git Bash, Debian 12 and 13, Ubuntu 22.04, 24.04, and 26.04, and other Linux.
- Mixed elevated sudo model: the person types `tn5250-cli setup`. Missing compiler packages are the only in-tool sudo. Git and the compile stay with that person. A sudo launch is recovered before git. Help does not tell the person to prefix setup with sudo.
- `help`, `version`, and a host token that launches the built tn5250 program.

### Notes

- The Ubuntu 24.04 setup was run on the authoring host with the compiler already present, so that run did not call sudo. Debian, other Linux, Ubuntu 22.04, Ubuntu 26.04, and Windows compiles were not run for this baseline. A closed terminal and the real return from a sudo launch were not executed.
