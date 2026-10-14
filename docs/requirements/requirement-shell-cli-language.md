**file**: docs/requirements/requirement-shell-cli-language.md
**ID**: RQ-SHELL-CLI-LANGUAGE
**Status**: Active (Version 1.1.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns the language of the numbered list. English is the only language. The front board's row 7 opens that list. The numbered membership stays on `docs/requirements/requirement-shell-cli-default-interaction.md`.

### 1.1 Human-facing

**In one sentence:** Row 7 is languages, and the only choice is English.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person reading the list | `7` then `71` |
| The other role | A language that is not on the list | none today |
| Not this file | Which front numbers exist | `docs/requirements/requirement-shell-cli-default-interaction.md` |

| Includes | Excludes |
|----------|----------|
| The English sample, the language board, and the translation table | A second language, and product sentences copied into a portable mold |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open languages | The list says English is the only language | `7` |
| Confirm English | The tool says the language is English and the front board returns | `71` |

## 2. Core Rules / Requirements (Mandatory)

1. The default language **MUST** stay English. Existing menu tests match these English sentences. A new language **MUST** add a sample and a translation-table column in this file before the ship unit prints it.
2. Front row **7** `languages` **MUST** open the language board. That board **MUST** print `The list is English. That is the only language.` Row **71** `en` **MUST** mean English. Choosing it **MUST** print `Language is English.` and return, so the front board is shown again.
3. An empty line, `0`, `q`, `back`, `exit`, or `quit` on the language board **MUST** return to the front board. A wrong token **MUST** print `${choice} is not on this list.` and reprint this board. It **MUST NOT** exit.
4. The choose prompt **MUST** be `Choose a number, or type the command name: ` including the trailing space.
5. This file **MUST NOT** invent a line the ship unit does not print. Leaf verb tokens, JSON `about` field names, and the version one-liner stay in English.
6. On Termux and on Windows, the front row **1** long **MUST** be `Clean, or install the client for this login`. The build board **MUST** print `Local uses the login prefix.`, `Local copies the named client into download/.`, and `Global is not available on Termux.` or `Global is not available on Windows.` It **MUST NOT** print the two lines that name `/usr/local`, and it **MUST NOT** print row **13**. On every other platform, §2.1 is the board.

### 2.1 Worked sample (English, version 1.2.2)

```text
[INFO] **tn5250-cli**(*1.2.2*) — numbered list of live commands
This program has no server commands.
Open a host on the command line: tn5250-cli HOST.
1. **build**: *Clean, or install the client for this login or for every login*
2. **setup**: *Download the newest published tn5250 for this machine*
7. **languages**: *Choose the language of this list*
8. **self-management**: *Place, check, update, or remove this CLI*
9. Exit
```

```text
[INFO] **tn5250-cli**(*1.2.2*) — build
Local uses the login prefix. Global uses /usr/local.
Local and global copy the named client into download/.
11. **clean**: *Remove the built client and the compile tree*
12. **local**: *Build install (local)*
13. **global**: *Build install (global)*
0. Back
```

On Termux the same board is:

```text
[INFO] **tn5250-cli**(*1.2.2*) — numbered list of live commands
This program has no server commands.
Open a host on the command line: tn5250-cli HOST.
1. **build**: *Clean, or install the client for this login*
2. **setup**: *Download the newest published tn5250 for this machine*
7. **languages**: *Choose the language of this list*
8. **self-management**: *Place, check, update, or remove this CLI*
9. Exit
```

```text
[INFO] **tn5250-cli**(*1.2.2*) — build
Local uses the login prefix.
Local copies the named client into download/.
Global is not available on Termux.
11. **clean**: *Remove the built client and the compile tree*
12. **local**: *Build install (local)*
0. Back
```

On Windows the hidden line is `Global is not available on Windows.` The other lines match the Termux board.

```text
[INFO] **tn5250-cli**(*1.2.2*) — languages
The list is English. That is the only language.
71. **en**: *English*
0. Back
```

```text
[INFO] **tn5250-cli**(*1.2.2*) — self-management
This list does not place a payload. Next: tn5250-cli setup.
82. **version**: *Show current version*
83. **about**: *Show detailed diagnostics*
84. **version-check**: *Compare local vs remote version (needs SCRIPT_URL)*
85. **self-update**: *Update tn5250-cli to a newer remote version*
86. **self-uninstall**: *Remove tn5250-cli (safe PATH cleanup)*
87. **self-install**: *Place this CLI the same way as install*
0. Back
```

### 2.2 Translation table

Only English exists. The version token in a sample is the live `VERSION`.

| Key | English |
|-----|---------|
| Front title | numbered list of live commands |
| No server | This program has no server commands. |
| Host hint | Open a host on the command line: tn5250-cli HOST. |
| build long | Clean, or install the client for this login or for every login |
| build long, no global | Clean, or install the client for this login |
| Build title | build |
| Build local line | Local uses the login prefix. Global uses /usr/local. |
| Build copy line | Local and global copy the named client into download/. |
| Build local only line | Local uses the login prefix. |
| Build local copy line | Local copies the named client into download/. |
| Global hidden, Termux | Global is not available on Termux. |
| Global hidden, Windows | Global is not available on Windows. |
| clean long | Remove the built client and the compile tree |
| local long | Build install (local) |
| global long | Build install (global) |
| setup long | Download the newest published tn5250 for this machine |
| languages long | Choose the language of this list |
| self-management long | Place, check, update, or remove this CLI |
| Exit | Exit |
| Language title | languages |
| Only language | The list is English. That is the only language. |
| en long | English |
| Confirmed | Language is English. |
| Back | Back |
| Choose prompt | Choose a number, or type the command name: |
| Unknown | is not on this list. |
| Self title | self-management |
| Self hint | This list does not place a payload. Next: tn5250-cli setup. |
| version long | Show current version |
| about long | Show detailed diagnostics |
| version-check long | Compare local vs remote version (needs SCRIPT_URL) |
| self-update long | Update tn5250-cli to a newer remote version |
| self-uninstall long | Remove tn5250-cli (safe PATH cleanup) |
| self-install long | Place this CLI the same way as install |

Leaf tokens that stay English: `build`, `clean`, `local`, `global`, `setup`, `languages`, `self-management`, `en`, `version`, `about`, `version-check`, `self-update`, `self-uninstall`, `self-install`. JSON `about` fields stay English, including `payload_arch`, `payload_clib`, and `termux_version`.

## Under command line for normal user only

The language board does not raise privilege.

**This requirement:** choosing English does not call sudo or install a package.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a wrong language token stays on this board.
- **Intentional**: one language, English, on row 7.
- **Anti-fragile**: confirming English returns to the front board.
- **Over-protect**: no second language is invented here.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Put languages on row 8, or move self-management off row 8.
- Add a language the ship unit does not print.
- Put these product sentences into a portable menu mold.
- Exit the process because a language token is not on the list.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Front row 7 and the other rows (RQ-SHELL-CLI-DEFAULT-INTERACTION) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-LANG-01 | The ship unit draws row 7 `languages` and row 71 `en`, and the only-language sentence matches this file | ran as a source read on 2026-10-13 |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | English only. Front row 7 is languages. Row 71 confirms English. Worked samples and the translation table live here. |
| 2026-10-14 | Active 1.1.0 | Samples use product version 1.2.0. The build board sentences are in the sample and in the translation table. |
| 2026-10-14 | Active 1.1.1 | Termux and Windows omit row 13. Those boards print the not-available line. The other platforms keep the §2.1 board. Samples use product version 1.2.1. |
| 2026-10-14 | Active 1.1.2 | Samples use product version 1.2.2. |

**Last Updated**: 2026-10-14
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
