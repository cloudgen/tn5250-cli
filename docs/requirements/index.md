# Requirements registry

This folder holds the product law for tn5250-cli. One row is one requirement file. Active means the file is in force.

Windows Git Bash compilation, link, and build are `requirement-windows-git-bash.md`. Debian compilation, link, and build are `requirement-debian.md`. Ubuntu compilation, link, and build are `requirement-ubuntu.md`. Other Linux compilation, link, and build are `requirement-other-linux.md`. `requirement-domain-tn5250.md` is the domain law for setup and host launch. `requirement-shell-sudo-command.md` owns the one sudo wrap that installs missing compiler packages. The setup verb is the mixed elevated sudo model: one command for a normal user and for a sudo launch. Git and the compile stay with that person. Wrapping the whole command in sudo is not the design. The Type 0 rows own the CLI binary’s lifecycle, output, storage, and re-run rules. The other rows point. They do not restate a platform build.

| ID / key | Title | Area | Status | Path | Updated |
|----------|-------|------|--------|------|---------|
| RQ-CLASS-SOFTWARE-DEV | Software-development class and residual pointers | class | Active 1.4.1 | `docs/requirements/requirement-class-software-dev.md` | 2026-10-07 |
| RQ-SHELL-SCRIPT-CODING | POSIX /bin/sh writing style for the ship unit | coding-style | Active 1.4.1 | `docs/requirements/requirement-shell-script-coding.md` | 2026-10-07 |
| RQ-SHELL-SUDO-COMMAND | In-tool sudo for missing compiler packages | shell | Active 1.3.0 | `docs/requirements/requirement-shell-sudo-command.md` | 2026-10-07 |
| RQ-SHELL-CLI-INTERFACE | Command names for tn5250-cli | shell | Active 1.7.0 | `docs/requirements/requirement-shell-cli-interface.md` | 2026-10-07 |
| RQ-SHELL-CLI-ZERO-ARGUMENTS | No command: a pipe places the CLI, a terminal opens the list | shell | Active 1.2.0 | `docs/requirements/requirement-shell-cli-zero-arguments.md` | 2026-10-07 |
| RQ-SHELL-CLI-DEFAULT-INTERACTION | Numbered list for a terminal with no command | shell | Active 1.0.0 | `docs/requirements/requirement-shell-cli-default-interaction.md` | 2026-10-07 |
| RQ-SHELL-SELF-MANAGEMENT | Install, self-install, version-check, self-update, self-uninstall, and about | shell | Active 1.2.0 | `docs/requirements/requirement-shell-self-management.md` | 2026-10-07 |
| RQ-SHELL-OUTPUT-REQUIREMENTS | Person-facing and machine-facing output | shell | Active 1.0.0 | `docs/requirements/requirement-shell-output-requirements.md` | 2026-10-07 |
| RQ-SHELL-AUTOMATIC-CHECKSUM | Companion digest for the published channel | shell | Active 1.1.0 | `docs/requirements/requirement-shell-automatic-checksum.md` | 2026-10-07 |
| RQ-SHELL-CLI-STORAGE | Scratch directory for one run | shell | Active 1.0.0 | `docs/requirements/requirement-shell-cli-storage.md` | 2026-10-07 |
| RQ-SHELL-MODULAR-FUNCTION-DESIGN | Function prefixes in the ship unit | shell | Active 1.0.0 | `docs/requirements/requirement-shell-modular-function-design.md` | 2026-10-07 |
| RQ-SHELL-IDEMPOTENCY | A second successful install is a no-op | shell | Active 1.1.0 | `docs/requirements/requirement-shell-idempotency.md` | 2026-10-07 |
| RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | A pipe does not wait, and setup does not interview | shell | Active 1.1.0 | `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | 2026-10-07 |
| RQ-DOMAIN-TN5250 | TN5250 setup and host launch | domain | Active 1.4.2 | `docs/requirements/requirement-domain-tn5250.md` | 2026-10-07 |
| RQ-WINDOWS-GIT-BASH | Windows Git Bash detect, compilation, link, and build | platform | Active 1.3.1 | `docs/requirements/requirement-windows-git-bash.md` | 2026-10-07 |
| RQ-DEBIAN | Debian 12 and 13 detect, compilation, link, and build | platform | Active 1.5.1 | `docs/requirements/requirement-debian.md` | 2026-10-07 |
| RQ-UBUNTU | Ubuntu 22.04, 24.04, and 26.04 detect, compilation, link, and build | platform | Active 1.3.1 | `docs/requirements/requirement-ubuntu.md` | 2026-10-07 |
| RQ-OTHER-LINUX | Other Linux detect, compilation, link, and build | platform | Active 1.3.1 | `docs/requirements/requirement-other-linux.md` | 2026-10-07 |
