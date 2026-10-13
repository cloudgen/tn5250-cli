**file**: docs/requirements/requirement-alpine-build-payload.md
**ID**: RQ-ALPINE-BUILD-PAYLOAD
**Status**: Active (Version 1.0.2)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This is the Alpine build-payload requirement. It owns the compilation, link, and build of the Unix TN5250 programs on Alpine Linux, and the `apk` package names those steps need.

How the ship unit detects Alpine, calls `apk` through the sudo wrap, copies `tn5250-cli` into `~/.local/bin`, and launches the client belongs to `docs/requirements/requirement-alpine-cli-coding.md`. This file does not restate that script.

### 1.1 Human-facing

**In one sentence:** On Alpine, build compiles the curses `tn5250` with the system GCC, CMake, ncurses, and OpenSSL, and leaves that program under `~/.local/opt/tn5250`, not in `~/.local/bin`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person whose build run compiles the client | `tn5250-cli build` |
| The other role | The upstream TN5250 C sources | tag `v0.18.0` |
| Not this file | Detection and the `apk` call | `docs/requirements/requirement-alpine-cli-coding.md` |

| Includes | Excludes |
|----------|----------|
| System GCC from `build-base`, CMake Release, ncurses, OpenSSL, the `apk` package table, and the copy into `opt/tn5250` | The installer in `~/.local/bin`, Termux `pkg`, and the Windows GUI build |

| Surface | What you open | What for |
|---------|---------------|----------|
| `${HOME}/.local/opt/tn5250/tn5250` | the built client | a 5250 session |
| `tn5250-cli build` | the build command | compile, link, and copy |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Build the client | The CLI requirement installs any missing package. This requirement says what a successful compile looks like | `tn5250-cli build` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the Alpine payload build and of the `apk` package names. CLI coding stays on `docs/requirements/requirement-alpine-cli-coding.md`. Another requirement **MUST NOT** keep a second copy of this table.
2. The supported payload is the upstream Unix CMake build at the pinned ref recorded by `docs/requirements/requirement-debian-build-payload.md`: language C, CMake 3.12 or newer, the system `gcc` from package `build-base`, ncurses, OpenSSL, a single-config Release build. It is not a distribution package named `tn5250`.
3. Configure **MUST** set the source directory, the build directory, and `-DCMAKE_BUILD_TYPE=Release`. It **MUST NOT** pass a Windows `CMAKE_PREFIX_PATH`, **MUST NOT** call `cygpath`, and **MUST NOT** set `MSYS_NO_PATHCONV`. System include and library paths are the Alpine defaults. The C library is the one `build-base` provides. This file does not add a musl-specific CMake flag.
4. The generator **MUST** be Ninja when `ninja` is on `PATH`. Otherwise it **MUST** be `Unix Makefiles` when `make` is on `PATH`. If neither exists, the CLI requirement installs `ninja`, and this build then uses Ninja.
5. The build step **MUST** be `cmake --build <build> --parallel <jobs>`. It **MUST NOT** pass `--config`. It **MUST NOT** run `autogen.sh`, `./configure`, or `cmake --install`. It **MUST NOT** build the `win32/` programs. `<jobs>` **MUST** be a positive integer. The default is `nproc` when that command works, otherwise 4.
6. Build **MUST NOT** apply the Windows GCC 14 source fixes. `sslstream.c` **MUST** still have `int ioctlarg`. Build **MUST** apply the connect fix before configure. That fix initializes the `addrinfo` pointer and does not call `freeaddrinfo` when `getaddrinfo` fails. `CONNECT-FIX` contains `addrinfo-1`. `HEAD` stays the upstream commit.
7. The static library target `5250` **MUST** link `OpenSSL::Crypto` and `OpenSSL::SSL`. It **MUST NOT** link `Ws2_32` or `Winmm`. The generated config **MUST** define `HAVE_LIBSSL` and `HAVE_LIBCRYPTO`.
8. The curses target `tn5250` **MUST** be built from `curses/cursesterm.c` and `curses/tn5250.c` and **MUST** link `5250` and `${CURSES_LIBRARIES}`. When `/usr/include/syslog.h` exists, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` **MUST** also be built. When that header is absent, a missing one of those four is not a failed build. A missing `xt5250` is not a failure.
9. If `tn5250` is missing after the build, build **MUST** stop with a non-zero status.
10. After a successful compile, build **MUST** copy `tn5250` into `${TN5250_PREFIX}/opt/tn5250`, and **MUST** copy the four syslog programs when they were produced, skipping anything under `CMakeFiles`. The names have no `.exe` suffix. The default `TN5250_PREFIX` is `${HOME}/.local`. Build **MUST NOT** copy these programs into `${TN5250_PREFIX}/bin` and **MUST NOT** install into `/usr`.
11. Build **MUST** write `REF`, `REVISION`, and `CONNECT-FIX` next to the programs. When `--force` is off, build **MUST** skip the compile only if the programs and all three stamps match. A payload without `CONNECT-FIX` **MUST** rebuild. A rebuild **MUST** remove the build directory before configure.
12. Build **MUST** obtain sources for the pinned ref with the same shallow fetch the Git Bash payload requirement uses. `git` **MUST** be present or build stops.
13. Build **MUST NOT** vendor `libncurses` or `libssl` into the install prefix. Those libraries come from the Alpine packages.
14. Before configure, the packages in the table **MUST** be present. The CLI coding requirement performs `apk add --no-cache` for a missing row. This file owns the names and the checks. When every check already passes, `apk` is not called.

| Package | Why it is in the build environment | What build checks |
|---------|------------------------------------|-------------------|
| `build-base` | The `gcc` command and the C headers | `gcc` runs and can compile a trivial C file |
| `cmake` | Configures the Release build. CMake 3.12 or newer | `cmake` runs and reports at least 3.12 |
| `ninja` | Preferred generator. Installed when neither `ninja` nor `make` is present | `ninja` runs, or `make` runs |
| `pkgconf` | The `pkg-config` command CMake uses for ncurses | `pkg-config` or `pkgconf` runs |
| `ncurses-dev` | Curses headers and the curses link | `/usr/include/ncurses.h` or `/usr/include/ncurses/ncurses.h` |
| `openssl-dev` | TLS headers for the 5250 stream | `/usr/include/openssl/ssl.h` |
| `ncurses-terminfo-base` | Terminfo for the curses client | `/usr/share/terminfo`, `/lib/terminfo`, `/usr/lib/terminfo`, or `/etc/terminfo` |
| `git` | Shallow fetch of the pinned ref | `git` runs |

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Upstream | `https://github.com/tn5250/tn5250.git` tag `v0.18.0`, commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63` |
| Compiler | Package `build-base`. The `gcc` command is that GCC |
| CMake | Package `cmake`. Minimum 3.12. No `CMAKE_PREFIX_PATH` |
| Generator | `ninja` when present. Otherwise `-G "Unix Makefiles"` |
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

