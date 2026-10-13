**file**: docs/requirements/requirement-termux-build-payload.md
**ID**: RQ-TERMUX-BUILD-PAYLOAD
**Status**: Active (Version 1.0.3)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Termux build-payload requirement. It owns the compilation, link, and build of the Unix TN5250 programs on Termux, and the named `pkg` packages those steps need.

How the ship unit detects Termux, calls `pkg`, copies `tn5250-cli` into `~/.local/bin`, and edits `~/.bashrc` belongs to `docs/requirements/requirement-termux-cli-coding.md`. This file does not restate that script. Alpine compilation and the `apk` package table belong to `docs/requirements/requirement-alpine-build-payload.md`. This file does not own them.

### 1.1 Human-facing

**In one sentence:** On Termux, build compiles the curses `tn5250` with CMake, ncurses, and OpenSSL, and leaves that program under `~/.local/opt/tn5250`, not in `~/.local/bin`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose build run compiles the client | `tn5250-cli build` |
| The other role | The upstream TN5250 C sources | tag `v0.18.0` |
| Not this file | Detection, the `pkg` call, and the bashrc marker | `docs/requirements/requirement-termux-cli-coding.md` |

| Includes | Excludes |
|----------|----------|
| CMake Release, the `clang` package as `gcc`, ncurses, OpenSSL, the package table, and the copy into `opt/tn5250` | The installer binary in `~/.local/bin`, sudo, and the Windows GUI build |

| Surface | What you open | What for |
|---------|---------------|----------|
| `${HOME}/.local/opt/tn5250/tn5250` | the built client | a 5250 session |
| `tn5250-cli build` | the build command | compile, link, and copy |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client | The CLI requirement installs any missing package. This requirement says what a successful compile looks like | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the Termux payload build. CLI coding stays on `docs/requirements/requirement-termux-cli-coding.md`.
2. The supported payload is the upstream Unix CMake build at the pinned ref recorded by `docs/requirements/requirement-debian-build-payload.md`: language C, CMake 3.12 or newer, the `gcc` command provided by the Termux `clang` package, ncurses, OpenSSL, a single-config Release build. Termux does not publish `pkg install tn5250` as the supported install.
3. When `TERMUX_VERSION` is set and `PREFIX` is empty, the userspace prefix **MUST** be `/data/data/com.termux/files/usr`. Headers, libraries, and terminfo are read under that prefix. `/usr/include` is not the Termux header root. `PREFIX` is not `TN5250_PREFIX`.
4. Configure **MUST** set the source directory, the build directory, `-DCMAKE_BUILD_TYPE=Release`, and `-DCMAKE_PREFIX_PATH` to the Termux userspace prefix. The generator **MUST** be Ninja when `ninja` is on `PATH`. Otherwise it **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, the CLI requirement installs `make`, and this build then uses `Unix Makefiles`.
5. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass `--config`. It **MUST NOT** call `cygpath` or set `MSYS_NO_PATHCONV`. It **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. It **MUST NOT** build the `win32/` programs.
6. Build **MUST NOT** apply the Windows GCC 14 source fixes. `sslstream.c` **MUST** still have `int ioctlarg`. Build **MUST** apply the connect fix before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `CONNECT-FIX` contains `addrinfo-1`.
7. The static library target `5250` **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. It **MUST NOT** link `Ws2_32` or `Winmm`. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
8. The curses target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c` and **MUST** link `5250` and `${CURSES_LIBRARIES}`. When `${PREFIX}/include/syslog.h` exists, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` **MUST** also be built. A missing `xt5250` is not a failure.
9. If `tn5250` is missing after the build, build **MUST** stop with a non-zero status.
10. After a successful compile, build **MUST** copy `tn5250` into `${TN5250_PREFIX}/opt/tn5250`, and **MUST** copy the four syslog programs when they were produced. The names have no `.exe` suffix. The default `TN5250_PREFIX` is `${HOME}/.local`. Build **MUST NOT** copy these programs into `${TN5250_PREFIX}/bin` and **MUST NOT** replace the Termux userspace prefix.
11. Build **MUST** write `REF`, `REVISION`, and `CONNECT-FIX` next to the programs. When `--force` is off, build **MUST** skip the compile only if the programs and all three stamps match.
12. Build **MUST NOT** vendor `libncurses` or `libssl` into the install prefix. Those libraries come from the Termux packages.
13. Before configure, the packages in the table **MUST** be present. The CLI coding requirement performs `pkg install -y` for a missing row. This file owns the names and the checks. When every check already passes, `pkg` is not called.

