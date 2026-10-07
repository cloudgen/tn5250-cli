**file**: docs/requirements/requirement-windows-git-bash.md
**ID**: RQ-WINDOWS-GIT-BASH
**Status**: Active (Version 1.3.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the standalone requirement for the Windows Git Bash situation. It owns detection, the isolation that lets a Git Bash process drive an MSYS2 toolchain, and the compilation, link, and build of the Windows TN5250 programs.

A person in Git Bash runs `tn5250-cli setup`. The supported result is three Windows GUI programs, compiled as C with CMake, linked as specified below. The Unix curses build is the Debian situation in `docs/requirements/requirement-debian.md`, the Ubuntu situation in `docs/requirements/requirement-ubuntu.md`, and the other-Linux situation in `docs/requirements/requirement-other-linux.md`. The autotools path is not this build.

`docs/requirements/requirement-shell-cli-interface.md` names the commands and points here. `docs/requirements/requirement-shell-script-coding.md` owns POSIX `/bin/sh` writing style and points here. Neither of those files owns the compiler, the libraries, or the build steps.

### 1.1 Human-facing

**In one sentence:** A person in Windows Git Bash runs `tn5250-cli setup`, and the installer compiles and links the IBM i 5250 programs with the UCRT64 CMake build.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person at the keyboard, with normal user privilege, in Git Bash | `tn5250-cli setup` |
| The other role | The upstream TN5250 project, which owns the window and the C sources | The built program opens its own window |
| Not this file | The short command map, and the Bash style sheet | `docs/requirements/requirement-shell-cli-interface.md` |

| Includes | Excludes |
|----------|----------|
| Git Bash detection, MSYS2 isolation, C compilation, the library link, and the build of the three Windows programs | The Unix curses client, autotools, sudo, a text-screen menu, and Termux pkg |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tn5250-cli` | the installer | the live setup |
| `tn5250-cli setup` | the build command | compile, link, and build |
| `tn5250 HOST` | the built program | a 5250 session after a successful setup |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client | The installer fetches the pinned sources, applies the Windows C fixes, configures CMake for Release, compiles, links OpenSSL plus the Windows libraries, and copies the three programs into the prefix | `tn5250-cli setup` |

## 2. Core Rules / Requirements (Mandatory)

### 2.0 Situation

1. This requirement is the only owner of the Windows Git Bash build situation. Command names may be repeated on the CLI-interface requirement. The compiler, the link, and the build steps **MUST NOT** be copied there.
2. The supported host for setup and launch is Git Bash on Windows x86_64. The person has normal user privilege. `version` prints on any host. Its CLI line is owned by `docs/requirements/requirement-shell-cli-interface.md`.
3. The supported payload build is the upstream Windows CMake build: language C, CMake 3.12 or newer, MinGW-w64 UCRT64 GCC, a single-config Release build. It is not the Unix autotools build and not the curses client.

### 2.1 Detection

4. `setup` (except `setup -h` and `setup --help`) and launch **MUST** refuse to continue unless the shell is Git Bash as this product detects it. The refusal **MUST** name Git Bash on Windows and **MUST** exit non-zero. `version` is not this detect. The CLI version line is owned by `docs/requirements/requirement-shell-cli-interface.md`. When the `REF` and `REVISION` files exist, the extra payload line is `tn5250 <ref> (<revision>)`.
5. `help` and `setup --help` **MUST** be allowed to print usage without that check.
6. The ship unit’s detect **MUST** be the pair recorded in Implementation Notes. A `/c` directory test, by itself, is the environment’s glossary signal. It is not a substitute for the ship unit’s pair.
7. WSL, Windows cmd, Cygwin, and Termux are not this build shell. The detect **MUST** refuse them for setup and for launch.

### 2.2 Supported compilation

8. The payload **MUST** be compiled as C through CMake. The configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`.
9. CMake **MUST** be at least 3.12, matching the upstream project.
10. Paths passed into CMake **MUST** be MinGW paths (`cygpath -m`). The CMake process **MUST** run with `MSYS_NO_PATHCONV=1` so Git Bash does not rewrite those paths.
11. The generator **MUST** be Ninja when `ninja` is available on the toolchain path. Otherwise the generator **MUST** be `MinGW Makefiles` when `mingw32-make` is available. If neither generator exists, setup **MUST** stop with a non-zero status.
12. The compile **MUST** be a single-config build. Release is selected at configure time. The build step **MUST** be `cmake --build <build> --parallel <jobs>` with the same path prefix and `MSYS_NO_PATHCONV=1`. It **MUST NOT** pass a multi-config `--config` switch for this generator pair.
13. `<jobs>` **MUST** be a positive integer. The default is the machine’s `nproc` when that command works, otherwise 4.
14. Before configure, setup **MUST** apply the source fixes in Implementation Notes. Upstream v0.18.0 does not compile with GCC 14 and newer until those fixes are applied. The fixes **MUST** be applied with `git apply` on the checkout. They **MUST NOT** be committed as a second upstream revision.
15. The supported compiler **MUST** be MinGW-w64 UCRT64 GCC, taken from the UCRT64 prefix whose `bin` directory is placed first on `PATH` for the CMake process.
16. Setup **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. Setup **MUST NOT** build the curses terminal, the Unix `lp5250d`, or the Unix-only filters.

### 2.3 Supported link

17. The protocol code **MUST** be a static library whose CMake target name is `5250`.
18. On WIN32 that static library **MUST** link `Ws2_32` and `Winmm`.
19. The supported link **MUST** also link `OpenSSL::Crypto` and `OpenSSL::SSL`. Configure **MUST** pass `-DCMAKE_PREFIX_PATH` set to the MinGW path of the UCRT64 prefix (the parent of `ucrt64/bin`) so `find_package(OpenSSL)` can succeed. When that package is found, the generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
20. Upstream `find_package(OpenSSL)` is not `REQUIRED`. The supported setup still installs the UCRT64 OpenSSL package and passes the prefix, so the find succeeds. A configure that omits the prefix is not the supported link.
21. The three programs **MUST** be CMake `WIN32` executables (Windows GUI subsystem, not a console subsystem): `tn5250`, `lp5250d`, and `dftmap`. Each **MUST** link only the static library `5250`. They pick up Winsock, Winmm, and OpenSSL through that library.
22. `tn5250` **MUST** be built from the upstream Win32 sources (`tn5250-win.c`, `tn5250-res.rc`, `winterm.c`), `lp5250d` from `lp5250d-win.c`, and `dftmap` from `dftmap.c`.

### 2.4 Supported build

23. Setup **MUST** obtain sources for the pinned ref before compile. The fetch **MUST** be a shallow clone or a shallow fetch of that ref, then a detached checkout. `git` **MUST** be present or setup stops.
24. The build tree **MUST** be configured and compiled in a cache directory that belongs to the user. A rebuild **MUST** remove that build directory before configure.
25. After a successful compile, setup **MUST** copy `tn5250.exe`, `lp5250d.exe`, and `dftmap.exe` from the build tree into the application directory, skipping anything under a `CMakeFiles` directory.
26. If `tn5250.exe` is missing after the build, setup **MUST** stop with a non-zero status. Copying the other two programs does not make up for a missing `tn5250.exe`.
27. Setup **MUST** write the requested ref and the checkout’s `HEAD` revision next to the programs so `version` can print them.
28. Setup **MUST** copy the direct runtime DLLs of each copied executable from the compiler’s `bin` directory, using `objdump -p` and the `DLL Name` lines. One level of DLL names is the rule. Transitive dependencies of those DLLs are not walked.
29. The application directory **MUST** be `${PREFIX}/opt/tn5250`. The default prefix **MUST** be `${HOME}/.local`, overridable by `--prefix` or `TN5250_PREFIX`. The prefix **MUST** be converted with `cygpath -u` and **MUST NOT** be empty.
30. Setup **MUST** copy the installer itself to `${PREFIX}/bin/tn5250-cli` when that destination is not already the same file, and **MUST** mark it executable. The installer name stays `tn5250-cli` so it does not shadow `tn5250.exe`.

### 2.5 Toolchain isolation

31. When the toolchain is an MSYS2 tree, package installs and other MSYS2 shell work **MUST** run as that tree’s `usr/bin/bash.exe --login`, with Git Bash not the parent of that bash.
32. The parent **MUST** be `cmd.exe` invoked with a doubled slash (`cmd.exe //c`) so Git Bash does not rewrite a single `/c` into a drive path. The child command **MUST** clear `MSYSTEM` and `CHERE_INVOKING` before starting MSYS2 bash. This keeps Git Bash’s `msys-2.0.dll` from colliding with MSYS2’s runtime.
33. The supported toolchain packages are the UCRT64 GCC, CMake, Ninja, OpenSSL, and pkgconf packages named in Implementation Notes. They **MUST** be installed into the chosen MSYS2 tree when `ucrt64/bin/gcc.exe`, `cmake.exe`, or `ninja.exe` is missing. After that install, those three executables **MUST** exist or setup stops.
34. The supported place for a toolchain this installer downloads is a private tree under the user’s prefix: `${HOME}/.local/opt/msys64`. An explicit `--msys2-root` / `TN5250_MSYS2_ROOT` **MUST** point at a tree that already contains `usr/bin/bash.exe`, or setup stops.
35. `curl` **MUST** be present when a download of that private tree is required.

### 2.6 Privilege and neighbors

36. Setup **MUST NOT** invoke sudo, apt, dnf, Termux pkg, or a dedicated system user. It writes under the user’s prefix and the user’s cache.
37. There is no text screen in this installer. The built `tn5250.exe` opens the upstream window.
38. Launch **MUST** set `MSYS_NO_PATHCONV=1` and **MUST** execute the built `tn5250.exe`. Version **MUST** print the ref and revision written by the build. Both require the Git Bash detect.
39. Help does not compile. Its wording is the CLI-interface requirement. This file still names the help sample so the command is not documented in only one place.

### 2.7 Implementation Notes (this project)

**Identity**

| Item | Value |
|------|--------|
| Installer | `tn5250-cli`, ship unit `src/tn5250-cli` |
| Payload names | `tn5250.exe`, `lp5250d.exe`, `dftmap.exe` |
| Upstream | `https://github.com/tn5250/tn5250.git` |
| Pinned ref | tag `v0.18.0` |
| Commit that tag resolves to | `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Upstream build files at that tag | root `CMakeLists.txt` (`cmake_minimum_required` 3.12, `project(tn5250 LANGUAGES C VERSION 0.18.0)`, `find_package(OpenSSL)` without `REQUIRED`, curses only when `NOT WIN32`, `add_subdirectory(win32)` on WIN32), `lib5250/CMakeLists.txt`, `win32/CMakeLists.txt`, `config-cmake.h.in` |
| License of the upstream sources | LGPL-2.1. The installer script has no license header. That fact is recorded here. It is not a compile rule |

The script stores the tag text, not the commit id, as the default ref. A raw commit id is outside the shallow `--branch` clone the script uses. `--ref` accepts a tag or a branch.

**Complete command samples**

```bash
tn5250-cli setup
tn5250-cli setup --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli setup --msys2-root "${HOME}/.local/opt/msys64" --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token is owned by `docs/requirements/requirement-shell-cli-zero-arguments.md`. It does not compile. `tn5250-cli setup --help` shows help and does not compile.

**Detect the ship unit actually runs**

Both must match before the Windows setup or the Windows launch continues. `version` does not use this check. `help` and `setup --help` do not use this check.

| Check | Accept |
|-------|--------|
| `OSTYPE` | `msys*` or `mingw*` |
| `uname -s` | `MINGW*` or `MSYS*` |

On the authoring host, which is Ubuntu 24.04, `tn5250-cli setup` follows the Ubuntu requirement. An earlier script stopped that host with `setup needs Git Bash on Windows, or Debian 12 or 13.` The Ubuntu and other-Linux branches are in the ship unit. This Windows requirement still does not call sudo, apt, or Termux pkg. A missing `tn5250.exe` on Git Bash still stops with `tn5250 is not installed in this Git Bash yet. Run: tn5250-cli setup`.

**Supported CMake invocation**

`UCRT64_BIN` is `cygpath -u` of `<msys2>/ucrt64/bin`. `SRC_MINGW` and `BUILD_MINGW` are `cygpath -m` of the source cache and the build cache. `UCRT64_PREFIX_MINGW` is `cygpath -m` of `<msys2>/ucrt64` (the parent of that `bin`).

```text
PATH="${UCRT64_BIN}:${PATH}" MSYS_NO_PATHCONV=1 cmake \
  -G Ninja \
  -S "${SRC_MINGW}" \
  -B "${BUILD_MINGW}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="${UCRT64_PREFIX_MINGW}"

PATH="${UCRT64_BIN}:${PATH}" MSYS_NO_PATHCONV=1 cmake \
  --build "${BUILD_MINGW}" \
  --parallel "${JOBS}"
```

When Ninja is absent and `mingw32-make` is present, `-G Ninja` is replaced by `-G "MinGW Makefiles"`. The same `PATH` and `MSYS_NO_PATHCONV=1` apply to both processes.

**Supported link, from the upstream CMake at the pinned tag**

| Target | Kind | Link line |
|--------|------|-----------|
| `5250` | static library from the lib5250 sources, including `sslstream.c` and `telnetstr.c` | `OpenSSL::Crypto` and `OpenSSL::SSL` when `OPENSSL_FOUND`; `Ws2_32` and `Winmm` when `WIN32` |
| `tn5250` | `add_executable(tn5250 WIN32 tn5250-win.c tn5250-res.rc winterm.c)` | `5250` |
| `lp5250d` | `add_executable(lp5250d WIN32 lp5250d-win.c)` | `5250` |
| `dftmap` | `add_executable(dftmap WIN32 dftmap.c)` | `5250` |

`config-cmake.h.in` maps `#cmakedefine OPENSSL_FOUND` to `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`. The curses `find_package` and the `curses/` and Unix `lp5250d/` subdirectories are inside `if (NOT WIN32)`. They are not part of this build.

Not produced by this Windows build: the curses `tn5250`, `xt5250`, `scs2ascii`, `scs2pdf`, `scs2ps`.

**Source fixes applied before configure (GCC 14 and newer)**

| File at v0.18.0 | Change |
|-----------------|--------|
| `lib5250/sslstream.c` (`int ioctlarg = 1` in `ssl_stream_connect`) | `u_long ioctlarg = 1` |
| `lib5250/telnetstr.c` (the same declaration in `telnet_stream_connect`) | `u_long ioctlarg = 1` |
| `win32/dftmap.c` prototype and definition of `DlgProc` | `BOOL CALLBACK` becomes `INT_PTR CALLBACK` |
| `win32/tn5250-win.c` prototype and definition of `ConnectDlgProc` | `BOOL CALLBACK` becomes `INT_PTR CALLBACK` |
| `win32/lp5250d-win.c` | `GetDefaultPrinter` becomes `tn5250_default_printer` at the prototype, the definition, and the call |
| `win32/lp5250d-win.c` | add `int win32_run_process(const char* cmd, int wait);` because the printer file calls it and the definition lives in `lib5250/utility.c` |

The patch is embedded in `apply_win32_fixes` and applied with `git apply --whitespace=nowarn`. `git rev-parse HEAD` still reports the upstream commit, because the patch is not a new commit.

**UCRT64 packages**

| Package |
|---------|
| `mingw-w64-ucrt-x86_64-gcc` |
| `mingw-w64-ucrt-x86_64-cmake` |
| `mingw-w64-ucrt-x86_64-ninja` |
| `mingw-w64-ucrt-x86_64-openssl` |
| `mingw-w64-ucrt-x86_64-pkgconf` |

Package install, when needed: `pacman -Syu --noconfirm` twice, then `pacman -S --needed --noconfirm` of the five names. If that install fails: `pacman-key --init && pacman-key --populate msys2` and the same `pacman -S`. All of that runs through the `cmd.exe //c` isolation above. Setup then requires `ucrt64/bin/gcc.exe`, `cmake.exe`, and `ninja.exe`.

**Directories**

| Path | Role |
|------|------|
| `${PREFIX}/opt/tn5250` | `tn5250.exe`, `lp5250d.exe`, `dftmap.exe`, copied DLLs, `REF`, `REVISION` |
| `${PREFIX}/bin/tn5250-cli` | copy of the installer when it differs from the running file |
| `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` | shallow source checkout |
| `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` | CMake build tree, removed before a rebuild |
| `${HOME}/.local/opt/msys64` | private MSYS2 tree when setup downloads one |

Default `PREFIX` is `${HOME}/.local`.

**Runtime DLL copy**

For each copied exe, `objdump -p` from the compiler `bin` (or `objdump` on `PATH`). `awk` prints the third field of lines matching `DLL Name:`. Each name that exists in the compiler `bin` is copied beside the exe. One level only.

**Version line**

The CLI version line is owned by `docs/requirements/requirement-shell-cli-interface.md`. This file owns the payload line. When the `REF` and `REVISION` files exist, that line is `tn5250 <ref> (<revision>)`. `REVISION` is `git rev-parse HEAD` of the checkout after the patch was applied. The patch is not a second commit, so `HEAD` stays the upstream commit.

**Launch**

`MSYS_NO_PATHCONV=1` then `exec` of `${APP_DIR}/tn5250.exe` with the remaining arguments. A missing exe stops with `tn5250 is not installed in this Git Bash yet. Run: tn5250-cli setup`.

### 2.8 Current behavior that is wider or softer than the supported build

These are facts about `src/tn5250-cli` today. They are not extra obligations, and they are not a second supported build. A later change that closes one of them has to say so in this file. This requirement does not silently turn them into new fail-closed rules.

| Topic | What the script does today |
|-------|----------------------------|
| Toolchain search order | Explicit `--msys2-root`, else `${HOME}/.local/opt/msys64`, else `/c/msys64`, else `/c/tools/msys64`, else `gcc` and `cmake` already on `PATH`, else download the private tree |
| System MSYS2 trees | If `/c/msys64` or `/c/tools/msys64` is chosen and UCRT64 gcc, cmake, or ninja is missing, the script runs `pacman -Syu` on that tree. That mutates a machine-wide install. The supported download location remains the private tree |
| PATH compiler fallback | If no MSYS2 tree exists and `gcc` and `cmake` are on `PATH`, `TOOL_BIN` stays empty, Ninja or `mingw32-make` is required, and `-DCMAKE_PREFIX_PATH` is omitted. OpenSSL is then not installed by setup and may be absent from the link. That is not the supported link in §2.3 |
| `pacman -Syu` errors | Each of the two updates ignores its own exit status. The later check still stops if gcc, cmake, or ninja is missing |
| MSYS2 archive | Newest `msys2-base-x86_64-YYYYMMDD.sfx.exe` named in the HTML index at `https://repo.msys2.org/distrib/x86_64/`. No checksum. Re-download when the cache file is missing, empty, or smaller than 1000000 bytes. Cache path is `${HOME}/.cache/tn5250/`, which does not read `XDG_CACHE_HOME`. Extract with `MSYS_NO_PATHCONV=1` and `-y -o<parent>` |
| Rebuild skip | Skip the compile when `--force` is off and the application directory already has `tn5250.exe`, a `REF` equal to the requested ref, and a `REVISION` equal to current `HEAD`. The patch contents are not part of that key. A second setup checks out the same commit (the checkout drops the previous patch), reapplies the patch, and can still skip the compile. A patch edit at the same commit rebuilds only with `--force` |
| `objdump` missing | Setup logs `objdump is unavailable; runtime DLLs were not copied` and continues |
| DLL not in the compiler bin | That DLL is skipped. Setup does not fail for it |
| OpenSSL on the PATH fallback | CMake’s optional `find_package(OpenSSL)` can leave `HAVE_LIBSSL` undefined while setup still succeeds |

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): the Windows setup and the Windows launch refuse a shell that is not Git Bash, and the Windows build refuses a result that did not produce `tn5250.exe`.
- **CIAO Principle 2 – Intentional**: generator, Release, prefix, jobs, and the link set are written down.
- **CIAO Principle 3 – Anti-fragile**: Ninja is preferred and MinGW Makefiles remain available. A missing private toolchain can be downloaded under the user’s prefix.
- **CIAO Principle 4 / 20 – Over-protect**: MSYS2 bash is started under `cmd.exe`, path conversion is disabled, and the GCC 14 fixes land before compile.
- **CIAO Principle 5 – SSOT**: this file is the only owner of compilation, link, and build.
- **CIAO Principle 9**: admin privilege and dedicated system user privilege stay unused on Git Bash.
- **CIAO Principle 10 – Least privilege**: no sudo. Writes stay in the user’s prefix and cache.
- **CIAO Principle 21 – Dual policies**: the rules above stay in role language. This product’s packages, commit, and argv are in Implementation Notes.

