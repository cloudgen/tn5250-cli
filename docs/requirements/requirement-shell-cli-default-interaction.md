**file**: docs/requirements/requirement-shell-cli-default-interaction.md
**ID**: RQ-SHELL-CLI-DEFAULT-INTERACTION
**Status**: Active (Version 1.3.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns the numbered list for tn5250-cli. A person at a terminal who types no command sees that list. `menu` and `main` open the same list. A pipe does not.

### 1.1 Human-facing

**In one sentence:** At a terminal, `tn5250-cli` with no command shows a numbered list; 1 opens build, 2 downloads, 7 is languages, 8 is self-management, and 9 leaves.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at a terminal | `tn5250-cli` |
| The other role | A pipe, which places the CLI instead | `sh src/tn5250-cli </dev/null` |
| Not this file | How the CLI is placed, and how the client is built | `docs/requirements/requirement-shell-cli-zero-arguments.md` |

| Includes | Excludes |
|----------|----------|
| The front list, row 1 opening the build board, row 2 running setup, row 7 opening languages, the self-management list, a wrong number that stays on the list, and leaving with 9 | Help as a row, menu as a row, a pipe that waits, and a path-and-clock screen |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | ship unit | `app_cmd_menu`, `app_cmd_menu_language`, and `app_cmd_menu_self` |
| `tn5250-cli` | command | the list, when a terminal has no command |
| `tn5250-cli menu` | command | the same list |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open the list | Build is 1. Setup is 2. Languages is 7. Self-management is 8. Exit is 9 | `tn5250-cli` |
| Open build | Clean is 11. Local is 12. Global is 13, except on Termux and Windows, where that row is omitted. Back is 0 | `1` |
| Download a client from the list | That row runs setup and does not compile | `2` |
| Place the CLI from the list | That row is under 8 | `87` |

## 2. Core Rules / Requirements (Mandatory)

1. This product **claims** the numbered list. A zero-argument requirement exists. It defers a terminal with no command, when quiet and JSON are off, to this list. A pipe, `--quiet`, or `--json` with no command stays self-install on `docs/requirements/requirement-shell-cli-zero-arguments.md`.
2. `menu` and `main` **MUST** open this list on a terminal. `--json` on a terminal **MUST** be ignored while the list is drawn. Off a terminal, `menu` and `main` **MUST** stop with `menu needs a terminal. Next: tn5250-cli help` and exit 1. In JSON mode that stop **MUST** be a JSON error.
3. The front board **MUST** be row **1** `build`, row **2** `setup`, row **7** `languages`, row **8** `self-management`, and row **9** Exit. This product has no server commands, so row **2** is not a server category. Row **1** and a typed `build` with no extra arguments, on a terminal, with JSON and quiet off, **MUST** open the build board. They **MUST NOT** compile on that open. Off a terminal, a typed `build` with no scope **MUST** install local and **MUST NOT** wait for a menu. Any build flag **MUST** skip the build board and **MUST** default the scope to local when no scope token was given. Row **2** and a typed `setup` **MUST** run `tn5250_payload_setup` with no extra arguments. They **MUST NOT** run `tn5250_setup`. Row **7** and a typed `languages` **MUST** open the language board. The sentences on the boards are owned by `docs/requirements/requirement-shell-cli-language.md`. After a verb returns, the front board **MUST** be shown again. The front board **MUST NOT** list `help`, `menu`, `main`, `install`, `self-install`, `version`, `about`, `version-check`, `self-update`, or `self-uninstall`. Self-management **MUST** stay row **8**. Languages **MUST NOT** move onto row **8**.
3b. On Debian, Ubuntu, other Linux, Alpine, Fedora, Red Hat Enterprise Linux, and macOS, the build board **MUST** be row **11** `clean`, row **12** `local`, row **13** `global`, and **0** Back. **11** and `clean` **MUST** run `tn5250_setup clean`. **12** and `local` **MUST** run `tn5250_setup local`. **13** and `global` **MUST** run `tn5250_setup global`. On Termux and on Windows, row **13** **MUST** be omitted. The integer **13** stays reserved. Before the numbers, that board **MUST** print the menu-hidden message in `docs/requirements/requirement-shell-cli-language.md`. **13** and `global` on that board **MUST** print `${choice} is not on this list.` and **MUST** reprint the board. They **MUST NOT** compile or clean, and they **MUST NOT** exit. A leaf **MUST** return so the front board is shown again. The build board **MUST NOT** stay open after a leaf. An empty line, `0`, `q`, `back`, `exit`, or `quit` on the build board **MUST** return to the front board without compiling. A wrong token **MUST** reprint the build board.
4. Before those numbers, the front board **MUST** print `This program has no server commands.` and `Open a host on the command line: tn5250-cli HOST.`
5. Row **8** **MUST** open the self-management list. That list **MUST** be **82** `version`, **83** `about`, **84** `version-check`, **85** `self-update`, **86** `self-uninstall`, **87** `self-install`, and **0** Back. **81** **MUST NOT** be printed. Before the numbers, that list **MUST** print `This list does not place a payload. Next: tn5250-cli setup.`
6. On the self-management list, row **82** and a typed `version` **MUST** run `about`. A typed `install` **MUST** run the same place as `self-install`. Argv `tn5250-cli version` stays the thin version line.
7. The header **MUST** show the name and the live version, then the board title. On a terminal the name is bold and the version is italic. Each command row **MUST** be the number, a bold short name, and an italic light-gray explanation. Off a terminal the list is not drawn.
8. The choice **MUST** be read in the current shell. The script **MUST NOT** capture that read with `$()` or backticks. The value is `PROMPT_ASK_VALUE`.
9. A wrong number or a wrong name **MUST** print an error, reprint **this** list, and ask again. It **MUST NOT** exit. The error **MUST** be `${choice} is not on this list.`
10. An empty line, `9`, `q`, `exit`, or `quit` on the front board **MUST** leave and return 0. An empty line, `0`, `q`, `back`, `exit`, or `quit` on the self-management list, the language board, or the build board **MUST** return to the front board. EOF **MUST** leave that list without spinning.
11. After a command on the self-management list finishes, the front board **MUST** be shown again. The self-management list **MUST NOT** stay open. After a leaf on the build board, setup from row **2**, or English from row **71**, the front board **MUST** be shown again.

### 2.1 Implementation Notes (this product)

| Item | Value |
|------|--------|
| Claimed | yes |
| Case | Zero-argument law defers the terminal with no command here. Non-interactive no-command stays self-install |
| Front handler | `app_cmd_menu` |
| Build handler | `app_cmd_menu_build` |
| Self-management handler | `app_cmd_menu_self` |
| Language handler | `app_cmd_menu_language` |
| Actor consider | Already recorded on the class file. No dest approver and no approval subject |

| Number | Parent | Short name | Long description | Runs |
|--------|--------|------------|------------------|------|
| 1 | — | build | Clean, or install the client for this login or for every login | the build board |
| 11 | 1 | clean | Remove the built client and the compile tree | `build clean` |
| 12 | 1 | local | Build install (local) | `build local` |
| 13 | 1 | global | Build install (global) | `build global`. Omitted on Termux and Windows. The integer stays reserved |
| 0 | 1 | Back | — | the front board |
| 2 | — | setup | Download the newest published tn5250 for this machine | `setup` (`tn5250_payload_setup`) |
| 7 | — | languages | Choose the language of this list | the language board |
| 8 | — | self-management | Place, check, update, or remove this CLI | the self-management list |
| 9 | — | Exit | — | leave, status 0 |
| 71 | 7 | en | English | confirm English, then the front board |
| 0 | 7 | Back | — | the front board |
| 82 | 8 | version | Show current version | `about` |
| 83 | 8 | about | Show detailed diagnostics | `about` |
| 84 | 8 | version-check | Compare local vs remote version (needs SCRIPT_URL) | `version-check` |
| 85 | 8 | self-update | Update tn5250-cli to a newer remote version | `self-update` |
| 86 | 8 | self-uninstall | Remove tn5250-cli (safe PATH cleanup) | `self-uninstall` |
| 87 | 8 | self-install | Place this CLI the same way as install | `self-install` |
| 0 | 8 | Back | — | the front board |

### 2.2 Example (build board; current shell)

```sh
# WARNING — do-not-capture-read. The choice is PROMPT_ASK_VALUE.
# A leaf returns so the front board is shown again.
app_cmd_menu_build() {
    local _choice=""
    while true; do
        app_menu_draw_build
        if ! app_menu_read_choice; then
            return 0
        fi
        _choice="${PROMPT_ASK_VALUE}"
        case "${_choice}" in
            ""|0|q|back|exit|quit)
                return 0
                ;;
            11|clean)
                tn5250_setup clean
                return 0
                ;;
            12|local)
                tn5250_setup local
                return 0
                ;;
            13|global)
                if [ -n "$(tn5250_global_place)" ]; then
                    out_error "${_choice} is not on this list."
                else
                    tn5250_setup global
                    return 0
                fi
                ;;
            *)
                out_error "${_choice} is not on this list."
                ;;
        esac
    done
}
```

## Under command line for normal user only

The list does not raise privilege.

**This requirement:** rows 2, 7, 8, and 82 through 87 do not offer sudo, apt, dnf, or Termux pkg. Row 2 downloads. Row 1 opens the build board. Row 12 runs the build verb. Row 13 runs it where global is available. On Termux and Windows, row 13 is omitted. A missing compiler package may ask for the administrator password inside that verb. A global place into a prefix this login cannot write may use the same wrap after the compile. That ask is owned by `docs/requirements/requirement-shell-sudo-command.md`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a wrong number stays on this list.
- **Intentional**: 1 opens build, 2 downloads, 7 is languages, 8 is self-management, and 9 leaves.
- **Anti-fragile**: a pipe never opens the list.
- **Over-protect**: the self-management list does not place a payload. Setup is row 2, not row 81. Languages stay off row 8.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Open this list from a pipe, from `--quiet`, or from `--json` with no command.
- Put `help` or `menu` on the list.
- Put the token `build` on any list except front-board row 1. The build board's children are `clean`, `local`, and `global`.
- Number the build board from 1. Its children are 11, 12, and 13. On Termux and Windows, 13 is omitted and is not renumbered.
- Put `setup` on row 1, on row 8, or on row 81.
- Move self-management off row 8, or put languages on row 8.
- Exit the process because a number is not on the list.
- Read the choice with `$()`.
- Stay on the self-management list after a command finishes.
- Draw a path-and-clock screen.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | No command: pipe places the CLI (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-shell-cli-interface.md` | `menu` and `main` (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | A pipe does not wait (RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE) |
| `docs/requirements/requirement-shell-self-management.md` | What the self-management rows run (RQ-SHELL-SELF-MANAGEMENT) |
| `docs/requirements/requirement-shell-cli-language.md` | English samples and the translation table (RQ-SHELL-CLI-LANGUAGE) |
| `docs/requirements/requirement-payload-filename.md` | What row 2 downloads (RQ-PAYLOAD-FILENAME) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-MENU-01 | `menu` off a terminal exits 1 and names help | ran on the authoring host |
| TP-MENU-02 | A wrong number reprints the list and does not exit | ran on the authoring host |
| TP-MENU-03 | Row 8 opens self-management, 0 returns to the front, and 9 exits 0 | ran on the authoring host |
| TP-MENU-04 | Row 82 runs about, then the front list is shown again | ran on the authoring host |
| TP-MENU-05 | `menu --json` on a terminal still draws the list | ran on the authoring host |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | A terminal with no command opens this list. `menu` and `main` open it too. A pipe does not. |
| 2026-10-08 | Active 1.1.0 | Front board row 1 is `setup` and runs `tn5250_setup`. A host name stays on the command line. |

| 2026-10-13 | Active 1.1.1 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
| 2026-10-13 | Active 1.2.0 | Front row 2 is `setup` and downloads. Front row 7 is `languages`. Row 8 stays self-management. The self-management hint names `setup`. |
| 2026-10-14 | Active 1.3.0 | Row 1 opens the build board. Children are 11 clean, 12 local, and 13 global. A leaf returns to the front board. Off a terminal, bare `build` installs local. |
| 2026-10-14 | Active 1.3.1 | On Termux and Windows, row 13 is omitted. The board prints the menu-hidden message before the numbers. Choosing 13 or `global` there stays on the board. |

**Last Updated**: 2026-10-14
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
