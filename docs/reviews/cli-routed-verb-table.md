# CLI routed-verb table

Product: tn5250-cli. Ship unit: `src/tn5250-cli`. Dispatcher: `app_main`. Scan date: 2026-10-14. Mode: full. Previous table: 2026-10-13. Re-checked: 12. Copied: 0.

Inventory is the dispatcher. Help text supplied the explanation after the colon. A date is the handler comment’s `Last updated` or `Last reviewed`. `missing` means that comment has no date.

## Live

| verb | handler | privilege | last modified date | human-readable |
|------|---------|-----------|--------------------|----------------|
| install | `inst_perform_install` | you | 2026-06-26 | install: Install tn5250-cli (root→global, user→~/.local/bin) |
| self-install | `inst_perform_install` | you | 2026-06-26 | self-install: Place this CLI the same way as install |
| version-check | `ver_check` | you | 2026-06-26 | version-check: Compare local vs remote version (needs SCRIPT_URL) |
| self-update | `inst_self_update` | you | 2026-06-26 | self-update: Update tn5250-cli to a newer remote version |
| self-uninstall | `inst_self_uninstall` | you | 29 April 2026 | self-uninstall: Remove tn5250-cli (safe PATH cleanup) |
| about | `app_about` | you | April 2026 | about: Show detailed diagnostics |
| help | `app_help` | you | 2026-10-07 | help: Show this help |
| version | `app_version` | you | missing | version: Show current version |
| menu | `app_cmd_menu` | you | 2026-10-07 | menu: Open the numbered list. Needs a terminal |
| main | `app_cmd_menu` | you | 2026-10-07 | main: Open the numbered list. Needs a terminal |
| setup | `tn5250_payload_setup` | you | 2026-10-13 | setup: Download the newest published tn5250 for this machine into ~/.local/bin |
| build | `tn5250_setup` | you; missing compiler packages may change the computer; a global place into an unwritable prefix may use the sudo wrap after the compile | 2026-10-14 | build: On a terminal with no scope, open clean, local, and global. `build local` and `build global` compile and copy the named client into `download/`. On Termux and Windows, `build global` is not available. `build clean` removes the built client and the compile tree |

## Not-yet-wired

None. A word that is not a flag and not a verb above is the host name. It is not a named command.

## Honesty

Full scan. Twelve live rows. `setup` downloads. `build` compiles when a scope or a flag is present, and when the terminal is closed. On Termux and Windows, scope `global` stops before compile. On a terminal, bare `build` and row 1 open the build board. `local`, `global`, `clean`, and `install` are operands of `build`, not new top-level verbs. The host launch has no verb token. On a numbered board, row 2 runs `setup`, row 7 opens languages, and row 82 and a typed `version` run `about`. Argv `version` stays `app_version`. `languages` is a menu category, not an argv verb. `clean`, `local`, and `global` are build-board children, not argv verbs by themselves.
