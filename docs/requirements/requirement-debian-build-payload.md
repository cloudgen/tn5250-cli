**file**: docs/requirements/requirement-debian-build-payload.md
**ID**: RQ-DEBIAN-BUILD-PAYLOAD
**Status**: Active (Version 1.0.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Debian build-payload requirement. It owns the compilation, link, and build of the Unix TN5250 programs on Debian 12 and Debian 13, and the `apt` package names those steps need.

How the ship unit detects those releases, calls `apt-get` through the sudo wrap, copies `tn5250-cli` into `~/.local/bin`, and launches the client belongs to `docs/requirements/requirement-debian-cli-coding.md`. This file does not restate that script.

### 1.1 Human-facing

**In one sentence:** On Debian 12 or 13, build compiles the curses `tn5250` with the system GCC, CMake, ncurses, and OpenSSL, and leaves that program under `~/.local/opt/tn5250`, not in `~/.local/bin`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose build run compiles the client | `tn5250-cli build` |
| The other role | The upstream TN5250 C sources | tag `v0.18.0` |
| Not this file | Detection and the `apt-get` call | `docs/requirements/requirement-debian-cli-coding.md` |

| Includes | Excludes |
|----------|----------|
| System GCC, CMake Release, ncurses, OpenSSL, the Debian package table, and the copy into `opt/tn5250` | The installer in `~/.local/bin`, Ubuntu's package versions, and the Windows GUI build |

| Surface | What you open | What for |
|---------|---------------|----------|
| `${HOME}/.local/opt/tn5250/tn5250` | the built client | a 5250 session |
| `tn5250-cli build` | the build command | compile, link, and copy |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client | The CLI requirement installs any missing package. This requirement says what a successful compile looks like | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the Debian payload build and of the Debian 12 and 13 package table. CLI coding stays on `docs/requirements/requirement-debian-cli-coding.md`. Another requirement **MUST NOT** move this table back into that CLI file.
2. The supported payload is the upstream Unix CMake build at the pinned ref: language C, CMake 3.12 or newer, the Debian `gcc` metapackage, ncurses, OpenSSL 3, a single-config Release build. It is not a distribution package named `tn5250`. Debian does not publish a current `tn5250` binary package for these releases.
3. The build **MUST** be native for the architecture of that Debian install. Cross-compilation is out of scope.
4. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`. It **MUST NOT** pass a Windows `CMAKE_PREFIX_PATH`, **MUST NOT** call `cygpath`, and **MUST NOT** set `MSYS_NO_PATHCONV`. System include and library paths are the Debian defaults.
5. CMake **MUST** be at least 3.12. The Debian packages that meet this are cmake 3.25.1 on bookworm and cmake 3.31.6 on trixie.
6. The compiler **MUST** be the native `gcc` metapackage: GCC 12 on bookworm, GCC 14 on trixie, with `libc6-dev` present so the headers exist.
7. The generator **MUST** be Ninja when the `ninja` binary from the `ninja-build` package is on `PATH`. Otherwise it **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, build **MUST** stop.
8. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass `--config`. It **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. It **MUST NOT** build the `win32/` programs. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
9. Build **MUST NOT** apply the Windows GCC 14 source fixes. `sslstream.c` **MUST** still have `int ioctlarg`. Build **MUST** apply the connect fix to `lib5250/telnetstr.c` and `lib5250/sslstream.c` before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `CONNECT-FIX` contains `addrinfo-1`. `HEAD` stays the upstream commit.
10. The static library target `5250` **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. It **MUST NOT** link `Ws2_32` or `Winmm`. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`. Upstream `find_package(OpenSSL)` is not `REQUIRED`. `libssl-dev` **MUST** still be present before configure. A configure without OpenSSL headers **MUST** stop.
11. The curses target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c` and **MUST** link `5250` and `${CURSES_LIBRARIES}`. It is a terminal program, not a `WIN32` executable. Missing ncurses **MUST** fail configure. `libncurses-dev` is bookworm 6.4 and trixie 6.5. `pkgconf` **MUST** be present so CMake can discover ncurses.
12. Debian provides `syslog.h`. The Debian arm passes syslog as required, so `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` **MUST** be built, and each links `5250`. A missing `xt5250` is not a failure. `xt5250` is an autotools script this CMake build does not produce.
13. If `tn5250` is missing after the build, build **MUST** stop with a non-zero status.
14. After a successful compile, build **MUST** copy `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` into `${TN5250_PREFIX}/opt/tn5250`, skipping anything under `CMakeFiles`. The names have no `.exe` suffix. The default `TN5250_PREFIX` is `${HOME}/.local`. Build **MUST NOT** copy these programs into `${TN5250_PREFIX}/bin` and **MUST NOT** install into `/usr`.
15. Build **MUST** write `REF`, `REVISION`, and `CONNECT-FIX` next to the programs. When `--force` is off, build **MUST** skip the compile only if the programs and all three stamps match. A payload without `CONNECT-FIX` **MUST** rebuild. A rebuild **MUST** remove the build directory before configure.
16. Build **MUST** obtain sources for the pinned ref with the same shallow fetch the Git Bash payload requirement uses. `git` **MUST** be present or build stops. The build tree **MUST** live in the user cache.
17. Build **MUST NOT** vendor `libncurses` or `libssl` into the install prefix, and **MUST NOT** copy Windows runtime DLLs. Those shared libraries come from the Debian packages already installed: `libncurses6`, and `libssl3` on bookworm or `libssl3t64` on trixie.
18. Before configure, the packages in the table **MUST** be present. The CLI coding requirement performs `apt-get` for a missing row. This file owns the names and the checks. When every check already passes, `apt-get` is not called.

| Package | Why it is in the build environment | What build checks |
|---------|------------------------------------|-------------------|
| `gcc` | The compiler. Bookworm GCC 12. Trixie GCC 14 | `gcc` runs |
| `libc6-dev` | C headers for that `gcc` | that `gcc` can compile a trivial C file |
| `cmake` | Configures the Release build. Bookworm 3.25.1. Trixie 3.31.6. Minimum 3.12 | `cmake` runs and reports at least 3.12 |
| `ninja-build` | Preferred generator. `make` remains acceptable | `ninja` runs, or `make` runs |
| `pkgconf` | The `pkg-config` command CMake uses for ncurses | `pkg-config` runs |
| `libncurses-dev` | Curses headers and the curses link. Bookworm 6.4. Trixie 6.5 | ncurses headers are found by CMake |
| `libssl-dev` | OpenSSL 3 headers for the 5250 stream | OpenSSL headers are found by CMake |
| `ncurses-base` | Terminfo for the curses client | terminfo data is present |
| `git` | Shallow fetch of the pinned ref | `git` runs |

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Upstream files | root `CMakeLists.txt`, `curses/CMakeLists.txt`, `lp5250d/CMakeLists.txt`, `lib5250/CMakeLists.txt`, `config-cmake.h.in` |
| Compiler | Package `gcc`. Bookworm GCC 12. Trixie GCC 14 |
| CMake | Bookworm `cmake` 3.25.1-1. Trixie `cmake` 3.31.6-2. Minimum 3.12. No `CMAKE_PREFIX_PATH` |
| Generator | `ninja` when present. Otherwise `-G "Unix Makefiles"` |
| OpenSSL runtime | `libssl3` on bookworm. `libssl3t64` on trixie. Not copied into the prefix |
| Install directory | `${TN5250_PREFIX:-${HOME}/.local}/opt/tn5250` |
| Not this directory | `${TN5250_PREFIX:-${HOME}/.local}/bin` holds `tn5250-cli` only |
| Source cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` |
| Build cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` |
| Not produced | `xt5250`, `tn5250.exe`, `lp5250d.exe`, `dftmap.exe` |

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

**Commands**

```bash
tn5250-cli build
tn5250-cli build --prefix "${HOME}/.local" --ref v0.18.0 --jobs 4
tn5250-cli build --force
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli` with no token does not compile. When this build has written `REF` and `REVISION`, the payload line is `tn5250 <ref> (<revision>)`. The wording of that pair is owned by `docs/requirements/requirement-shell-cli-interface.md`.

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not Debian. No Debian compile was run. The Debian arm passes syslog as required. The Windows GCC 14 patch is not applied on this arm. The connect fix is applied before configure.

An other-Linux host that auto-detects `apt-get` uses this name table. It does not become Debian. Ubuntu uses its own requirement for its release pairs. The `apt-get` argv is the same one the CLI coding requirement names.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): a build that did not produce `tn5250` is not success.
- **CIAO Principle 5 – SSOT**: the Debian package table and the link line have this file.
- **CIAO Principle 10 – Least privilege**: the payload is written under the user's prefix, not into `/usr`.
- **CIAO Principle 21 – Dual policies**: the rules stay portable. Debian package versions sit in this file.

## Under command line for normal user only

The compile runs as this login. `apt-get` is started by the CLI coding requirement through the sudo wrap. This file does not call Termux `pkg`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the supported link is the system OpenSSL and ncurses. No Windows libraries.
- **Intentional**: one CMake invocation and one Debian package table.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain. Bookworm and trixie share the package names.
- **Over-protect**: the Windows GCC 14 patch stays off. The connect fix stays on.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Move the package table or the link line back into the CLI coding requirement, or fold both files into one Debian requirement again.
- Copy the curses client into `~/.local/bin`.
- Replace this CMake build with autotools, `./configure`, or the Windows GUI programs.
- Apply the Windows GCC 14 patch, or link `Ws2_32` or `Winmm`.
- Pass `CMAKE_PREFIX_PATH`, `cygpath`, or `MSYS_NO_PATHCONV` on this build.
- Treat a missing `tn5250` as success.
- Claim `apt install tn5250` as the supported install. These Debian releases do not ship this upstream version.
- Drop `libssl-dev` or `libncurses-dev` from the supported link.
- Treat the four syslog programs as optional on Debian.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-debian-cli-coding.md` | Detection, the `apt-get` call, installer path, launch (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-shell-sudo-command.md` | The wrap that runs `apt-get` (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-ubuntu.md` | Ubuntu release pairs and Ubuntu package versions (RQ-UBUNTU) |
| `docs/requirements/requirement-other-linux.md` | Other Linux may use this `apt` name table. It does not own Debian 12 or 13 (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | The Unix build. The Debian arm forces family `apt` and requires the syslog programs |
| `docs/reviews/test-plan.md` | Proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

This host is not Debian. These rows are not a Debian compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-DEB-02 | Configure uses Ninja or Unix Makefiles, `Release`, and no Windows prefix or `MSYS_NO_PATHCONV` | todo |
| TP-DEB-03 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-DEB-04 | The curses `tn5250` links `5250` and ncurses. `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` are produced | todo |
| TP-DEB-05 | The Windows GCC 14 patch is not applied. The connect fix is | todo |
| TP-DEB-07 | A build without the curses `tn5250` fails | todo |
| TP-CLI-01 | `build`, `help`, `version`, and host launch are named here and in the command map | ran as a document check |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from RQ-DEBIAN 1.5.6. This file owns compilation, link, the Debian package table, and the `opt/tn5250` copy. CLI coding is RQ-DEBIAN-CLI-CODING. Debian build behavior is unchanged. No Debian compile was run. |

| 2026-10-13 | Active 1.0.1 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
