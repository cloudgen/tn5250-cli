**file**: docs/requirements/requirement-ubuntu.md
**ID**: RQ-UBUNTU
**Status**: Active (Version 1.3.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the standalone requirement for the Ubuntu situation. It owns Ubuntu detection and the compilation, link, and build of the Unix TN5250 programs on the Ubuntu LTS releases that are in standard support.

A person on one of those releases runs `tn5250-cli setup`. The supported result is the curses terminal client, compiled as C with CMake, linked against ncurses and OpenSSL. The Windows GUI build, MSYS2, and the autotools path are not this build.

`docs/requirements/requirement-debian.md` remains the owner of Debian 12 and 13. `docs/requirements/requirement-other-linux.md` remains the owner of other Linux. `docs/requirements/requirement-windows-git-bash.md` remains the owner of the Git Bash situation. `docs/requirements/requirement-shell-cli-interface.md` names the commands and points here when the machine is one of these Ubuntu releases.

### 1.1 Human-facing

**In one sentence:** A person on Ubuntu 22.04, 24.04, or 26.04 runs `tn5250-cli setup`, and the installer compiles and links the IBM i 5250 terminal with the system CMake, ncurses, and OpenSSL.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege, on Ubuntu | `tn5250-cli setup` |
| The other role | The upstream TN5250 project, which owns the C sources and the curses screen | `tn5250 HOST` runs in the current terminal |
| Not this file | Debian 12 and 13, other Linux, the Windows UCRT64 build, and the short command map | `docs/requirements/requirement-debian.md` |

| Includes | Excludes |
|----------|----------|
| Ubuntu 22.04, 24.04, and 26.04 detection, the C compilation, the ncurses and OpenSSL link, and the build of the curses client | The Windows GUI programs, MSYS2, autotools, sudo of git or the compile, and a text-screen menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the installer | the live setup |
| `tn5250-cli setup` | the build command | compile, link, and build |
| `tn5250 HOST` | the built curses program | a 5250 session in this terminal |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client on Ubuntu | The installer fetches the pinned sources, configures CMake for Release against the system libraries, compiles, links ncurses and OpenSSL, and copies the Unix programs into the prefix | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.0 Situation

1. This requirement is the only owner of the Ubuntu build situation. The Debian build stays on the Debian requirement. Other Linux stays on the other-Linux requirement. The Windows compiler, the Windows link, and the Windows build steps stay on the Git Bash requirement.
2. The supported hosts for setup and launch are the Ubuntu LTS releases in standard support on 2026-10-07, detected from `/etc/os-release`: Ubuntu 22.04 (jammy), Ubuntu 24.04 (noble), and Ubuntu 26.04 (resolute). The person has normal user privilege. `version` prints on any host. Its CLI line is owned by `docs/requirements/requirement-shell-cli-interface.md`.
3. The supported payload build is the upstream Unix CMake build at the same pinned ref the Debian situation uses: language C, CMake 3.12 or newer, the Ubuntu `gcc` metapackage, ncurses, OpenSSL 3, a single-config Release build.
4. Support means this installer builds the pinned upstream sources. It does not mean `apt install tn5250`.

### 2.1 Detection

5. `setup` (except `setup -h` and `setup --help`) and launch **MUST** accept Ubuntu when `/etc/os-release` has `ID=ubuntu` and one of these pairs: `VERSION_ID=22.04` with `VERSION_CODENAME=jammy`, `VERSION_ID=24.04` with `VERSION_CODENAME=noble`, or `VERSION_ID=26.04` with `VERSION_CODENAME=resolute`. `version` is not this detect.
6. A mismatch **MUST** stop setup and launch. A mismatch is `ID=ubuntu` together with a supported `VERSION_ID` whose `VERSION_CODENAME` is not the pair above, or a supported `VERSION_CODENAME` whose `VERSION_ID` is not the pair above. That host **MUST NOT** fall through to the other-Linux situation.
7. An Ubuntu release outside those three pairs, including 20.04 and the interim releases, is not this situation. Other Linux may own it. A derivative whose `ID` is not `ubuntu` is not this situation, even when `ID_LIKE` contains `ubuntu`. Debian, Git Bash, and Windows are not this situation.
8. A host that matches no platform requirement **MUST** get a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, and other Linux. A mismatch under rule 6 uses that same non-zero stop.
9. `help` and `setup --help` **MUST** be allowed to print usage without the Ubuntu check.
10. The build **MUST** be native for the architecture of that Ubuntu install. Cross-compilation is out of scope.

### 2.2 Supported compilation

11. The payload **MUST** be compiled as C through CMake. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`.
12. CMake **MUST** be at least 3.12. The Ubuntu packages that meet this are cmake 3.22.1 on jammy, cmake 3.28.3 on noble, and cmake 4.2.3 on resolute.
13. The compiler **MUST** be the native `gcc` metapackage: GCC 11 on jammy, GCC 13 on noble, GCC 15 on resolute, with `libc6-dev` present so the headers exist.
14. The generator **MUST** be Ninja when the `ninja` binary from the `ninja-build` package is on `PATH`. Otherwise the generator **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, setup **MUST** stop.
15. Release is selected at configure time. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass a multi-config `--config` switch.
16. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
17. Configure **MUST NOT** pass a Windows `CMAKE_PREFIX_PATH`, **MUST NOT** call `cygpath`, and **MUST NOT** set `MSYS_NO_PATHCONV`. System include and library paths are the Ubuntu defaults.
18. Setup **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. Setup **MUST NOT** build the `win32/` programs (`tn5250.exe`, `lp5250d.exe`, `dftmap.exe`).
19. Setup **MUST NOT** apply the Windows GCC 14 source fixes. Those edits change Windows API types (`u_long`, `INT_PTR`, `GetDefaultPrinter`). `sslstream.c` **MUST** still have `int ioctlarg`. Setup **MUST** apply the connect fix to `lib5250/telnetstr.c` and `lib5250/sslstream.c` before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `git rev-parse HEAD` stays the upstream commit. The fix is not a second commit.

### 2.3 Supported link

20. The protocol code **MUST** be the static library whose CMake target name is `5250`.
21. On Ubuntu that library **MUST NOT** link `Ws2_32` or `Winmm`. Upstream adds those libraries only for `WIN32`.
22. The supported link **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. `libssl-dev` (OpenSSL 3) is installed on the system, so `find_package(OpenSSL)` succeeds without a private prefix. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
23. Upstream `find_package(OpenSSL)` is not `REQUIRED`. The supported Ubuntu setup still requires `libssl-dev` to be present before configure, so the find succeeds. A configure without OpenSSL headers is not the supported link and **MUST** stop.
24. The curses client **MUST** be built. Upstream sets `CURSES_NEED_NCURSES` and calls `find_package(Curses REQUIRED)` when not `WIN32`. Missing ncurses **MUST** fail configure.
25. The curses executable target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c`, and **MUST** link `5250` and `${CURSES_LIBRARIES}`. It is a terminal program, not a `WIN32` GUI executable.
26. `libncurses-dev` **MUST** be the ncurses development package. It supplies the headers and the link to ncurses and tinfo. `pkg-config` **MUST** run so CMake can discover those libraries.
27. Ubuntu provides `syslog.h`. Upstream builds `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` when that header exists, and each links `5250`. The supported build **MUST** produce those four programs as well as `tn5250`.
28. `xt5250` is an autotools script (`xt5250.in`). This CMake build does not produce it. A missing `xt5250` is not a failed Ubuntu build.

### 2.4 Supported build

29. Setup **MUST** obtain sources for the pinned ref before compile, with the same shallow fetch the Git Bash requirement uses. `git` **MUST** be present or setup stops.
30. The build tree **MUST** live in the user cache. A rebuild **MUST** remove that build directory before configure.
31. After a successful compile, setup **MUST** copy `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` from the build tree into `${PREFIX}/opt/tn5250`, skipping anything under a `CMakeFiles` directory. The names have no `.exe` suffix.
32. If `tn5250` is missing after the build, setup **MUST** stop with a non-zero status.
33. Setup **MUST** write the requested ref, the checkout’s `HEAD` revision, and `CONNECT-FIX` next to the programs. `CONNECT-FIX` contains `addrinfo-1`. When `--force` is off, setup **MUST** skip the compile only if the programs are present and `REF`, `REVISION`, and `CONNECT-FIX` all match. A payload without `CONNECT-FIX` **MUST** rebuild.
34. Setup **MUST NOT** copy Windows runtime DLLs and **MUST NOT** vendor `libncurses` or `libssl` into the prefix. Those shared libraries come from the Ubuntu packages already installed (`libncurses6`, and `libssl3` on jammy or `libssl3t64` on noble and resolute).
35. The default prefix **MUST** be `${HOME}/.local`, overridable by `--prefix` or `TN5250_PREFIX`. The prefix **MUST NOT** be empty. Setup **MUST NOT** install into `/usr` or `/etc`.
36. Setup **MUST** copy the installer to `${PREFIX}/bin/tn5250-cli` when that destination is not already the same file, and **MUST** mark it executable. The installer name stays `tn5250-cli` so it does not shadow the curses `tn5250`.
37. Launch **MUST** execute `${PREFIX}/opt/tn5250/tn5250` with the remaining arguments. It **MUST NOT** set `MSYS_NO_PATHCONV` and **MUST NOT** append `.exe`.
38. `ncurses-base` **MUST** be present so the curses client has terminfo. When it is missing, setup installs it with the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`.

### 2.5 Packages and privilege

39. Before configure, these Ubuntu packages **MUST** be present. Setup **MUST** check for the tools and headers they provide. A missing package **MUST** be installed with the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, setup **MUST NOT** call sudo.

| Package | What setup checks |
|---------|-------------------|
| `gcc` | `gcc` runs |
| `libc6-dev` | C headers are usable by that `gcc` |
| `cmake` | `cmake` runs and reports at least 3.12 |
| `ninja-build` or `make` | `ninja` or `make` runs |
| the package that provides `pkg-config` | `pkg-config` runs |
| `libncurses-dev` | ncurses headers are found by CMake |
| `libssl-dev` | OpenSSL headers are found by CMake |
| `ncurses-base` | terminfo data is present for the runtime client |
| `git` | `git` runs |

40. The package install **MAY** use the in-tool sudo wrap. The setup command is the mixed elevated sudo model: the same verb for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. When that launch is root, git and the compile return to the person who started it. A root login with no such person stops before git. Git, cmake, make, ninja, and the copy of the built programs **MUST** stay with the person who started setup. Dedicated system user privilege stays unused. `apt install tn5250` is still not the supported install.
41. `--msys2-root` is a Windows toolchain flag. On Ubuntu, setup **MUST** reject it.

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
| Supported releases | Ubuntu 22.04 jammy (`VERSION_ID=22.04`), Ubuntu 24.04 noble (`VERSION_ID=24.04`), Ubuntu 26.04 resolute (`VERSION_ID=26.04`) |
| Payload names | `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` |
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Upstream files | root `CMakeLists.txt` (`find_package(Curses REQUIRED)` when not WIN32, then `curses/` and `lp5250d/`), `curses/CMakeLists.txt`, `lp5250d/CMakeLists.txt`, `lib5250/CMakeLists.txt`, `config-cmake.h.in` |
| Compiler packages | jammy: `gcc` 4:11.2.0-1ubuntu1 (GCC 11). noble: `gcc` 4:13.2.0-7ubuntu1, observed compiler 13.3.0. resolute: `gcc-15` 15.2.0-16ubuntu1 (GCC 15) |
| CMake packages | jammy: `cmake` 3.22.1-1ubuntu1.22.04.2. noble: `cmake` 3.28.3-1build7, observed on the authoring host. resolute: `cmake` 4.2.3-2ubuntu2 |
| ncurses | jammy: `libncurses-dev` 6.3-2ubuntu0.2. noble: `libncurses-dev` 6.4+20240113-1ubuntu2.2, observed on the authoring host. resolute: `libncurses-dev` 6.6+20251231-1 |
| OpenSSL | `libssl-dev`. jammy: 3.0.2-0ubuntu1.30, runtime `libssl3`. noble: 3.0.13-0ubuntu3.16, runtime `libssl3t64`, observed on the authoring host. resolute: OpenSSL 3.5.5, `libssl-dev` 3.5.5-1ubuntu3.7 in updates, runtime `libssl3t64` |
| `pkg-config` | noble: `pkgconf` and `pkg-config` 1.8.1-2build1, observed on the authoring host. Jammy and resolute were not observed as a running `pkg-config`. The check is that the command runs |
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

The POSIX ship unit routes Ubuntu 22.04 (jammy), 24.04 (noble), and 26.04 (resolute) to this build. On the authoring host, Ubuntu 24.04 (noble), `tn5250-cli setup` exited 0 on 2026-10-07. The log did not contain `Installing missing compiler packages`, so sudo was not called. The toolchain was already present. Git cloned tag `v0.18.0` and checked out commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63`. CMake configured with Ninja and `Release`, and identified the C compiler as GNU 13.3.0. OpenSSL 3.0.13 and ncurses were found. `syslog.h` was found. `5250` is the static archive `lib5250.a`. The curses `tn5250` link line is that archive, ncurses, libform, `libssl`, and `libcrypto`. `Ws2_32` and `Winmm` are absent. The build copied `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` under `${PREFIX}/opt/tn5250`, with the default prefix `${HOME}/.local`. Those files are owned by the user who started setup. The Windows GCC 14 patch was not applied: `sslstream.c` still has `int ioctlarg`, and the checkout is clean at that commit. `MSYS_NO_PATHCONV` was not set.

On 2026-10-07, `tn5250-cli setup` for version 1.0.2 exited 0 on the same host. The log did not contain `Installing missing compiler packages`. The connect fix applied. `HEAD` stayed `cd5980177b9468763bcaa669bf5cacbe7de5ec63`. `sslstream.c` still has `int ioctlarg`. `CONNECT-FIX` is `addrinfo-1`. A second setup printed `already installed` and did not run CMake. On a terminal, `menu` drew the numbered list. A host token that does not resolve printed `Could not start session:` and did not receive signal 11.

Noble package versions in the table above were read on that host. Jammy and resolute versions were read from Ubuntu’s package pages. The missing-package sudo path was not run. Jammy and resolute were not compiled here.

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): this situation accepts only the three Ubuntu LTS pairs, and it refuses a build that did not produce `tn5250`.
- **CIAO Principle 2 – Intentional**: the Ubuntu releases, the packages, the generator, and the link set are written down.
- **CIAO Principle 5 – SSOT**: Ubuntu compilation, link, and build have this file. Debian, other Linux, and Windows keep their own.
- **CIAO Principle 9**: admin privilege is used only to install missing compiler packages. Git and the compile stay with the person who started setup.
- **CIAO Principle 10 – Least privilege**: sudo runs only when a package is missing. The build is not written to `/usr`.
- **CIAO Principle 21 – Dual policies**: the rules stay portable. Ubuntu package versions sit in Implementation Notes.