## Under command line for normal user only

Git Bash is the shell this requirement detects. The person acts with normal user privilege.

**This requirement:** setup compiles and links inside that person’s prefix and cache. It does not implement admin privilege or dedicated system user privilege. It does not call sudo, apt, dnf, or Termux pkg. Windows cmd may appear only as the short-lived parent that starts MSYS2 bash (`cmd.exe //c`). Windows cmd is not the shell that configures CMake. WSL is not this shell. The built `tn5250.exe` is a Windows GUI program started from Git Bash.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the supported link is the UCRT64 prefix that finds OpenSSL, plus Winsock and Winmm. A PATH-only compiler is recorded as softer current behavior.
- **Intentional**: one situation, one file, one CMake invocation.
- **Anti-fragile**: the generator falls from Ninja to MinGW Makefiles, and the source fixes are reapplied on every setup that reaches that step.
- **Over-protect**: DLL isolation and `MSYS_NO_PATHCONV` stay even though they look like small flags. Dropping either one breaks the build or mixes two C runtimes.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Fold this situation back into the CLI-interface file, the coding-style file, or the class residual.
- Replace this Windows CMake build with autotools, `./configure`, or the curses client.
- Drop `Ws2_32`, `Winmm`, or the supported OpenSSL link (`OpenSSL::SSL` and `OpenSSL::Crypto` via `CMAKE_PREFIX_PATH`).
- Configure or build without `MSYS_NO_PATHCONV=1` on the CMake processes.
- Start MSYS2 `bash.exe` as a direct child of Git Bash.
- Invoke `cmd.exe` with a single `/c` from Git Bash.
- Treat a missing `tn5250.exe` as success.
- Add sudo, apt, dnf, Termux pkg, or a dedicated system user.
- Add a text-screen menu to the installer.
- Silently promote a row in §2.8 into a new fail-closed rule, or silently bless the PATH-compiler fallback as the supported link, without an explicit change to this requirement.
- Pin a different upstream ref in prose while the script still defaults to `v0.18.0`, unless both change together.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-debian.md` | Debian curses compile, link, and build (RQ-DEBIAN). This file does not own it |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu curses compile, link, and build (RQ-UBUNTU). This file does not own it |
| `docs/requirements/requirement-other-linux.md` | Other Linux curses compile, link, and build (RQ-OTHER-LINUX). This file does not own it |
| `docs/requirements/requirement-shell-cli-interface.md` | Command names. Points here for the Git Bash compile, link, and build (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-script-coding.md` | POSIX /bin/sh writing style. Points here for the C build (RQ-SHELL-SCRIPT-CODING) |
| `docs/requirements/requirement-class-software-dev.md` | Class residual. Points here for the toolchain (RQ-CLASS-SOFTWARE-DEV) |
| `src/tn5250-cli` | Installer that implements this situation |
| `docs/reviews/test-plan.md` | Todo proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

