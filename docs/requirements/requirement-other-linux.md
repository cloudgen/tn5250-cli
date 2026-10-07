**file**: docs/requirements/requirement-other-linux.md
**ID**: RQ-OTHER-LINUX
**Status**: Active (Version 1.3.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the standalone requirement for Linux hosts that are not the Debian situation and not the Ubuntu situation. It owns that detection and the compilation, link, and build of the Unix TN5250 programs on those hosts.

A person on such a Linux system runs `tn5250-cli setup`. The supported result is the curses terminal client, compiled as C with CMake, linked against ncurses and OpenSSL. The Windows GUI build, MSYS2, and the autotools path are not this build.

`docs/requirements/requirement-debian.md` remains the owner of Debian 12 and 13. `docs/requirements/requirement-ubuntu.md` remains the owner of Ubuntu 22.04, 24.04, and 26.04. `docs/requirements/requirement-windows-git-bash.md` remains the owner of the Git Bash situation. `docs/requirements/requirement-shell-cli-interface.md` names the commands and points here when the machine is this other Linux.

### 1.1 Human-facing

**In one sentence:** A person on another Linux system runs `tn5250-cli setup`, and the installer compiles and links the IBM i 5250 terminal with the system CMake, ncurses, and OpenSSL.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege, on Linux that is not Debian 12 or 13 and not Ubuntu 22.04, 24.04, or 26.04 | `tn5250-cli setup` |
| The other role | The upstream TN5250 project, which owns the C sources and the curses screen | `tn5250 HOST` runs in the current terminal |
| Not this file | Debian 12 and 13, those three Ubuntu releases, and the Windows UCRT64 build | `docs/requirements/requirement-debian.md` |

| Includes | Excludes |
|----------|----------|
| Detection of other Linux, the C compilation, the ncurses and OpenSSL link, and the build of the curses client | The Windows GUI programs, MSYS2, autotools, sudo of git or the compile, Termux, and a text-screen menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the installer | the live setup |
| `tn5250-cli setup` | the build command | compile, link, and build |
| `tn5250 HOST` | the built curses program | a 5250 session in this terminal |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client on this Linux | The installer fetches the pinned sources, configures CMake for Release against the system libraries, compiles, links ncurses and OpenSSL, and copies the Unix programs into the prefix | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.0 Situation

1. This requirement is the only owner of the other-Linux build situation. Debian 12 and 13 stay on the Debian requirement. Ubuntu 22.04, 24.04, and 26.04 stay on the Ubuntu requirement. The Windows compiler, the Windows link, and the Windows build steps stay on the Git Bash requirement.
2. The supported host for setup and launch is Linux, as `uname -s` reports `Linux`, when the host is not a Debian pair, not an Ubuntu pair, and not Termux. The person has normal user privilege. `version` prints on any host. Its CLI line is owned by `docs/requirements/requirement-shell-cli-interface.md`.
3. The supported payload build is the upstream Unix CMake build at the same pinned ref the Debian situation uses: language C, CMake 3.12 or newer, the system `gcc`, ncurses, OpenSSL, a single-config Release build.
4. Support means this installer builds the pinned upstream sources. It does not mean a distribution package named `tn5250`.

### 2.1 Detection

5. `setup` (except `setup -h` and `setup --help`) and launch **MUST** accept the host when `uname -s` is `Linux`, the Debian requirement does not claim the host, the Ubuntu requirement does not claim the host, and Termux is not detected. `version` is not this detect.
6. Termux **MUST** be refused. Termux is detected when `TERMUX_VERSION` is set. A refused Termux setup or launch **MUST** exit non-zero. This situation **MUST NOT** invoke Termux `pkg`.
7. This situation **MUST NOT** accept a Debian or Ubuntu identity mismatch. When the Debian requirement or the Ubuntu requirement says the `VERSION_ID` and `VERSION_CODENAME` pair is inconsistent, setup stops there. This situation **MUST NOT** build that host.
8. An Ubuntu release outside 22.04, 24.04, and 26.04, and a Debian release outside 12 and 13, are this situation when `uname -s` is `Linux` and rules 6 and 7 do not stop them. A derivative whose `ID` is not `debian` and not `ubuntu` is this situation on the same conditions. `ID_LIKE` does not by itself select Debian or Ubuntu.
9. macOS, the BSDs, Git Bash, and Windows **MUST** be refused by this situation. A host that matches no platform requirement **MUST** get a non-zero status and a message that names Git Bash on Windows, Debian 12 or 13, Ubuntu 22.04, 24.04, or 26.04, and other Linux.
10. `help` and `setup --help` **MUST** be allowed to print usage without this check.
11. The build **MUST** be native for the architecture of that Linux install. Cross-compilation is out of scope.

### 2.2 Supported compilation

12. The payload **MUST** be compiled as C through CMake. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`.
13. CMake **MUST** be at least 3.12. The distribution’s package name is not a detect key. The check is that `cmake` runs and reports at least 3.12.
14. The compiler **MUST** be the native `gcc` on `PATH`, with C headers usable by that `gcc`.
15. The generator **MUST** be Ninja when `ninja` is on `PATH`. Otherwise the generator **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, setup **MUST** stop.
16. Release is selected at configure time. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass a multi-config `--config` switch.
17. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
18. Configure **MUST NOT** pass a Windows `CMAKE_PREFIX_PATH`, **MUST NOT** call `cygpath`, and **MUST NOT** set `MSYS_NO_PATHCONV`. System include and library paths are the distribution defaults.
19. Setup **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. Setup **MUST NOT** build the `win32/` programs (`tn5250.exe`, `lp5250d.exe`, `dftmap.exe`).
20. Setup **MUST NOT** apply the Windows GCC 14 source fixes. `sslstream.c` **MUST** still have `int ioctlarg`. Setup **MUST** apply the connect fix to `lib5250/telnetstr.c` and `lib5250/sslstream.c` before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `git rev-parse HEAD` stays the upstream commit. The fix is not a second commit.

### 2.3 Supported link

21. The protocol code **MUST** be the static library whose CMake target name is `5250`.
22. On this Linux that library **MUST NOT** link `Ws2_32` or `Winmm`. Upstream adds those libraries only for `WIN32`.
23. The supported link **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. OpenSSL headers are installed on the system, so `find_package(OpenSSL)` succeeds without a private prefix. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
24. Upstream `find_package(OpenSSL)` is not `REQUIRED`. The supported setup still requires the OpenSSL headers to be present before configure, so the find succeeds. A configure without OpenSSL headers is not the supported link and **MUST** stop.
25. The curses client **MUST** be built. Upstream sets `CURSES_NEED_NCURSES` and calls `find_package(Curses REQUIRED)` when not `WIN32`. Missing ncurses **MUST** fail configure.
26. The curses executable target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c`, and **MUST** link `5250` and `${CURSES_LIBRARIES}`. It is a terminal program, not a `WIN32` GUI executable.
27. `pkg-config` **MUST** run so CMake can discover ncurses. The distribution package that provides that command is not a detect key.
28. When `syslog.h` is present, upstream builds `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps`, and each links `5250`. The supported build **MUST** then produce those four programs as well as `tn5250`. When `syslog.h` is absent, a missing one of those four programs is not a failed build.
29. `xt5250` is an autotools script (`xt5250.in`). This CMake build does not produce it. A missing `xt5250` is not a failed build.

### 2.4 Supported build

30. Setup **MUST** obtain sources for the pinned ref before compile, with the same shallow fetch the Git Bash requirement uses. `git` **MUST** be present or setup stops.
31. The build tree **MUST** live in the user cache. A rebuild **MUST** remove that build directory before configure.
32. After a successful compile, setup **MUST** copy `tn5250` from the build tree into `${PREFIX}/opt/tn5250`, and **MUST** copy `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` when those programs were produced, skipping anything under a `CMakeFiles` directory. The names have no `.exe` suffix.
33. If `tn5250` is missing after the build, setup **MUST** stop with a non-zero status.
34. Setup **MUST** write the requested ref, the checkout’s `HEAD` revision, and `CONNECT-FIX` next to the programs. `CONNECT-FIX` contains `addrinfo-1`. When `--force` is off, setup **MUST** skip the compile only if the programs are present and `REF`, `REVISION`, and `CONNECT-FIX` all match. A payload without `CONNECT-FIX` **MUST** rebuild.
35. Setup **MUST NOT** copy Windows runtime DLLs and **MUST NOT** vendor `libncurses` or `libssl` into the prefix. Those shared libraries come from the distribution already installed.
36. The default prefix **MUST** be `${HOME}/.local`, overridable by `--prefix` or `TN5250_PREFIX`. The prefix **MUST NOT** be empty. Setup **MUST NOT** install into `/usr` or `/etc`.
37. Setup **MUST** copy the installer to `${PREFIX}/bin/tn5250-cli` when that destination is not already the same file, and **MUST** mark it executable. The installer name stays `tn5250-cli` so it does not shadow the curses `tn5250`.
38. Launch **MUST** execute `${PREFIX}/opt/tn5250/tn5250` with the remaining arguments. It **MUST NOT** set `MSYS_NO_PATHCONV` and **MUST NOT** append `.exe`.
39. Terminfo data **MUST** be present so the curses client can run. When it is missing, setup installs the package that provides it through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`, when that family is known. A family this file does not name **MUST** stop setup with a message that names terminfo.

### 2.5 Tools and privilege

40. Before configure, these tools and headers **MUST** be present. Setup **MUST** check the tool or the header. A missing one **MUST** be installed with the package manager on this host, through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, setup **MUST NOT** call sudo. The message for an unknown package manager **MUST NOT** pretend that one distribution’s package name is the only name.

| What is present | What setup checks |
|-----------------|-------------------|
| A C compiler | `gcc` runs |
| C headers | C headers are usable by that `gcc` |
| CMake | `cmake` runs and reports at least 3.12 |
| A generator | `ninja` or `make` runs |
| Package config | `pkg-config` runs |
| ncurses headers | ncurses headers are found by CMake |
| OpenSSL headers | OpenSSL headers are found by CMake |
| Terminfo | terminfo data is present for the runtime client |
| Git | `git` runs |
| `syslog.h` | when the header exists, the four syslog programs are required |

41. The package install **MAY** use the in-tool sudo wrap with `apt-get`, `apk`, `dnf`, `pacman`, or `zypper`, and only for the missing tools. The setup command is the mixed elevated sudo model: the same verb for a normal user and for a sudo launch. Help does not tell the person to prefix that verb with sudo. When that launch is root, git and the compile return to the person who started it. A root login with no such person stops before git. Git, cmake, make, ninja, and the copy of the built programs **MUST** stay with the person who started setup. Dedicated system user privilege stays unused. Termux `pkg` stays unused. A host with none of those package managers **MUST** stop and name the missing tools.
42. `--msys2-root` is a Windows toolchain flag. On this Linux, setup **MUST** reject it.

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
| Supported hosts | `uname -s` is `Linux`, the host is not Debian 12 or 13, not Ubuntu 22.04, 24.04, or 26.04, and `TERMUX_VERSION` is unset |
| Examples that land here | A Linux `ID` other than `debian` and `ubuntu`. Ubuntu 20.04 and Ubuntu interim releases. Debian releases other than 12 and 13. An identity mismatch does not land here |
| Payload names | `tn5250`, and `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` when `syslog.h` exists |
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Upstream files | root `CMakeLists.txt` (`find_package(Curses REQUIRED)` when not WIN32, then `curses/` and `lp5250d/`), `curses/CMakeLists.txt`, `lp5250d/CMakeLists.txt`, `lib5250/CMakeLists.txt`, `config-cmake.h.in` |
| Package names | apt-get, apk, dnf, pacman, and zypper names are on `docs/requirements/requirement-shell-sudo-command.md`. An unknown manager names the missing tool |
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
| `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` | executables, built when `syslog.h` exists | `5250` |

`config-cmake.h.in` maps `#cmakedefine OPENSSL_FOUND` to `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.

### 2.8 Current script behavior

The POSIX ship unit routes Linux that is not Debian 12 or 13, not Ubuntu 22.04, 24.04, or 26.04, and not Termux to this build. The four syslog programs are copied only when `/usr/include/syslog.h` exists. When a tool is missing and apt-get, apk, dnf, pacman, or zypper is present, setup installs it through the sudo wrap in `docs/requirements/requirement-shell-sudo-command.md`. When every check already passes, setup does not call sudo. Git and the compile stay with the person who started setup. A host with none of those package managers stops and names the missing tools.

The authoring host is Ubuntu 24.04 (noble), so it took the Ubuntu path. No other-Linux compile was executed. The Ubuntu requirement records the setup command on that host.

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): this situation accepts Linux that the Debian and Ubuntu situations do not claim, and it refuses a build that did not produce `tn5250`.
- **CIAO Principle 2 – Intentional**: the detect, the tools, the generator, and the link set are written down.
- **CIAO Principle 5 – SSOT**: other-Linux compilation, link, and build have this file. Debian, Ubuntu, and Windows keep their own.
- **CIAO Principle 9**: admin privilege is used only to install missing compiler packages. Git and the compile stay with the person who started setup.
- **CIAO Principle 10 – Least privilege**: sudo runs only when a tool is missing. The build is not written to `/usr`.
- **CIAO Principle 21 – Dual policies**: the rules stay portable. The package-family names live on the sudo-command requirement.

