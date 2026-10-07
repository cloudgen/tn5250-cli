**file**: docs/requirements/requirement-debian.md
**ID**: RQ-DEBIAN
**Status**: Active (Version 1.5.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the standalone requirement for the Debian situation. It owns Debian detection and the compilation, link, and build of the Unix TN5250 programs on Debian.

A person on Debian runs `tn5250-cli setup`. The supported result is the curses terminal client, compiled as C with CMake, linked against ncurses and OpenSSL. The Windows GUI build, MSYS2, and the autotools path are not this build.

`docs/requirements/requirement-windows-git-bash.md` remains the owner of the Git Bash situation. `docs/requirements/requirement-ubuntu.md` remains the owner of Ubuntu 22.04, 24.04, and 26.04. `docs/requirements/requirement-other-linux.md` remains the owner of other Linux. `docs/requirements/requirement-shell-cli-interface.md` names the commands and points here when the machine is Debian.

### 1.1 Human-facing

**In one sentence:** A person on Debian 12 or Debian 13 runs `tn5250-cli setup`, and the installer compiles and links the IBM i 5250 terminal with the system CMake, ncurses, and OpenSSL.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege, on Debian | `tn5250-cli setup` |
| The other role | The upstream TN5250 project, which owns the C sources and the curses screen | `tn5250 HOST` runs in the current terminal |
| Not this file | The Windows UCRT64 build, and the short command map | `docs/requirements/requirement-windows-git-bash.md` |

| Includes | Excludes |
|----------|----------|
| Debian 12 and 13 detection, the C compilation, the ncurses and OpenSSL link, and the build of the curses client | The Windows GUI programs, MSYS2, autotools, sudo of git or the compile, and a text-screen menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the installer | the live setup |
| `tn5250-cli setup` | the build command | compile, link, and build |
| `tn5250 HOST` | the built curses program | a 5250 session in this terminal |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client on Debian | The installer fetches the pinned sources, configures CMake for Release against the system libraries, compiles, links ncurses and OpenSSL, and copies the Unix programs into the prefix | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.0 Situation

1. This requirement is the only owner of the Debian build situation. The Ubuntu build stays on the Ubuntu requirement. Other Linux stays on the other-Linux requirement. The Windows compiler, the Windows link, and the Windows build steps stay on the Git Bash requirement.
2. The supported hosts for setup and launch are Debian 12 (bookworm) and Debian 13 (trixie), detected from `/etc/os-release`. The person has normal user privilege. `version` prints on any host. Its CLI line is owned by `docs/requirements/requirement-shell-cli-interface.md`.
3. The supported payload build is the upstream Unix CMake build at the same pinned ref the Windows situation uses: language C, CMake 3.12 or newer, the Debian `gcc` metapackage, ncurses, OpenSSL 3, a single-config Release build.
4. Debian does not publish a current `tn5250` binary package for these releases. Support means this installer builds the pinned upstream sources. It does not mean `apt install tn5250`.

### 2.1 Detection

5. `setup` (except `setup -h` and `setup --help`) and launch **MUST** accept Debian when `/etc/os-release` has `ID=debian` and `VERSION_ID` is `12` or `13`. `version` is not this detect.
6. `VERSION_CODENAME` **MUST** be `bookworm` for version 12 and `trixie` for version 13. A mismatch between `VERSION_ID` and `VERSION_CODENAME` **MUST** stop setup.
7. This situation accepts only the Debian pairs in rule 5. `ID_LIKE` containing `debian` does not make a host Debian. Ubuntu 22.04, 24.04, and 26.04 are owned by `docs/requirements/requirement-ubuntu.md`. Other Linux is owned by `docs/requirements/requirement-other-linux.md`. Git Bash remains owned by the Git Bash requirement. An identity mismatch under rule 6 stops setup and launch and does not fall through to other Linux.
8. A host that matches no platform requirement **MUST** get a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, and other Linux.
9. `help` and `setup --help` **MUST** be allowed to print usage without the Debian check.
10. The build **MUST** be native for the architecture of that Debian install. Cross-compilation is out of scope.

### 2.2 Supported compilation

11. The payload **MUST** be compiled as C through CMake. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`.
12. CMake **MUST** be at least 3.12. The Debian packages that meet this are cmake 3.25.1 on bookworm and cmake 3.31.6 on trixie.
13. The compiler **MUST** be the native `gcc` metapackage: GCC 12 on bookworm, GCC 14 on trixie, with `libc6-dev` present so the headers exist.
14. The generator **MUST** be Ninja when the `ninja` binary from the `ninja-build` package is on `PATH`. Otherwise the generator **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, setup **MUST** stop.
15. Release is selected at configure time. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass a multi-config `--config` switch.
16. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
17. Configure **MUST NOT** pass a Windows `CMAKE_PREFIX_PATH`, **MUST NOT** call `cygpath`, and **MUST NOT** set `MSYS_NO_PATHCONV`. System include and library paths are the Debian defaults.
18. Setup **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. Setup **MUST NOT** build the `win32/` programs (`tn5250.exe`, `lp5250d.exe`, `dftmap.exe`).
19. Setup **MUST NOT** apply the Windows GCC 14 source fixes. Those edits change Windows API types (`u_long`, `INT_PTR`, `GetDefaultPrinter`). On Debian the upstream C sources stay as tagged.

### 2.3 Supported link

20. The protocol code **MUST** be the static library whose CMake target name is `5250`.
21. On Debian that library **MUST NOT** link `Ws2_32` or `Winmm`. Upstream adds those libraries only for `WIN32`.
22. The supported link **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. `libssl-dev` (OpenSSL 3) is installed on the system, so `find_package(OpenSSL)` succeeds without a private prefix. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
23. Upstream `find_package(OpenSSL)` is not `REQUIRED`. The supported Debian setup still requires `libssl-dev` to be present before configure, so the find succeeds. A configure without OpenSSL headers is not the supported link and **MUST** stop.
24. The curses client **MUST** be built. Upstream sets `CURSES_NEED_NCURSES` and calls `find_package(Curses REQUIRED)` when not `WIN32`. Missing ncurses **MUST** fail configure.
25. The curses executable target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c`, and **MUST** link `5250` and `${CURSES_LIBRARIES}`. It is a terminal program, not a `WIN32` GUI executable.
26. `libncurses-dev` **MUST** be the ncurses development package (bookworm 6.4, trixie 6.5). It supplies the headers and the link to ncurses and tinfo. `pkgconf` **MUST** be present so CMake can discover those libraries.
27. Debian provides `syslog.h`. Upstream builds `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` when that header exists, and each links `5250`. The supported build **MUST** produce those four programs as well as `tn5250`.
28. `xt5250` is an autotools script (`xt5250.in`). This CMake build does not produce it. A missing `xt5250` is not a failed Debian build.

### 2.4 Supported build

29. Setup **MUST** obtain sources for the pinned ref before compile, with the same shallow fetch the Git Bash requirement uses. `git` **MUST** be present or setup stops.
30. The build tree **MUST** live in the user cache. A rebuild **MUST** remove that build directory before configure.
31. After a successful compile, setup **MUST** copy `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` from the build tree into `${PREFIX}/opt/tn5250`, skipping anything under a `CMakeFiles` directory. The names have no `.exe` suffix.
32. If `tn5250` is missing after the build, setup **MUST** stop with a non-zero status.
33. Setup **MUST** write the requested ref and the checkout’s `HEAD` revision next to the programs.
34. Setup **MUST NOT** copy Windows runtime DLLs and **MUST NOT** vendor `libncurses` or `libssl` into the prefix. Those shared libraries come from the Debian packages already installed (`libncurses6`, and `libssl3` on bookworm or `libssl3t64` on trixie).
35. The default prefix **MUST** be `${HOME}/.local`, overridable by `--prefix` or `TN5250_PREFIX`. The prefix **MUST NOT** be empty. Setup **MUST NOT** install into `/usr` or `/etc`.
36. Setup **MUST** copy the installer to `${PREFIX}/bin/tn5250-cli` when that destination is not already the same file, and **MUST** mark it executable. The installer name stays `tn5250-cli` so it does not shadow the curses `tn5250`.
37. Launch **MUST** execute `${PREFIX}/opt/tn5250/tn5250` with the remaining arguments. It **MUST NOT** set `MSYS_NO_PATHCONV` and **MUST NOT** append `.exe`.
38. `ncurses-base` **MUST** be present so the curses client has terminfo. When it is missing, setup installs it with the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`.

### 2.5 Packages and privilege

39. Before configure, these Debian packages **MUST** be present. Setup **MUST** check for the tools and headers they provide. A missing package **MUST** be installed with the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, setup **MUST NOT** call sudo.

| Package | What setup checks |
|---------|-------------------|
| `gcc` | `gcc` runs |
| `libc6-dev` | C headers are usable by that `gcc` |
| `cmake` | `cmake` runs and reports at least 3.12 |
| `ninja-build` or `make` | `ninja` or `make` runs |
| `pkgconf` | `pkg-config` runs |
| `libncurses-dev` | ncurses headers are found by CMake |
| `libssl-dev` | OpenSSL headers are found by CMake |
| `ncurses-base` | terminfo data is present for the runtime client |
| `git` | `git` runs |

40. The package install **MAY** use the in-tool sudo wrap. The setup command is the mixed elevated sudo model: the same verb for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. When that launch is root, git and the compile return to the person who started it. A root login with no such person stops before git. Git, cmake, make, ninja, and the copy of the built programs **MUST** stay with the person who started setup. Dedicated system user privilege stays unused. `apt install tn5250` is still not the supported install.
41. `--msys2-root` is a Windows toolchain flag. On Debian, setup **MUST** reject it.

### 2.6 Commands this file also names

```bash
tn5250-cli setup
tn5250-cli setup --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli setup --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. It does not compile. `tn5250-cli setup --help` shows help and does not compile. The CLI version line is owned by `docs/requirements/requirement-shell-cli-interface.md`. When this build has written `REF` and `REVISION`, the extra payload line is `tn5250 <ref> (<revision>)`.

### 2.7 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Installer | `tn5250-cli`, ship unit `src/tn5250-cli` |
| Supported releases | Debian 12 bookworm (`VERSION_ID=12`) and Debian 13 trixie (`VERSION_ID=13`) |
| Payload names | `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` |
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Upstream files | root `CMakeLists.txt` (`find_package(Curses REQUIRED)` when not WIN32, then `curses/` and `lp5250d/`), `curses/CMakeLists.txt`, `lp5250d/CMakeLists.txt`, `lib5250/CMakeLists.txt`, `config-cmake.h.in` |
| Compiler packages | bookworm: `gcc` 4:12.2.0-3 (GCC 12). trixie: `gcc` metapackage tracking GCC 14 |
| CMake packages | bookworm: `cmake` 3.25.1-1. trixie: `cmake` 3.31.6-2 |
| ncurses | bookworm: `libncurses-dev` 6.4-4. trixie: `libncurses-dev` 6.5+20250216-2 |
| OpenSSL | `libssl-dev`, OpenSSL 3. Runtime library `libssl3` on bookworm and `libssl3t64` on trixie |
| Application directory | `${PREFIX}/opt/tn5250` |
| Source cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` |
| Build cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` |

**Supported CMake invocation**

```text
cmake -G Ninja -S <src> -B <build> -DCMAKE_BUILD_TYPE=Release
cmake --build <build> --parallel <jobs>
```

When `ninja` is absent and `make` is present, `-G Ninja` is replaced by `-G "Unix Makefiles"`.

**Supported link, from the upstream CMake at the pinned tag**

| Target | Kind | Link line |
|--------|------|-----------|
| `5250` | static library from the lib5250 sources, including `sslstream.c` and `telnetstr.c` | `OpenSSL::Crypto` and `OpenSSL::SSL` when `OPENSSL_FOUND`. No `Ws2_32`. No `Winmm` |
| `tn5250` | `add_executable(tn5250 cursesterm.c tn5250.c)` | `5250` and `${CURSES_LIBRARIES}` |
| `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` | executables, built because `syslog.h` exists | `5250` |

`config-cmake.h.in` maps `#cmakedefine OPENSSL_FOUND` to `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.

### 2.8 Current script behavior

The POSIX ship unit routes Debian 12 (bookworm) and Debian 13 (trixie) to the Debian build. That branch reads `/etc/os-release`, checks the tools and headers named in this file, and configures CMake as specified above. It does not apply the Windows GCC 14 patch. When a compiler package is missing, setup installs it through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, setup does not call sudo. Git and the compile stay with the person who started setup.

The authoring host for this change is Ubuntu 24.04 (noble). That host is the Ubuntu situation, so this Debian compile, link, and build were not executed here. The Ubuntu requirement records the setup command that was run on that host.

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): this situation accepts only Debian 12 and 13, and it refuses a build that did not produce `tn5250`.
- **CIAO Principle 2 – Intentional**: the Debian releases, the packages, the generator, and the link set are written down.
- **CIAO Principle 5 – SSOT**: Debian compilation, link, and build have this file. Windows keeps its own.
- **CIAO Principle 9**: admin privilege is used only to install missing compiler packages. Git and the compile stay with the person who started setup.
- **CIAO Principle 10 – Least privilege**: sudo runs only when a package is missing. The build is not written to `/usr`.
- **CIAO Principle 21 – Dual policies**: the rules stay portable. Debian package versions sit in Implementation Notes.

## Under command line for normal user only

On Debian the person runs setup as a normal user.

**This requirement:** missing Debian compiler packages are installed with the sudo wrap. Git and the compile stay with the person who started setup. Dedicated system user privilege stays unused. Termux pkg is not called. This shell is not Git Bash and not Windows cmd. The curses client runs in the terminal the person already has.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a derivative that only says `ID_LIKE=debian` is not treated as Debian.
- **Intentional**: one Debian file, one Unix CMake invocation, one link set.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain available. Bookworm and trixie share the package names.
- **Over-protect**: the Windows source patch and the Windows libraries stay off this build.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this situation into the Git Bash requirement, the CLI-interface file, or the class residual.
- Build the Windows GUI programs, apply the Windows GCC 14 patch, or link `Ws2_32` and `Winmm` on Debian.
- Drive this build through MSYS2, `cygpath`, `cmd.exe`, or `MSYS_NO_PATHCONV`.
- Replace this CMake build with `autogen.sh` and `./configure`.
- Run git, cmake, make, or the payload copy through sudo.
- Call sudo when the compiler packages are already present.
- Treat Ubuntu as Debian because `ID_LIKE` contains `debian`.
- Treat a missing curses `tn5250` as success.
- Claim `apt install tn5250` as the supported install. These Debian releases do not ship this upstream version.
- Drop `libssl-dev` or `libncurses-dev` from the supported link.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-windows-git-bash.md` | Windows situation. Does not own this build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu situation. Does not own this build (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux situation. Does not own this build (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names. Points here on Debian (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style. Points here for the Debian C build (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here (RQ-CLASS-SOFTWARE-DEV) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap that installs a missing Debian compiler package (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Installer. Debian branch is in the POSIX ship unit. Compile was not run on the authoring host (§2.8) |
| `docs/reviews/test-plan.md` | Todo proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

These rows are not claimed as run.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-DEB-01 | setup accepts Debian 12 and Debian 13. A non-Debian `ID` is not this situation | todo |
| TP-DEB-02 | Configure is Ninja or Unix Makefiles, `Release`, with no Windows prefix and no `MSYS_NO_PATHCONV` | todo |
| TP-DEB-03 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-DEB-04 | The curses `tn5250` links `5250` and ncurses. `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` are produced | todo |
| TP-DEB-05 | The Windows GCC 14 patch is not applied on Debian | todo |
| TP-DEB-06 | A missing compiler package is installed with the sudo wrap. Git and the compile stay with the invoking person. A present toolchain does not call sudo | todo |
| TP-DEB-07 | A build that does not produce `tn5250` fails | todo |
| TP-CLI-01 | setup, help, version, and host launch are named here and in the CLI-interface requirement | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

Debian itself can have an administrator. Setup borrows that role only for a missing compiler package. Git and the compile stay with the person.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`setup`, `help`, `version`, and the host launch are commands that run this product.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Standalone Debian situation for Debian 12 and 13. Supported compile is system GCC and CMake Release. Supported link is static `5250` plus OpenSSL and ncurses. Supported build copies the curses client and the four syslog programs. Script does not implement the branch yet. |
| 2026-10-07 | Active 1.1.0 | The Debian branch is in the POSIX ship unit. The authoring host is Ubuntu 24.04, so the Debian compile was not run. Version is not the Debian detect. Compile, link, and build law is unchanged. |
| 2026-10-07 | Active 1.2.0 | Ubuntu LTS points at RQ-UBUNTU. Other Linux points at RQ-OTHER-LINUX. This situation still accepts only Debian 12 and 13. An identity mismatch does not fall through. |
| 2026-10-07 | Active 1.3.0 | Missing compiler packages are installed through RQ-SHELL-SUDO-COMMAND. Git and the compile stay with the invoking person. |
| 2026-10-07 | Active 1.4.0 | The setup command must be started without sudo. A root setup stops before git and the compile. |
| 2026-10-07 | Active 1.5.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. |
| 2026-10-07 | Active 1.5.1 | The setup arrangement is named the mixed elevated sudo model. Help does not recommend a sudo prefix. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