This host is not Git Bash. The rows below are not claimed as run.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-WGB-01 | setup and launch stop when `OSTYPE` or `uname -s` is outside the Git Bash pair. version still prints the CLI line | ran on the authoring host. Not a Windows compile |
| TP-WGB-02 | `tn5250-cli help` and `tn5250-cli setup -h` exit 0 without that detect | ran on the authoring host |
| TP-WGB-03 | Supported configure is `-G Ninja` or `-G "MinGW Makefiles"`, `-DCMAKE_BUILD_TYPE=Release`, and `-DCMAKE_PREFIX_PATH` of the UCRT64 prefix | todo |
| TP-WGB-04 | Build is `cmake --build … --parallel` with `MSYS_NO_PATHCONV=1`, and does not run `cmake --install` or `./configure` | todo |
| TP-WGB-05 | Static library `5250` links `OpenSSL::SSL`, `OpenSSL::Crypto`, `Ws2_32`, and `Winmm`; the three WIN32 executables link `5250` | todo |
| TP-WGB-06 | The GCC 14 source fixes are applied before configure and are not a new commit | todo |
| TP-WGB-07 | MSYS2 bash is started with `cmd.exe //c`, with `MSYSTEM` and `CHERE_INVOKING` cleared | todo |
| TP-WGB-08 | A build that does not produce `tn5250.exe` fails | todo |
| TP-WGB-09 | The five UCRT64 package names are the ones setup installs | todo |
| TP-CLI-01 | setup, help, version, and host launch are named here and in the CLI-interface requirement | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Git Bash