| Package | Why it is in the build environment | What build checks |
|---------|------------------------------------|-------------------|
| `clang` | Provides the `gcc` command and the C headers | `gcc` runs and can compile a trivial C file |
| `cmake` | Configures the Release build. CMake 3.12 or newer | `cmake` runs and reports at least 3.12 |
| `make` | Unix Makefiles generator when `ninja` is absent | `make` or `ninja` runs |
| `ninja` | Optional. Preferred generator when the binary is already on `PATH` | `ninja` runs, or `make` runs |
| `pkg-config` | Lets CMake discover ncurses | `pkg-config` runs |
| `ncurses` | Curses headers, the curses link, and terminfo | `${PREFIX}/include/ncurses.h` or `ncurses/ncurses.h`, and `${PREFIX}/share/terminfo` |
| `openssl` | TLS link for the 5250 stream | `${PREFIX}/include/openssl/ssl.h` |
| `git` | Shallow fetch of the pinned ref | `git` runs |

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Userspace prefix | `${PREFIX}`. When empty, `/data/data/com.termux/files/usr` |
| Compiler | Package `clang`. The `gcc` command is that Clang |
| CMake | Package `cmake`. Minimum 3.12 |
| Generator | `ninja` when present. Otherwise `-G "Unix Makefiles"` |
| Install directory | `${TN5250_PREFIX:-${HOME}/.local}/opt/tn5250` |
| Not this directory | `${TN5250_PREFIX:-${HOME}/.local}/bin` holds `tn5250-cli` only |
| Source cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/src` |
| Build cache | `${XDG_CACHE_HOME:-${HOME}/.cache}/tn5250/build` |

**Supported CMake invocation**

```text
cmake -G "Unix Makefiles" -S <src> -B <build> -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${PREFIX}
cmake --build <build> --parallel <jobs>
```

When `ninja` is on `PATH`, `-G "Unix Makefiles"` is replaced by `-G Ninja`.

| Target | Kind | Link line |
|--------|------|-----------|
| `5250` | static library | `OpenSSL::Crypto` and `OpenSSL::SSL`. No `Ws2_32`. No `Winmm` |
| `tn5250` | curses executable | `5250` and `${CURSES_LIBRARIES}` |
| `lp5250d`, `scs2ascii`, `scs2pdf`, `scs2ps` | executables when `${PREFIX}/include/syslog.h` exists | `5250` |

### 2.2 Current script behavior

On 2026-10-13 this Termux host ran `tn5250-cli build`. CMake used Unix Makefiles and `Release` because `ninja` was not on `PATH`. The C compiler was Clang 21.1.8. `CMAKE_PREFIX_PATH` was the Termux userspace prefix. OpenSSL 3.6.3 and ncurses were found. The install copied `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` under `~/.local/opt/tn5250`, with `REF` `v0.18.0`, `REVISION` `cd5980177b9468763bcaa669bf5cacbe7de5ec63`, and `CONNECT-FIX` `addrinfo-1`. `sslstream.c` still has `int ioctlarg`. The curses link line is `lib5250.a`, ncurses, form, `libssl`, and `libcrypto`. `Ws2_32` and `Winmm` are absent. A second build did not rebuild. A later session to `pub400.com` port 23 painted the IBM i 7.5 sign-on screen. The operator's account was submitted. The host answered `CPF1120` and did not show the Main Menu. Port 992 refused the connection.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): a build that did not produce `tn5250` is not success.
- **CIAO Principle 5 – SSOT**: the package table and the link line have this file.
- **CIAO Principle 10 – Least privilege**: the payload is not written to `/usr` or into the Termux userspace prefix.

## Under command line for normal user only

The compile runs as this login. Package install is the CLI coding requirement's `pkg` call, not sudo.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the Termux userspace prefix and the install prefix stay different names.
- **Intentional**: one CMake invocation and one package table.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain.
- **Over-protect**: the Windows patch and the Windows libraries stay off this build.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Move the package table or the link line back into the CLI coding requirement.
- Copy the curses client into `~/.local/bin`.
- Build the Windows GUI programs, apply the Windows GCC 14 patch, or link `Ws2_32` and `Winmm`.
- Replace this CMake build with `autogen.sh` and `./configure`.
- Treat `pkg install tn5250` as the supported install.
- Probe headers only under `/usr/include` on Termux.
- Treat the Alpine `apk` package table as this file's package table.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-termux-cli-coding.md` | Detection, `pkg`, installer path, bashrc marker (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-debian-cli-coding.md` | Debian CLI coding. Not this build (RQ-DEBIAN-CLI-CODING) |
| `docs/requirements/requirement-debian-build-payload.md` | Debian payload. Same pinned ref. Different packages (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-alpine-build-payload.md` | Alpine build and the `apk` names. Not this table (RQ-ALPINE-BUILD-PAYLOAD) |
| `docs/requirements/requirement-shell-sudo-command.md` | The sudo wrap. This build does not use it (RQ-SHELL-SUDO-COMMAND) |
| `src/tn5250-cli` | The Unix build function the Termux arm calls |
| `docs/reviews/test-plan.md` | Proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-TMX-03 | Configure is Ninja or Unix Makefiles, `Release`, with the Termux `CMAKE_PREFIX_PATH`, and without `MSYS_NO_PATHCONV` | ran. Unix Makefiles and `Release`. Ninja was absent |
| TP-TMX-04 | Static `5250` links OpenSSL and does not link Ws2_32 or Winmm. The curses `tn5250` links ncurses | ran. `ldd` shows `libncursesw`, `libformw`, `libssl.so.3`, and `libcrypto.so.3` |
| TP-TMX-05 | The Windows GCC 14 patch is not applied. The connect fix is applied | ran. `int ioctlarg` remains. `CONNECT-FIX` is `addrinfo-1` |
| TP-TMX-08 | The built client opens a session on a reachable IBM i host | ran. `pub400.com` port 23 painted the sign-on screen. The host answered `CPF1120` |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split from the single Termux requirement. This file owns compilation, link, the package table, and the `opt/tn5250` copy. CLI coding moved to RQ-TERMUX-CLI-CODING. |
| 2026-10-13 | Active 1.0.1 | Alpine's payload is RQ-ALPINE-BUILD-PAYLOAD. This Termux package table is unchanged. |
| 2026-10-13 | Active 1.0.2 | Debian's payload is RQ-DEBIAN-BUILD-PAYLOAD. Debian CLI coding is RQ-DEBIAN-CLI-CODING. This Termux package table is unchanged. |

| 2026-10-13 | Active 1.0.3 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