## Under command line for normal user only

On Ubuntu the person runs setup as a normal user.

**This requirement:** missing Ubuntu compiler packages are installed with the sudo wrap. Git and the compile stay with the person who started setup. Dedicated system user privilege stays unused. Termux pkg is not called. This shell is not Git Bash and not Windows cmd. The curses client runs in the terminal the person already has.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a derivative that only says `ID_LIKE=ubuntu` is not treated as these three releases.
- **Intentional**: one Ubuntu file, one Unix CMake invocation, one link set.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain available. Jammy, noble, and resolute share the development package names. The runtime OpenSSL library is `libssl3` on jammy and `libssl3t64` on noble and resolute. The package-config check is that `pkg-config` runs.
- **Over-protect**: the Windows source patch and the Windows libraries stay off this build. The connect fix is the only Ubuntu edit to the upstream C sources.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this situation into the Debian requirement, the other-Linux requirement, the Git Bash requirement, the CLI-interface file, or the class residual.
- Build the Windows GUI programs, apply the Windows GCC 14 patch, or link `Ws2_32` and `Winmm` on Ubuntu.
- Drive this build through MSYS2, `cygpath`, `cmd.exe`, or `MSYS_NO_PATHCONV`.
- Replace this CMake build with `autogen.sh` and `./configure`.
- Run git, cmake, make, or the payload copy through sudo.
- Call sudo when the compiler packages are already present.
- Treat a derivative as Ubuntu 22.04, 24.04, or 26.04 because `ID_LIKE` contains `ubuntu`.
- Treat an identity mismatch as other Linux.
- Treat a missing curses `tn5250` as success.
- Claim `apt install tn5250` as the supported install.
- Drop `libssl-dev` or `libncurses-dev` from the supported link.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-debian.md` | Debian situation. Does not own this build (RQ-DEBIAN) |
| `docs/requirements/requirement-other-linux.md` | Other Linux situation. Does not own these three releases (RQ-OTHER-LINUX) |
| `docs/requirements/requirement-windows-git-bash.md` | Windows situation. Does not own this build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names. Points here on these Ubuntu releases (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style. Points here for the Ubuntu C build (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here (RQ-CLASS-SOFTWARE-DEV) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap that installs a missing Ubuntu compiler package (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Installer. The Ubuntu branch is in the ship unit (§2.8) |
| `docs/reviews/test-plan.md` | Todo proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

Rows marked ran were shown on the authoring host. Jammy, resolute, and the missing-package path were not run.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-UBU-01 | setup accepts Ubuntu 22.04, 24.04, and 26.04, and does not treat `ID_LIKE=ubuntu` as those releases | ran for 24.04 noble on the authoring host. 22.04, 26.04, and an `ID_LIKE`-only host were not executed |
| TP-UBU-02 | Configure is Ninja or Unix Makefiles, `Release`, with no Windows prefix and no `MSYS_NO_PATHCONV` | ran on the authoring host. Ninja and `Release`. `MSYS_NO_PATHCONV` was not set |
| TP-UBU-03 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | ran on the authoring host. `lib5250.a` plus `libssl` and `libcrypto` on the curses link line. `Ws2_32` and `Winmm` are absent |
| TP-UBU-04 | The curses `tn5250` links `5250` and ncurses. `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` are produced | ran on the authoring host. `ldd` shows `libncurses.so.6`. All five programs were copied |
| TP-UBU-05 | The Windows GCC 14 patch is not applied on Ubuntu | ran on the authoring host. `sslstream.c` still has `int ioctlarg`. The checkout is clean |
| TP-UBU-06 | A missing compiler package is installed with the sudo wrap. Git and the compile stay with the invoking person. A present toolchain does not call sudo | ran for the present toolchain on the authoring host. The log did not contain `Installing missing compiler packages`. The missing-package path was not run |
| TP-UBU-07 | A build that does not produce `tn5250` fails | todo |
| TP-UBU-08 | A `VERSION_ID` / `VERSION_CODENAME` mismatch stops setup and does not fall through to other Linux | todo |
| TP-CLI-01 | setup, help, version, and host launch are named here and in the CLI-interface requirement | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

Ubuntu itself can have an administrator. Setup borrows that role only for a missing compiler package. Git and the compile stay with the person.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`setup`, `help`, `version`, and the host launch are commands that run this product.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Standalone Ubuntu situation for 22.04 jammy, 24.04 noble, and 26.04 resolute. Supported compile is system GCC and CMake Release. Supported link is static `5250` plus OpenSSL and ncurses. Supported build copies the curses client and the four syslog programs. The ship unit does not implement the branch yet. |
| 2026-10-07 | Active 1.1.0 | Missing compiler packages are installed through RQ-SHELL-SUDO-COMMAND. Git and the compile stay with the invoking person. The Ubuntu branch is in the ship unit. |
| 2026-10-07 | Active 1.2.0 | The setup command must be started without sudo. A root setup stops before git and the compile. |
| 2026-10-07 | Active 1.3.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. |
| 2026-10-07 | Active 1.3.1 | The setup arrangement is named the mixed elevated sudo model. Help does not recommend a sudo prefix. |
| 2026-10-07 | Active 1.3.2 | The connect fix is applied before configure. A payload without `CONNECT-FIX` rebuilds. The Windows GCC 14 patch stays off. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
