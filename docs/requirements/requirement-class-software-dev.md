**file**: docs/requirements/requirement-class-software-dev.md
**ID**: RQ-CLASS-SOFTWARE-DEV
**Status**: Active (Version 1.4.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This workspace makes a program people can run. Its project nature is software development. This file is the class law for that nature and the residual home for stack facts that no other requirement owns yet.

The Windows Git Bash compile, link, and build belong to `docs/requirements/requirement-windows-git-bash.md`. The Debian compile, link, and build belong to `docs/requirements/requirement-debian.md`. The Ubuntu compile, link, and build belong to `docs/requirements/requirement-ubuntu.md`. The other-Linux compile, link, and build belong to `docs/requirements/requirement-other-linux.md`. The way the ship unit is written belongs to `docs/requirements/requirement-shell-script-coding.md`. Domain setup and host launch belong to `docs/requirements/requirement-domain-tn5250.md`. In-tool sudo for missing compiler packages belongs to `docs/requirements/requirement-shell-sudo-command.md`. This file points. It does not restate them.

### 1.1 Human-facing

**In one sentence:** A maintainer treats this folder as software development and looks here for the language and the pointers, then opens the platform requirement for Windows, Debian, Ubuntu, or other Linux.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person keeping the product law | Open this file when the question is “what kind of project is this?” |
| The other role | The person who runs setup, on Git Bash or on Linux | That person follows the requirement for that platform |
| Not this file | The CMake arguments, the library link, and the writing rules | Those live on the platform requirements and the coding-style requirement |

| Includes | Excludes |
|----------|----------|
| Project nature, primary languages, and which peer owns the toolchain, the package tools, and the writing style | A second copy of the CMake invocation, the link line, or the writing-style rules |

| Surface | What you open | What for |
|---------|---------------|----------|
| `docs/requirements/requirement-class-software-dev.md` | this file | nature and residual pointers |
| `docs/requirements/requirement-windows-git-bash.md` | Git Bash requirement | Windows compilation, link, and build |
| `docs/requirements/requirement-debian.md` | Debian requirement | Debian compilation, link, and build |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu requirement | Ubuntu compilation, link, and build |
| `docs/requirements/requirement-other-linux.md` | Other Linux requirement | Other Linux compilation, link, and build |
| `src/tn5250-cli` | ship unit | the program people run |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Confirm the nature | This folder ships an installer script. The script’s Windows build is a peer requirement, not a paragraph in this file | `tn5250-cli setup` |

## 2. Core Rules (Mandatory — portable)

### 2.0 Project nature membership

1. **MUST** treat this workspace as software development: shippable software, not an empty seed and not a server-maintenance allowlist.
2. **MUST** keep this basename, `requirement-class-software-dev.md`, as the only Active class-law file.
3. **MUST NOT** register an Active server-maintenance class file beside it.
4. **MUST NOT** invent hollow product documents only to look specialized. Collect a real value or defer it in one sentence.

### 2.1 Residual collection

5. **MUST** keep stack facts here only while no other Active requirement owns them.
6. **MUST NOT** copy a peer’s normative tables into this file. A one-line pointer is the residual.
7. When a peer takes a topic, **MUST** update this file in the same change.
8. **MUST NOT** leave two different primary-language claims.

### 2.2 Programming languages

9. **MUST** declare the primary language of the ship unit.
10. **SHOULD** list a second language only when the product really builds or runs it.
11. **MUST** say whether the product is interpreted, compiled, or both.
12. **MUST NOT** treat the product’s brand as the language name.

### 2.3 Compilers and toolchains

13. **MUST** declare the toolchain class used to build or run the product.
14. **MUST** state a version policy: unconstrained, a minimum, a range, or a pin.
15. **SHOULD** say whether cross-compilation is in scope.
16. **MUST NOT** claim that every compiler works unless tests say so or the policy is explicitly unconstrained.

### 2.4 Package and build tools

17. **MUST** declare the primary package or build tool.
18. **MUST** declare lockfile policy when the ecosystem has lockfiles.
19. **SHOULD** name test-runner and formatter classes when they are law. Detail belongs on the coding-style requirement or a test requirement.
20. **MUST NOT** store a secret, a token, or a registry password here.

### 2.5 Runtime

21. **MUST** declare the primary runtime family when no architecture requirement owns it.
22. **SHOULD** declare CPU families only when they are real law.
23. **MUST** separate the developer machine from the end-user machine when they differ.

### 2.6 No hardcoded product brand in core rules

24. **MUST NOT** freeze one product brand, one production hostname, one person, or a session display id into these core rules as if every project shared them.
25. **MUST NOT** write a session Unix login, a literal home expansion, or a `/home/<login>/…` path in core rules or in Implementation Notes.
26. **MUST** put this product’s name and pinned versions in Implementation Notes.
27. **MUST NOT** store secrets in this file.

### 2.8 Actor, role, subject, approver

28. **MUST** consider who submits, who the subject is, and who approves, even when there is no approval desk.
29. **MUST** either publish an actor-role file or record the residual below.
30. **MUST NOT** invent an approver so the table looks complete.

### 2.9 Dest fence conditions

31. **MUST** review whether any dest fencing condition exists.
32. Each real dest fence **MUST** be its own requirement. This product has none.
33. **MUST NOT** invent a dest fence so the set looks complete.

### 2.10 Coding-style requirement

34. **MUST** have an Active coding-style requirement matched to the ship unit’s language.
35. Without that requirement, portable learned lessons arrive raw and get treated as this product’s law.
36. This file **MUST** point at that requirement. It **MUST NOT** keep the writing-style body here.

### 2.11 Implementation Notes (this project)

| Field | Value |
|-------|--------|
| Project display name | tn5250-cli |
| Project nature | software development |
| Class requirement basename | `requirement-class-software-dev.md` |
| Primary language | POSIX `/bin/sh` for the ship unit. C for the payload that setup compiles |
| Language role | Interpreted `/bin/sh` ship unit. Compiled C payload. Polyglot in that limited sense |
| Toolchain | Ship unit: `/bin/sh`, `set -u`, no global `set -e`. Windows payload compiler and linker: `docs/requirements/requirement-windows-git-bash.md`. Debian payload compiler and linker: `docs/requirements/requirement-debian.md`. Ubuntu payload compiler and linker: `docs/requirements/requirement-ubuntu.md`. Other Linux payload compiler and linker: `docs/requirements/requirement-other-linux.md` |
| Toolchain version policy | Payload pin and CMake minimum live on the platform requirements. The shell is `/bin/sh` as the ship unit is written |
| Cross-compile in scope? | No. Windows setup produces Windows x86_64 programs. Each Linux setup produces native programs for that machine |
| Primary project/package tool | CMake for the C builds. MSYS2 pacman is owned by the Git Bash requirement. Debian package names are owned by the Debian requirement. Ubuntu package names are owned by the Ubuntu requirement. Other Linux checks tools, not one distribution’s package names. This file does not restate them |
| Lockfile policy | Not used |
| Test runner | Not yet collected. Todo rows live in `docs/reviews/test-plan.md` |
| Linter/formatter | Not yet collected. Writing rules that are adopted live on `docs/requirements/requirement-shell-script-coding.md`. `sh -n` and `dash -n` exit 0 on the authoring host. That is a syntax check |
| Primary runtime / OS family | Windows Git Bash on x86_64, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, and other Linux. Each platform requirement owns its build |
| Architectures supported | Windows: x86_64. Linux: the native architecture of that install |
| Git surface | Not used. This folder is not a git working tree. No origin URL is declared |
| Workspace (host) | Ram-drive-first `/dev/shm/tn5250-cli` when that directory is present, otherwise `{{PROJECTS_ROOT}}/tn5250-cli` |
| Ship unit | `src/tn5250-cli` |
| In-tool sudo | `docs/requirements/requirement-shell-sudo-command.md`. One wrap. Package install only. This file points |
| Actor / role / subject / approver | Considered — no dest approver and no approval subject. The person acts on that person’s own prefix |
| Dest fence conditions | Considered — no dest fence conditions |

**Residual ownership**

| Topic | Owner | Notes |
|-------|--------|-------|
| Project nature membership | this file | software development |
| Primary language of the ship unit | this file | POSIX `/bin/sh`. The C payload is named here. Windows details are on the Git Bash requirement. Linux details are on the Debian, Ubuntu, and other-Linux requirements |
| Compiler, linker, CMake, package install for the Windows client | `docs/requirements/requirement-windows-git-bash.md` | This file points |
| Compiler, linker, CMake, and Debian packages for the Unix client | `docs/requirements/requirement-debian.md` | This file points. Debian 12 and 13 |
| Compiler, linker, CMake, and Ubuntu packages for the Unix client | `docs/requirements/requirement-ubuntu.md` | This file points. Ubuntu 22.04, 24.04, and 26.04 |
| Compiler, linker, and CMake for other Linux | `docs/requirements/requirement-other-linux.md` | This file points. Tool checks, not one distribution’s package names |
| Routed command names | `docs/requirements/requirement-shell-cli-interface.md` | Points each platform’s build at that platform requirement |
| Empty argv | `docs/requirements/requirement-shell-cli-zero-arguments.md` | CLI binary only. This file points |
| Type 0 lifecycle | `docs/requirements/requirement-shell-self-management.md` | This file points |
| Output | `docs/requirements/requirement-shell-output-requirements.md` | This file points |
| Companion digest | `docs/requirements/requirement-shell-automatic-checksum.md` | This file points. No channel is published |
| Scratch storage | `docs/requirements/requirement-shell-cli-storage.md` | This file points |
| Function prefixes | `docs/requirements/requirement-shell-modular-function-design.md` | This file points |
| Re-run | `docs/requirements/requirement-shell-idempotency.md` | This file points |
| Prompts | `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | This file points |
| Domain setup and host launch | `docs/requirements/requirement-domain-tn5250.md` | This file points. Area domain |
| Coding style | `docs/requirements/requirement-shell-script-coding.md` | Specialize-in home. This file points |
| In-tool sudo | `docs/requirements/requirement-shell-sudo-command.md` | The wrap installs missing compiler packages. Git and the compile stay with the person who started setup. This file points |
| Actor / role / subject / approver | this residual | Considered — no dest approver and no approval subject |
| Dest fence conditions | this residual | Considered — no dest fence conditions |
| User bashrc PATH marker | not a dedicated requirement yet | Current behavior is `tn5250_install_cli` in `src/tn5250-cli`. This change does not open that topic |
| Unix curses build on Debian | `docs/requirements/requirement-debian.md` | In scope for Debian. The Windows requirement still excludes it |
| Unix curses build on Ubuntu | `docs/requirements/requirement-ubuntu.md` | In scope for Ubuntu 22.04, 24.04, and 26.04. The branch is in the ship unit. This file points |
| Unix curses build on other Linux | `docs/requirements/requirement-other-linux.md` | In scope when Debian and Ubuntu do not claim the host. The branch is in the ship unit. This file points |
| Autotools `./configure` | none of the platform requirements | The supported builds are CMake |

The class file points. It does not restate the peer.

```text
Windows compilation, link, and build: owned by requirement-windows-git-bash. This class file points.
Debian compilation, link, and build: owned by requirement-debian. This class file points.
Ubuntu compilation, link, and build: owned by requirement-ubuntu. This class file points.
Other Linux compilation, link, and build: owned by requirement-other-linux. This class file points.
POSIX /bin/sh writing style: owned by requirement-shell-script-coding. This class file points.
Domain setup and host launch: owned by requirement-domain-tn5250. This class file points.
```

## 3. Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): the project nature and the stack owners are written down.
- **CIAO Principle 5 – SSOT**: residual facts stay here until a peer takes them.
- **CIAO Principle 1 – Caution**: the compiler is not invented in this file.
- **CIAO Principle 21 / dual policies**: core rules stay portable; Implementation Notes hold this product.

## 4. Design Principles (CIAO / CIAO-Lite)

- **Caution**: toolchain and package facts are missing until a peer or this residual declares them.
- **Intentional**: the residual list is the topics this change actually has.
- **Anti-fragile**: a later toolchain requirement can take ownership without rewriting the nature.
- **Over-protect**: one class file, one coding-style home, one owner per platform build.

## 5. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Create a second Active class file for this folder.
- Paste the CMake invocation, the link libraries, or the writing-style body into this residual.
- Invent an approver, a dest fence, or an origin URL. The sudo allow table lives on `docs/requirements/requirement-shell-sudo-command.md`. This file does not invent one.
- Record a session Unix login or a `/home/<login>/…` path.
- Treat a coding lesson from outside this product as law while the coding-style requirement is the home for that choice.
- Leave Implementation Notes as unfinished blanks while Status is Active.

## 6. Acceptance criteria

| ID | Criterion | This specialization |
|----|-----------|---------------------|
| AC-1 | Active class file matches software development | Met by this file |
| AC-2 | Language, toolchain policy, and package tool declared | Met: POSIX `/bin/sh` plus a pointer for the C toolchain |
| AC-3 | Residual table matches the peers | Met in the same change |
| AC-4 | Core rules have no frozen brand as universal law | Met |
| AC-5 | No server-maintenance class file | Met |
| AC-6 | Actor consider recorded | Residual: no dest approver and no approval subject |
| AC-7 | Dest fence review recorded | Residual: no dest fence conditions |
| AC-8 | Coding-style requirement Active and pointed | Met: `requirement-shell-script-coding` |

## 7. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-script-coding.md` | Coding-style home (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-windows-git-bash.md` | Windows compilation, link, and build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-debian.md` | Debian compilation, link, and build (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu compilation, link, and build (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux compilation, link, and build (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-domain-tn5250.md` | Domain setup and host launch (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv (RQ-SHELL-CLI-ZERO-ARGUMENTS) |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (RQ-SHELL-SELF-MANAGEMENT) |
| `src/tn5250-cli` | Ship unit |
| `docs/reviews/test-plan.md` | Todo proof rows |

## Terminologies

### Project nature

**Definition:** Project nature is the everyday name for the top-level classification of a workspace. That classification selects which specialization law applies. Everyday talk uses project nature. The class-law basename keeps the internal word.

**Human daily-life explanation:** Project nature is the kitchen-table name for which kind of work this folder is.

**Daily-life example:** Asking “is this a bakery, a law office, or an empty spare room?” is asking the project nature.

### Software-development project

**Definition:** A software-development project is the kind of workspace whose primary deliverable is shippable software. It keeps shared workshop knowledge and adds this product’s law, proof, and user surface when those are claimed. It must consider actor, role, subject, and approver even when the approver is none. It must review dest fence conditions and give each real fence its own requirement, or record that none exist. It must have a coding-style requirement. Without that file, portable learned lessons arrive raw. It is not a server-maintenance allowlist and not an empty seed.

**Human daily-life explanation:** A software-development project is a house whose job is to make a thing people can run or install. It keeps the shared workshop, then adds this product’s rules, tests, and front-door sign.

**Daily-life example:** You are writing a kitchen timer people can download. That is this kind of work. Rewriting only the building’s allowed-chore list is a different kind of work.

### Coding-style requirement

**Definition:** A coding-style requirement is the software-development specialize-in home for portable learned lessons about how the ship unit is written. Every software-development project must have an Active language-matched coding-style requirement. Without that file, agents bring portable learned lessons raw and treat them as this product’s law. The coding-style requirement is where those lessons are adopted, pointed at a peer, or refused.

**Human daily-life explanation:** A coding-style requirement is this product’s adopted writing-style home. Every software-development project must have one. Without it, helpers would treat portable lessons as this product’s law raw.

**Daily-life example:** A newsroom keeps one style sheet (“we write dates this way”). That adopted sheet is the coding-style requirement. The industry handbook on the shelf is not house law until the sheet says so.

## 8. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Class law for tn5250-cli. Windows compile, link, and build point at RQ-WINDOWS-GIT-BASH. Writing style points at RQ-SHELL-SCRIPT-CODING. No approver, no dest fence, no in-tool sudo, no git origin. |
| 2026-10-07 | Active 1.1.0 | Debian 12 and 13 compile, link, and build point at RQ-DEBIAN. |
| 2026-10-07 | Active 1.2.0 | Ship unit language is POSIX `/bin/sh`. Residual points at the Type 0 files and at RQ-DOMAIN-TN5250. No approver. No dest fence. Platform builds stay on their owners. |
| 2026-10-07 | Active 1.3.0 | Ubuntu points at RQ-UBUNTU. Other Linux points at RQ-OTHER-LINUX. This file still does not restate the CMake invocation. |
| 2026-10-07 | Active 1.4.0 | In-tool sudo points at RQ-SHELL-SUDO-COMMAND. This file does not restate the package list or the allow table. The Ubuntu and other-Linux branches are in the ship unit. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
