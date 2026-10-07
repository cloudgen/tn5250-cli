# CLI routed-verb table

Product: tn5250-cli. Ship unit: `src/tn5250-cli`. Dispatcher: `app_main`. Scan date: 2026-10-07. Mode: full. Previous table: absent. Re-checked: 11. Copied: 0.

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
| setup | `tn5250_setup` | you; missing compiler packages may change the computer | missing | setup: Build the upstream client for Git Bash or Debian 12/13 |

## Not-yet-wired

None. A word that is not a flag and not a verb above is the host name. It is not a named command.

## Honesty

Full scan. Eleven live rows. The host launch has no verb token. On a numbered board, row 82 and a typed `version` run `about`. Argv `version` stays `app_version`.
