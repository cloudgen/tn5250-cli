**file**: docs/requirements/requirement-windows-git-bash-build-payload.md
**ID**: RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD
**Status**: Active (Version 1.0.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Git Bash build-payload requirement. It owns the compilation, link, and build of the three Windows TN5250 programs, and the UCRT64 packages those steps need.

How the ship unit detects Git Bash, starts MSYS2 through `cmd.exe`, copies `tn5250-cli` into `~/.local/bin`, and launches the exe belongs to `docs/requirements/requirement-windows-git-bash-cli-coding.md`. This file does not restate that script.

### 1.1 Human-facing

**In one sentence:** In Git Bash, build compiles three Windows GUI programs with UCRT64 CMake and leaves them under `~/.local/opt/tn5250`, not in `~/.local/bin`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose build run compiles the client | `tn5250-cli build` |
| The other role | The upstream TN5250 C sources | tag `v0.18.0` |
| Not this file | Detection and `cmd.exe` isolation | `docs/requirements/requirement-windows-git-bash-cli-coding.md` |

| Includes | Excludes |
|----------|----------|
| UCRT64 GCC, CMake Release, OpenSSL, `Ws2_32`, `Winmm`, the five package names, and the copy of the three exe files | The installer in `~/.local/bin`, the Unix curses client, and autotools |

| Surface | What you open | What for |
|---------|---------------|----------|
| `${HOME}/.local/opt/tn5250/tn5250.exe` | the built program | a 5250 window |
| `tn5250-cli build` | the build command | compile, link, and copy |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the Git Bash payload build. CLI coding stays on `docs/requirements/requirement-windows-git-bash-cli-coding.md`.
2. The supported payload is the upstream Windows CMake build: language C, CMake 3.12 or newer, MinGW-w64 UCRT64 GCC, a single-config Release build. It is not the Unix autotools build and not the curses client.
3. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`. Paths passed into CMake **MUST** be MinGW paths (`cygpath -m`). The CMake process **MUST** run with `MSYS_NO_PATHCONV=1`.
4. The generator **MUST** be Ninja when `ninja` is on the toolchain path. Otherwise it **MUST** be `MinGW Makefiles` when `mingw32-make` is available. If neither exists, build **MUST** stop.
5. The build step **MUST** be `cmake --build <build> --parallel <jobs>` with the same path prefix and `MSYS_NO_PATHCONV=1`. It **MUST NOT** pass `--config`. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
6. Build **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. Build **MUST NOT** build the curses terminal, the Unix `lp5250d`, or the Unix-only filters.
7. The compiler **MUST** be MinGW-w64 UCRT64 GCC, from the UCRT64 prefix whose `bin` directory is first on `PATH` for the CMake process.
8. Before configure, build **MUST** apply the connect fix, then the GCC 14 source fixes in the notes below. Both are `git apply` on the checkout. Neither is a second commit. `git rev-parse HEAD` stays the upstream commit.
9. The static library target `5250` **MUST** link `Ws2_32` and `Winmm`, and **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. Configure **MUST** pass `-DCMAKE_PREFIX_PATH` set to the MinGW path of the UCRT64 prefix so `find_package(OpenSSL)` succeeds. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
10. `tn5250`, `lp5250d`, and `dftmap` **MUST** be CMake `WIN32` executables. Each **MUST** link only `5250`. `tn5250` is built from `tn5250-win.c`, `tn5250-res.rc`, and `winterm.c`. `lp5250d` is built from `lp5250d-win.c`. `dftmap` is built from `dftmap.c`.
11. If `tn5250.exe` is missing after the build, build **MUST** stop. Copying the other two programs does not make up for it.
12. Build **MUST** copy `tn5250.exe`, `lp5250d.exe`, and `dftmap.exe` into `${PREFIX}/opt/tn5250`, skipping anything under `CMakeFiles`. It **MUST** write `REF`, `REVISION`, and `CONNECT-FIX` (`addrinfo-1`) next to them. When `--force` is off, build **MUST** skip the compile only if `tn5250.exe` is present and all three stamps match.
13. Build **MUST** copy the direct runtime DLLs of each copied executable from the compiler `bin`, using `objdump -p` and the `DLL Name` lines. One level only.
14. The supported toolchain packages **MUST** be installed into the chosen MSYS2 tree when `ucrt64/bin/gcc.exe`, `cmake.exe`, or `ninja.exe` is missing. After that install those three executables **MUST** exist or build stops. The install runs through the CLI coding requirement's `cmd.exe //c` isolation. The private download location is `${HOME}/.local/opt/msys64`.

| Package |
|---------|
| `mingw-w64-ucrt-x86_64-gcc` |
| `mingw-w64-ucrt-x86_64-cmake` |
| `mingw-w64-ucrt-x86_64-ninja` |
| `mingw-w64-ucrt-x86_64-openssl` |
| `mingw-w64-ucrt-x86_64-pkgconf` |

Package install, when needed: `pacman -Syu --noconfirm` twice, then `pacman -S --needed --noconfirm` of the five names. If that install fails: `pacman-key --init && pacman-key --populate msys2` and the same `pacman -S`.

15. Build **MUST** obtain sources for the pinned ref before compile. The fetch **MUST** be a shallow clone or a shallow fetch of that ref, then a detached checkout. `git` **MUST** be present or build stops. The default ref stored is the tag text, not the commit id. A raw commit id is outside the shallow `--branch` clone.
16. The build tree **MUST** be configured and compiled in a cache directory that belongs to the user. A rebuild **MUST** remove that build directory before configure.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Default ref | the tag text, not the commit id |
| Upstream license | LGPL-2.1. The installer script has no license header. Not a compile rule |
| Payload names | `tn5250.exe`, `lp5250d.exe`, `dftmap.exe` |
| Install directory | `${PREFIX}/opt/tn5250`. Default prefix `${HOME}/.local` |
| Not this directory | `${PREFIX}/bin` holds `tn5250-cli` only |
| Source cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` |
| Build cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` |
| Private MSYS2 tree | `${HOME}/.local/opt/msys64` |
| Not produced | the curses `tn5250`, `xt5250`, `scs2ascii`, `scs2pdf`, `scs2ps` |

**Supported CMake invocation**

`UCRT64_BIN` is `cygpath -u` of `<msys2>/ucrt64/bin`. `SRC_MINGW` and `BUILD_MINGW` are `cygpath -m` of the source cache and the build cache. `UCRT64_PREFIX_MINGW` is `cygpath -m` of `<msys2>/ucrt64`.

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

When Ninja is absent and `mingw32-make` is present, `-G Ninja` is replaced by `-G "MinGW Makefiles"`.

| Target | Kind | Link line |
|--------|------|-----------|
| `5250` | static library | `OpenSSL::Crypto` and `OpenSSL::SSL` when `OPENSSL_FOUND`; `Ws2_32` and `Winmm` when `WIN32` |
| `tn5250` | `add_executable(tn5250 WIN32 tn5250-win.c tn5250-res.rc winterm.c)` | `5250` |
| `lp5250d` | `add_executable(lp5250d WIN32 lp5250d-win.c)` | `5250` |
| `dftmap` | `add_executable(dftmap WIN32 dftmap.c)` | `5250` |

**GCC 14 source fixes, applied after the connect fix**

| File at v0.18.0 | Change |
|-----------------|--------|
| `lib5250/sslstream.c` | `int ioctlarg = 1` becomes `u_long ioctlarg = 1` |
| `lib5250/telnetstr.c` | the same declaration becomes `u_long ioctlarg = 1` |
| `win32/dftmap.c` `DlgProc` | `BOOL CALLBACK` becomes `INT_PTR CALLBACK` |
| `win32/tn5250-win.c` `ConnectDlgProc` | `BOOL CALLBACK` becomes `INT_PTR CALLBACK` |
| `win32/lp5250d-win.c` | `GetDefaultPrinter` becomes `tn5250_default_printer` |
| `win32/lp5250d-win.c` | add `int win32_run_process(const char* cmd, int wait);` |

The connect fix initializes `struct addrinfo *result` to `NULL` and does not call `freeaddrinfo` when `getaddrinfo` fails. `CONNECT-FIX` is `addrinfo-1`. The GCC 14 patch then changes `int ioctlarg` to `u_long`.

**Runtime DLL copy.** For each copied exe, `objdump -p` from the compiler `bin`. `awk` prints the third field of lines matching `DLL Name:`. Each name that exists in the compiler `bin` is copied beside the exe. One level only.

**Payload version line.** When `REF` and `REVISION` exist, the extra line is `tn5250 <ref> (<revision>)`. `REVISION` is `git rev-parse HEAD` after the patches. `HEAD` stays the upstream commit.

### 2.2 Current behavior that is wider or softer than the supported build

These are facts. They are not extra obligations and not a second supported build.

| Topic | What the script does today |
|-------|----------------------------|
| PATH compiler fallback | If no MSYS2 tree exists and `gcc` and `cmake` are on `PATH`, `TOOL_BIN` stays empty, Ninja or `mingw32-make` is required, and `-DCMAKE_PREFIX_PATH` is omitted. That is not the supported link |
| MSYS2 archive | Newest `msys2-base-x86_64-YYYYMMDD.sfx.exe` named in the HTML index at `https://repo.msys2.org/distrib/x86_64/`. No checksum. Re-download when the cache file is missing, empty, or smaller than 1000000 bytes. Cache path is `${HOME}/.cache/tn5250/`, which does not read `XDG_CACHE_HOME` |
| Rebuild skip | Skip when `--force` is off and `tn5250.exe`, `REF`, `REVISION`, and `CONNECT-FIX` all match. The GCC 14 patch text is not a separate key |
| `objdump` missing | Build logs that runtime DLLs were not copied and continues |
| DLL not in the compiler bin | That DLL is skipped. Build does not fail for it |
| OpenSSL on the PATH fallback | CMake's optional `find_package(OpenSSL)` can leave `HAVE_LIBSSL` undefined while build still succeeds |

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): a build that did not produce `tn5250.exe` is not success.
- **CIAO Principle 5 – SSOT**: the UCRT64 package table and the link line have this file.
- **CIAO Principle 10 – Least privilege**: the payload is written under the user's prefix, not into a system directory by this file's rules.

