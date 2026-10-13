**file**: docs/requirements/requirement-macos-build-payload.md
**ID**: RQ-MACOS-BUILD-PAYLOAD
**Status**: Active (Version 1.0.1)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the macOS build-payload requirement. It owns the compilation, link, and build of the Unix TN5250 programs on macOS, and the Homebrew formulae those steps need.

How the ship unit detects Darwin, calls `brew`, copies `tn5250-cli` into `~/.local/bin`, and launches the client belongs to `docs/requirements/requirement-macos-cli-coding.md`. This file does not restate that script.

### 1.1 Human-facing

**In one sentence:** On macOS, build compiles the curses `tn5250` with CMake, ncurses, and OpenSSL, and leaves that program under `~/.local/opt/tn5250`, not in `~/.local/bin`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose build run compiles the client | `tn5250-cli build` |
| The other role | The upstream TN5250 C sources | tag `v0.18.0` |
| Not this file | Detection, the `brew` call, and the bashrc marker | `docs/requirements/requirement-macos-cli-coding.md` |

| Includes | Excludes |
|----------|----------|
| CMake Release, Apple clang as the `gcc` command, ncurses, OpenSSL 3, the formula table, and the copy into `opt/tn5250` | The installer in `~/.local/bin`, sudo, and the Windows GUI build |