**Definition:** Git Bash is an instance of command line for normal user only. It is the MSYS/MINGW POSIX shell shipped with Git for Windows. The environment’s primary detect is a `/c/` or `/c` directory (Windows `C:` as Git Bash mounts it; default drive `/c/`). Secondary signals are `MSYSTEM` matching `MINGW*`, `MSYS*`, `UCRT*`, or `CLANG*`, or `uname -s` matching `MINGW*` or `MSYS*`. WSL is excluded (`WSL_DISTRO_NAME`). On detect, admin privilege and dedicated system user privilege stay unused. Git Bash has no Termux pkg. The ship unit’s check is the `OSTYPE` plus `uname -s` pair in Implementation Notes.

**Human daily-life explanation:** Git Bash is a Windows drawer that only opens with your keys. It looks like a Unix shell. It is not a Linux superintendent desk.

**Daily-life example:** You run git and this program as yourself. The program must not grow sudo apt or a dedicated system-user switch because you opened Git Bash.

Must not confuse Git Bash with Termux, Windows cmd, Cygwin, WSL, a Git object store, or the `winpty` console helper. Those are other things. This requirement’s build shell is Git Bash.

### Command line for normal user only

**Definition:** A command line for normal user only is a POSIX-like shell whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows cmd. There is no usable root or sudo host change and no dedicated system account for this login. When the ship unit detects this kind of shell, it must not implement admin privilege or dedicated system user privilege: no in-tool sudo, no apt or dnf wrap, no /etc destination, no useradd, and no switch to a dedicated system user.

