# Reviews

**Purpose:** Durable product and process review records for tn5250-cli.
Not product law (`docs/requirements/`). Not an incident report.

| File | Date | Scope | Status |
|------|------|-------|--------|
| `test-plan.md` | 2026-10-14 | Build, platform, sudo, Termux, Alpine, macOS, and Fedora and Red Hat proof rows | Living plan. Some rows todo. Termux rows ran. Alpine, macOS, and Fedora and Red Hat compile rows are todo |
| `cli-routed-verb-table.md` | 2026-10-14 | Live command inventory | Full scan. Not product law. On Termux and Windows, `build global` stops |
| `2026-10-07-mixed-elevated-sudo-model-review.md` | 2026-10-07 | Mixed elevated sudo model alignment | Open proof gaps. No P0 or P1 |
| `2026-10-13-termux-build-review.md` | 2026-10-13 | Termux build and pub400.com session | Build proved. Sign-on refused by the host. No P0 or P1 |
| `2026-10-13-payload-setup-review.md` | 2026-10-13 | Published payload name, setup download, about fields, and menu row 7 | `file://` setup proved. No payload bytes committed. No P0 or P1 |
| `2026-10-14-build-submenu-review.md` | 2026-10-14 | Build board, published copy, and the glibc digit class | No P0 or P1. A live install into `/usr/local` was not run |
| `2026-10-14-no-global-termux-windows-review.md` | 2026-10-14 | `build global` refused on Termux and Windows. Product version 1.2.1 | No P0 or P1. The committed client stays the 1.2.0 file |
| `2026-10-14-bionic-payload-name-review.md` | 2026-10-14 | Termux publish name. Product version 1.2.2 | No P0 or P1. `download/tn5250-arm64-bionic-30.1.2.2` is the installed client |
| `2026-10-14-termux-rm-review.md` | 2026-10-14 | Termux remove and the glibc catalog name. Product version 1.2.3 | No P0 or P1. Removes use Termux coreutils. The glibc file is `download/tn5250-amd64-glibc-2.34.1.2.3` |

## Conventions

| Element | Rule |
|---------|------|
| Path | `docs/reviews/YYYY-MM-DD-<scope>-review.md` |
| Findings IDs | `TN5250-<AREA>-NN` |
| Severity | P0 · P1 · P2 · P3 |
| Status | open · fixed · deferred · wontfix |