### 2.2 Current script behavior

On 2026-10-13 this host was Termux, not Alpine. No Alpine compile was run. The Alpine arm passes syslog as optional, the same third argument other Linux uses: the four syslog programs are required only when `/usr/include/syslog.h` exists. The Windows GCC 14 patch is not applied on this arm.

A Linux host whose `ID` is not `alpine` can still select the `apk` family by auto-detect. Those hosts stay other Linux. They use this table. They do not become Alpine.

### 2.3 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): a build that did not produce `tn5250` is not success.
- **CIAO Principle 5 – SSOT**: the `apk` package table and the link line have this file.
- **CIAO Principle 10 – Least privilege**: the payload is written under the user's prefix, not into `/usr`.

## Under command line for normal user only

The compile runs as this login. `apk` is started by the CLI coding requirement through the sudo wrap. This file does not call Termux `pkg`.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: the supported link is the system OpenSSL and ncurses. No Windows libraries.
- **Intentional**: one CMake invocation and one `apk` table.
- **Anti-fragile**: Ninja is preferred and Unix Makefiles remain.
- **Over-protect**: the Windows GCC 14 patch stays off. The connect fix stays on.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Move the package table or the link line back into the CLI coding requirement or the other-Linux requirement.
- Copy the curses client into `~/.local/bin`.
- Replace this CMake build with autotools, `./configure`, or the Windows GUI programs.
- Apply the Windows GCC 14 patch, or link `Ws2_32` or `Winmm`.
- Pass `CMAKE_PREFIX_PATH`, `cygpath`, or `MSYS_NO_PATHCONV` on this build.
- Treat a missing `tn5250` as success.
- Claim `apk add tn5250` as the supported install.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-alpine-cli-coding.md` | Detection, the `apk` call, installer path, launch (RQ-ALPINE-CLI-CODING) |
| `docs/requirements/requirement-shell-sudo-command.md` | The wrap that runs `apk add --no-cache` (RQ-SHELL-SUDO-COMMAND) |
| `docs/requirements/requirement-debian-build-payload.md` | The pinned ref this build uses. Not this `apk` table (RQ-DEBIAN-BUILD-PAYLOAD) |
| `docs/requirements/requirement-other-linux.md` | Other Linux may use this `apk` table. It does not own `ID=alpine` (RQ-OTHER-LINUX) |
| `src/tn5250-cli` | The Unix build. The Alpine arm forces family `apk` |
| `docs/reviews/test-plan.md` | Proof rows |
| `https://github.com/tn5250/tn5250` | Upstream sources at tag `v0.18.0` |

## Design-time verification

This host is not Alpine. These rows are not an Alpine compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-ALP-03 | Configure uses Ninja or Unix Makefiles, `Release`, and no Windows prefix or `MSYS_NO_PATHCONV` | todo |
| TP-ALP-04 | Static `5250` links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-ALP-05 | The curses `tn5250` links `5250` and ncurses. The four syslog programs are produced when `syslog.h` exists | todo |
| TP-ALP-06 | The Windows GCC 14 patch is not applied. The connect fix is | todo |
| TP-ALP-08 | A build without the curses `tn5250` fails | todo |

Proof home: `docs/reviews/test-plan.md`.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Split out of the other-Linux catch-all. This file owns compilation, link, the `apk` package table, and the `opt/tn5250` copy. CLI coding is RQ-ALPINE-CLI-CODING. No Alpine compile was run on the authoring host. |
| 2026-10-13 | Active 1.0.1 | The pinned ref points at RQ-DEBIAN-BUILD-PAYLOAD. The `apk` table is unchanged. |

| 2026-10-13 | Active 1.0.2 | The payload verb is `build`, not `setup`. Setup and build are different. Menus, help, and next-steps say `build`. |
**Last Updated**: 2026-10-13
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