## Under command line for normal user only

The compile runs as this login. MSYS2 is started by the CLI coding requirement. This file does not call sudo.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the supported link uses the UCRT64 prefix. A PATH-only compiler is softer current behavior, not the supported link.
- **Intentional**: one CMake invocation and one package table.
- **Anti-fragile**: Ninja is preferred and MinGW Makefiles remain.
- **Over-protect**: `MSYS_NO_PATHCONV=1` stays on the CMake processes. The Windows libraries stay on the link line.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Move the package table, the link line, or the GCC 14 patch back into the CLI coding requirement.
- Copy the exe files into `~/.local/bin`.
- Replace this CMake build with autotools, `./configure`, or the curses client.
- Drop `Ws2_32`, `Winmm`, or the OpenSSL link.
- Configure or build without `MSYS_NO_PATHCONV=1` on the CMake processes.
- Treat a missing `tn5250.exe` as success.
- Silently bless the PATH-compiler fallback as the supported link.
- Pin a different upstream ref in prose while the script still defaults to `v0.18.0`, unless both change together.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-windows-git-bash-cli-coding.md` | Detection, isolation, installer path, launch (RQ-WINDOWS-GIT-BASH-CLI-CODING) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | The MSYS2 archive has no checksum here (RQ-SHELL-AUTOMATIC-CHECKSUM) |
| `docs/requirements/requirement-debian-cli-coding.md` | Debian CLI coding. Not this build (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | Debian curses build. Not this build (RQ-DEBIAN-BUILD-PAYLOAD) |
| `src/tn5250-cli` | The Windows build function |
| `docs/reviews/test-plan.md` | Proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

This host is not Git Bash. These rows are not a Windows compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-WGB-03 | Supported configure is `-G Ninja` or `-G "MinGW Makefiles"`, `Release`, and `CMAKE_PREFIX_PATH` of the UCRT64 prefix | todo |
| TP-WGB-04 | Build is `cmake --build --parallel` with `MSYS_NO_PATHCONV=1`, and does not run `cmake --install` or `./configure` | todo |
| TP-WGB-05 | Static `5250` links OpenSSL, `Ws2_32`, and `Winmm`. The three WIN32 executables link `5250` | todo |
| TP-WGB-06 | The GCC 14 source fixes are applied before configure and are not a new commit | todo |
| TP-WGB-08 | A build that does not produce `tn5250.exe` fails | todo |
| TP-WGB-09 | The five UCRT64 package names are the ones build installs | todo |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from RQ-WINDOWS-GIT-BASH 1.3.4. This file owns compilation, link, the UCRT64 package table, the shallow fetch, and the `opt/tn5250` copy. CLI coding moved to RQ-WINDOWS-GIT-BASH-CLI-CODING. |
| 2026-10-13 | Active 1.0.1 | The Debian curses build points at RQ-DEBIAN-CLI-CODING and RQ-DEBIAN-BUILD-PAYLOAD. This Windows build is unchanged. |

| 2026-10-13 | Active 1.0.2 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