## Under command line for normal user only

On this Linux the person runs setup as a normal user.

**This requirement:** missing compiler packages are installed with the sudo wrap when apt-get, apk, dnf, pacman, or zypper is present. Git and the compile stay with the person who started setup. Dedicated system user privilege stays unused. Termux is refused and `pkg` is not called. This shell is not Git Bash and not Windows cmd. The curses client runs in the terminal the person already has.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Termux and an identity mismatch do not become a generic Linux build.
- **Intentional**: one other-Linux file, one Unix CMake invocation, one link set.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain available. The tool check survives a distribution whose package names differ.
- **Over-protect**: the Windows source patch and the Windows libraries stay off this build. The connect fix is the only edit to the upstream C sources on this Linux.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this situation into the Debian requirement, the Ubuntu requirement, the Git Bash requirement, the CLI-interface file, or the class residual.
- Build the Windows GUI programs, apply the Windows GCC 14 patch, or link `Ws2_32` and `Winmm` on this Linux.
- Drive this build through MSYS2, `cygpath`, `cmd.exe`, or `MSYS_NO_PATHCONV`.
- Replace this CMake build with `autogen.sh` and `./configure`.
- Run git, cmake, make, or the payload copy through sudo.
- Call sudo when the compiler packages are already present.
- Invent a package manager when apt-get, apk, dnf, pacman, and zypper are all absent.
- Treat Debian 12 or 13, or Ubuntu 22.04, 24.04, or 26.04, as this situation.
- Treat a Debian or Ubuntu identity mismatch as this situation.
- Treat Termux as this situation, or invoke Termux `pkg`.
- Name one distribution’s package as the only acceptable package in the stop message.
- Treat a missing curses `tn5250` as success.
- Claim a distribution package named `tn5250` as the supported install.
- Drop the OpenSSL headers or the ncurses headers from the supported link.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-debian.md` | Debian situation. Does not own this build (RQ-DEBIAN) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu situation. Does not own this build (RQ-UBUNTU) |
| `docs/requirements/requirement-windows-git-bash.md` | Windows situation. Does not own this build (RQ-WINDOWS-GIT-BASH) |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names. Points here on other Linux (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style. Points here for this C build (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here (RQ-CLASS-SOFTWARE-DEV) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap that installs a missing compiler package on other Linux (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | Installer. The other-Linux branch is in the ship unit (§2.8) |
| `docs/reviews/test-plan.md` | Todo proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

These rows are not claimed as run.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-LNX-01 | setup accepts Linux that is not Debian 12 or 13, not Ubuntu 22.04, 24.04, or 26.04, and not Termux. macOS and Termux stop | todo |
| TP-LNX-02 | Configure is Ninja or Unix Makefiles, `Release`, with no Windows prefix and no `MSYS_NO_PATHCONV` | todo |
| TP-LNX-03 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-LNX-04 | The curses `tn5250` links `5250` and ncurses. The four syslog programs are produced when `syslog.h` exists | todo |
| TP-LNX-05 | The Windows GCC 14 patch is not applied | todo |
| TP-LNX-06 | A missing compiler package is installed with the sudo wrap when the package family is known. Git and the compile stay with the invoking person. A present toolchain does not call sudo. An unknown package manager stops and names the missing tools | todo |
| TP-LNX-07 | A build that does not produce `tn5250` fails | todo |
| TP-LNX-08 | A Debian or Ubuntu identity mismatch does not fall through to this situation | todo |
| TP-CLI-01 | setup, help, version, and host launch are named here and in the CLI-interface requirement | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

This Linux host can have an administrator. Setup borrows that role only for a missing compiler package. Git and the compile stay with the person. Termux stays outside this situation.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`setup`, `help`, `version`, and the host launch are commands that run this product.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Standalone other-Linux situation. Supported compile is system GCC and CMake Release. Supported link is static `5250` plus OpenSSL and ncurses. Supported build copies the curses client, and the four syslog programs when `syslog.h` exists. The ship unit does not implement the branch yet. |
| 2026-10-07 | Active 1.1.0 | Missing compiler packages are installed through RQ-SHELL-SUDO-COMMAND when apt-get, apk, dnf, pacman, or zypper is present. Git and the compile stay with the invoking person. The other-Linux branch is in the ship unit. |
| 2026-10-07 | Active 1.2.0 | The setup command must be started without sudo. A root setup stops before git and the compile. |
| 2026-10-07 | Active 1.3.0 | One setup verb for a normal user and a sudo launch. Git and the compile return to that person. |
| 2026-10-07 | Active 1.3.1 | The setup arrangement is named the mixed elevated sudo model. Help does not recommend a sudo prefix. |
| 2026-10-07 | Active 1.3.2 | The connect fix is applied before configure. A payload without `CONNECT-FIX` rebuilds. The Windows GCC 14 patch stays off. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