**Human daily-life explanation:** A command line for normal user only is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows cmd are this kind of room: you can tidy your own drawer. You cannot borrow the building site key or put on a dedicated-operator badge.

**Daily-life example:** On Termux you run pkg as yourself. On Git Bash you run git as yourself. On Windows cmd you type as yourself. None of those rooms should grow a sudo apt or a hidden system-user switch.

### Operational verb

**Definition:** An operational verb is a routed command that runs the product, including lifecycle commands such as install and help. It is not a unit-test command. Normal user privilege still applies. A command that runs as the normal user is still a product command, not a unit test.

**Human daily-life explanation:** An operational verb is a command that actually does product work: install, help, convert, submit, list. It is not a unit-test-only verb.

**Daily-life example:** “Please bake the cake” is operational. “Please run the kitchen’s practice quiz about baking” is a test verb.

`setup`, `help`, `version`, and the host launch are commands that run this product. None of them is a unit-test command.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Standalone Git Bash situation. Supported compile is UCRT64 CMake Release. Supported link is static `5250` plus OpenSSL::SSL, OpenSSL::Crypto, Ws2_32, and Winmm. Supported build copies the three WIN32 programs. Softer script paths recorded in §2.8. |
| 2026-10-07 | Active 1.1.0 | Debian curses build is pointed at RQ-DEBIAN. This file still owns only the Windows situation. |
| 2026-10-07 | Active 1.2.0 | Version’s CLI line points at the CLI requirement. Setup and launch still refuse a shell that is not Git Bash. The refusal text names Git Bash or Debian. Empty argv is no longer help. Compile, link, build, and the §2.8 softer paths are unchanged. The Windows compile was not run on the authoring host. |
| 2026-10-07 | Active 1.3.0 | Ubuntu and other Linux point at RQ-UBUNTU and RQ-OTHER-LINUX. This file still owns only the Windows situation. The ship unit’s refusal text on the authoring host is unchanged. |
| 2026-10-07 | Active 1.3.1 | The authoring-host setup follows the Ubuntu requirement. This file still does not call sudo. |

**Last Updated**: 2026-10-07
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