| Surface | What you open | What for |
|---------|---------------|----------|
| `${HOME}/.local/opt/tn5250/tn5250` | the built client | a 5250 session |
| `tn5250-cli build` | the build command | compile, link, and copy |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client | The CLI requirement installs any missing formula. This requirement says what a successful compile looks like | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the macOS payload build and of the Homebrew formula table for this build. CLI coding stays on `docs/requirements/requirement-macos-cli-coding.md`. Another requirement **MUST NOT** move this table back into that CLI file, or fold both files into one macOS requirement.
2. The supported payload is the upstream Unix CMake build at the pinned ref recorded by `docs/requirements/requirement-debian-build-payload.md`: language C, CMake 3.12 or newer, the `gcc` command from the Xcode Command Line Tools, ncurses, OpenSSL 3, a single-config Release build. It is not `brew install tn5250`. That `gcc` command is Apple clang. The Homebrew formula `gcc` is GNU GCC and is **NOT** this compiler.
3. The build **MUST** be native for the architecture of that Mac. Cross-compilation is out of scope. Apple Silicon and Intel are each native on their own machine. This file does not pick one of them.
4. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`. The generator **MUST** be Ninja when `ninja` is on `PATH`. Otherwise it **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, the CLI requirement installs the `ninja` formula, and this build then uses Ninja. Configure **MUST NOT** call `cygpath` and **MUST NOT** set `MSYS_NO_PATHCONV`. The macOS arm exports `CMAKE_PREFIX_PATH` and `PKG_CONFIG_PATH` as a colon-separated list of `brew --prefix openssl@3`, `brew --prefix ncurses`, and `brew --prefix`. It **MUST NOT** pass that list as an unquoted `-DCMAKE_PREFIX_PATH` argument, because a semicolon would split the shared CMake command.
5. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass `--config`. It **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. It **MUST NOT** build the `win32/` programs. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
6. Build **MUST NOT** apply the Windows GCC 14 source fixes. `sslstream.c` **MUST** still have `int ioctlarg`. Build **MUST** apply the connect fix to `lib5250/telnetstr.c` and `lib5250/sslstream.c` before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `CONNECT-FIX` contains `addrinfo-1`. `HEAD` stays the upstream commit.
7. The static library target `5250` **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. It **MUST NOT** link `Ws2_32` or `Winmm`. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`. Upstream `find_package(OpenSSL)` is not `REQUIRED`. The `openssl@3` headers **MUST** still be present before configure. A configure without OpenSSL headers **MUST** stop.
8. The curses target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c` and **MUST** link `5250` and `${CURSES_LIBRARIES}`. Upstream `find_package(Curses REQUIRED)` needs the ncurses headers. A missing `xt5250` is not a failure.
9. The four syslog programs are optional on macOS. They **MUST** be copied when `/usr/include/syslog.h` exists. When that header is absent, a missing `lp5250d`, `scs2ascii`, `scs2pdf`, or `scs2ps` is not a failed build. A missing `tn5250` **MUST** fail.
10. After a successful compile, build **MUST** copy the produced programs into `${TN5250_PREFIX}/opt/tn5250`, skipping anything under `CMakeFiles`. The names have no `.exe` suffix. The default `TN5250_PREFIX` is `${HOME}/.local`. Build **MUST NOT** copy these programs into `${TN5250_PREFIX}/bin` and **MUST NOT** install into `/usr`.
11. Build **MUST** write `REF`, `REVISION`, and `CONNECT-FIX` next to the programs. When `--force` is off, build **MUST** skip the compile only if the programs and all three stamps match. A payload without `CONNECT-FIX` **MUST** be rebuilt.
12. Build **MUST NOT** vendor `libncurses` or `libssl` into the install prefix, and **MUST NOT** copy Windows runtime DLLs. Those shared libraries come from the Homebrew formulae already installed.
13. Before configure, the tools in the table **MUST** be present. The CLI coding requirement performs `brew install` for a missing formula row. This file owns the names and the checks. When every check already passes, `brew` is not called. `gcc` and the C headers are not formula rows.

| Formula | Why it is in the build environment | What build checks |
|---------|------------------------------------|-------------------|
| Command Line Tools `gcc` | Apple clang, under the name `gcc`. Not a Homebrew formula | `gcc` runs and can compile a trivial C file |
| `cmake` | Configures the Release build. CMake 3.12 or newer | `cmake` runs and reports at least 3.12 |
| `ninja` | Preferred generator. Installed when neither `ninja` nor `make` is on `PATH` | `ninja` runs, or `make` runs |
| `make` | Unix Makefiles when `ninja` is absent. Comes from the Command Line Tools, not from Homebrew | `make` runs, or `ninja` runs |
| `pkgconf` | The `pkg-config` command CMake uses for ncurses | `pkg-config` or `pkgconf` runs |
| `ncurses` | Curses headers, the curses link, and terminfo under `brew --prefix ncurses` | `ncurses.h` or `ncurses/ncurses.h` is found |
| `openssl@3` | OpenSSL 3 headers for the 5250 stream. Keg-only, under `brew --prefix openssl@3` | `openssl/ssl.h` is found |
| `git` | Shallow fetch of the pinned ref | `git` runs |

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Compiler | Command Line Tools `gcc` (Apple clang). Not Homebrew `gcc` |
| OpenSSL | Formula `openssl@3` |
| ncurses | Formula `ncurses` |
| Package config | Formula `pkgconf` |
| Generator | `ninja` when present. Otherwise `-G "Unix Makefiles"` |
| Prefix paths | `brew --prefix openssl@3`, `brew --prefix ncurses`, `brew --prefix` |
| Install directory | `${TN5250_PREFIX:-${HOME}/.local}/opt/tn5250` |
| Not this directory | `${TN5250_PREFIX:-${HOME}/.local}/bin` holds `tn5250-cli` only |
| Source cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` |
| Build cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` |
| Syslog programs | Optional. Copied when `/usr/include/syslog.h` exists |

**Supported link**

| Target | Links | Does not link |
|--------|-------|----------------|
| `5250` | `OpenSSL::Crypto`, `OpenSSL::SSL` | `Ws2_32`, `Winmm` |
| `tn5250` | `5250`, `${CURSES_LIBRARIES}` | a `WIN32` subsystem |

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not macOS. No macOS compile was run. The macOS arm passes syslog as optional. The Windows GCC 14 patch is not applied on this arm. The connect fix is applied before configure.

Homebrew on a Linux host is not this build. That host stays other Linux, Alpine, Debian, Ubuntu, or Termux, whichever requirement claims it.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): a build that did not produce `tn5250` is not success.
- **CIAO Principle 5 – SSOT**: the macOS formula table and the link line have this file.
- **CIAO Principle 10 – Least privilege**: the payload is written under the user's prefix, not into `/usr`.
- **CIAO Principle 21 – Dual policies**: the rules stay portable. The formula names sit in this file.

## Under command line for normal user only

The compile runs as this login. `brew` is started by the CLI coding requirement and does not use sudo. This file does not call Termux `pkg`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the supported link is Homebrew OpenSSL and ncurses. No Windows libraries.
- **Intentional**: one CMake invocation and one formula table.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain.
- **Over-protect**: the Windows GCC 14 patch stays off. The connect fix stays on. Homebrew `gcc` stays off.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Move the formula table or the link line back into the CLI coding requirement, or fold both files into one macOS requirement.
- Copy the curses client into `~/.local/bin`.
- Replace this CMake build with autotools, `./configure`, or the Windows GUI programs.
- Apply the Windows GCC 14 patch, or link `Ws2_32` or `Winmm`.
- Pass `cygpath` or `MSYS_NO_PATHCONV` on this build.
- Treat a missing `tn5250` as success.
- Claim `brew install tn5250` or `brew install gcc` as the supported install.
- Drop `openssl@3` or `ncurses` from the supported link.
- Treat the four syslog programs as required on macOS when `/usr/include/syslog.h` is absent.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-macos-cli-coding.md` | Detection, the `brew` call, installer path, launch (RQ-MACOS-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | The pinned ref this build uses. Not this formula table (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. This build does not use it (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | The Unix build. The macOS arm forces family `brew` and leaves syslog optional |
| `docs/reviews/test-plan.md` | Proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

This host is not macOS. These rows are not a macOS compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-MAC-03 | Configure uses Ninja or Unix Makefiles, `Release`, and the brew prefix list. No `MSYS_NO_PATHCONV` | todo |
| TP-MAC-04 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-MAC-05 | The curses `tn5250` links `5250` and ncurses. The four syslog programs are copied when `/usr/include/syslog.h` exists | todo |
| TP-MAC-07 | The Windows GCC 14 patch is not applied. The connect fix is | todo |
| TP-MAC-08 | A build without the curses `tn5250` fails | todo |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | macOS leaves the refused-host path. This file owns compilation, link, the Homebrew formula table, and the `opt/tn5250` copy. CLI coding is RQ-MACOS-CLI-CODING. No macOS compile was run. |

| 2026-10-13 | Active 1.0.1 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
