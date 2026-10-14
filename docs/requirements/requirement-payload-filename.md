**file**: docs/requirements/requirement-payload-filename.md
**ID**: RQ-PAYLOAD-FILENAME
**Status**: Active (Version 1.2.0)
**Project**: tn5250-cli
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file owns the published payload filename under `download/`, the copy that `build local` and `build global` write there, and the `setup` verb that downloads one of those files. A published file is the installed `tn5250` client, stored under the published name. The name has four parts: app name, architecture, C library, and C-library version, then the product version after a dot. A Windows file ends in `.exe`.

Compile, link, package names, and the copy into `${PREFIX}/opt/tn5250` stay on the platform payload requirements. `build` still compiles. `setup` does not. After a successful local or global install, this file's copy step writes the installed client into `download/`.

### 1.1 Human-facing

**In one sentence:** `tn5250-cli build local` and `tn5250-cli build global` copy the installed client into `download/` as `tn5250-<arch>-<clib>-<clib-version>.<app-version>`, and `tn5250-cli setup` downloads that file and saves it as `~/.local/bin/tn5250`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | The person who receives a prebuilt client | This Termux phone takes `tn5250-arm64-bionic-30.1.1.0` |
| The other role | The file stored in `download/` | `tn5250-arm64-bionic-30.1.1.0` |
| Not this file | `tn5250-cli build` and the copy under `opt/tn5250` | `docs/requirements/requirement-domain-tn5250.md` |

| Includes | Excludes |
|----------|----------|
| The filename grammar, how each part is collected, the C-library floor, the Windows `.exe`, the digest sibling, `download/index.txt`, the copy from a local or global build, and the `setup` save | The CMake invocation, the package table, and `TERMUX_VERSION` as a filename field |

| Surface | What you open | What for |
|---------|---------------|----------|
| `download/` | published payloads | the named files and `index.txt` |
| `download/index.txt` | the list raw.githubusercontent.com cannot provide | one filename per line |
| `${HOME}/.local/bin/tn5250` | the saved name | not the long filename |
| `tn5250-cli about` | diagnostics | `payload_arch` and `payload_clib` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Take a published client | Download the newest fitting file and save it under `~/.local/bin` | `tn5250-cli setup` |
| Publish the client you just built | Copy the installed client into `download/` under the published name | `tn5250-cli build local` |
| See what this machine is | Arch and C library, without downloading | `tn5250-cli about` |

## 2. Core Rules / Requirements (Mandatory)

1. This file is the only owner of the published payload filename, of the copy into `download/`, and of the `setup` download. Another requirement **MUST NOT** keep a second copy of the grammar. Platform payload requirements own compilation, link, and the copy into `${PREFIX}/opt/tn5250`. This file **MUST NOT** restate those. `build` **MUST NOT** be replaced by a download. `build` **MUST NOT** copy a published file into `~/.local/bin`. After a successful `build local` or `build global`, including when that client is already installed, `build` **MUST** copy the installed client into `download/` under the published name, write the sibling digest, and list the name in `download/index.txt`. The long name **MUST NOT** be saved onto `PATH`. `setup` remains the download. `build clean` **MUST NOT** remove `download/`.
2. A published payload file **MUST** live in `download/` at the repository root. `download/` **MUST NOT** be listed in `.gitignore`. These files **MUST NOT** be placed in `bin/`, `dist/`, `build/`, or `out/`.
3. `.gitignore` ignores `*.exe`. It **MUST** also contain `!download/*.exe` and `!download/*.exe.sha256`, or a Windows payload would stay untracked. A Linux or other non-Windows payload **MUST NOT** use a `.exe` suffix.
4. A non-Windows payload filename **MUST** be `tn5250-<arch>-<clib>-<clib-version>.<app-version>`. A Windows payload filename **MUST** be that name plus `.exe`. The app name, arch, and clib are separated by `-`. The clib-version and the app-version are dotted numbers joined by one extra dot. No field may add `.bin`, a compression suffix, a date, the upstream tag, the upstream commit, or `TERMUX_VERSION`.
5. `<arch>` **MUST** be one of `amd64`, `arm64`, `arm`, `386`, `ppc64le`, `riscv64`, `s390x`. The token `arm64` is 64-bit (`aarch64`). The token `arm` is 32-bit ARMv7 hard-float (`armv7l`). Soft-float ARM is not a token. `uname -m` **MUST** map as follows. An unmapped machine **MUST NOT** be given a guessed arch. `about` then shows `unknown` and **MUST NOT** exit.

| `uname -m` | `<arch>` |
|------------|----------|
| `x86_64` | `amd64` |
| `aarch64` | `arm64` |
| `armv7l` | `arm` |
| `i386`, `i686` | `386` |
| `ppc64le` | `ppc64le` |
| `riscv64` | `riscv64` |
| `s390x` | `s390x` |

6. `<clib>` **MUST** be `glibc`, `musl`, `uclibc`, `bionic`, or `ucrt`. Those spellings are closed. `muslc`, `ulibc`, `gnu`, `android`, and `msvcrt` are not tokens. `glibc`, `musl`, `uclibc`, `bionic`, and `ucrt` **MUST NOT** be treated as substitutes for one another.
7. `<clib-version>` **MUST** match the C library. `glibc` is `MAJOR.MINOR` (two numeric components). `musl` and `uclibc` are `MAJOR.MINOR.PATCH` (three numeric components). `bionic` is one integer, the Android API level. `ucrt` is the single token `10`. `<app-version>` **MUST** be `MAJOR.MINOR.PATCH`, three numeric components, the same semver as the ship unit `VERSION` line. Components are decimal integers with no leading letters and no distro patch suffix.
8. The `glibc` version in a published name **MUST** be the highest `GLIBC_x.y` symbol the file records, read from the binary (`objdump -T` or `readelf -V`). It **MUST NOT** be the `ldd --version` string of the build machine, and it **MUST NOT** include a packaging revision. Ubuntu `2.35-0ubuntu3` is `2.35`. The host ceiling used by `setup` is a different number: `getconf GNU_LIBC_VERSION`, or the first line of `ldd --version` when getconf has no answer, kept as `MAJOR.MINOR` only.
9. The `musl` or `uclibc` version in a published name **MUST** be the version of that C library on the machine that produced the file. Those libraries do not stamp glibc-style symbol versions. The host value is the first `MAJOR.MINOR.PATCH` in the first four lines of `ldd --version`. The `bionic` version in a published name **MUST** be the Android API floor the file was built for. That integer is the `androidN` suffix of `clang -dumpmachine` (or `cc -dumpmachine` when clang is absent), the same number as `__ANDROID_MIN_SDK_VERSION__`. It **MUST NOT** be `getprop ro.build.version.sdk`, and it **MUST NOT** be the Android release name. `clang -dM -E` **MUST NOT** be used: the first line that mentions the macro can be `#define __ANDROID_API__ __ANDROID_MIN_SDK_VERSION__`, whose last field is not a number. On the Termux host where this version of the law was written, clang's target is `aarch64-unknown-linux-android30`, so the floor is 30. That phone's own SDK is 35. The file keeps `30`. With product version `1.1.0` the name is `tn5250-arm64-bionic-30.1.1.0`.
10. The `ucrt` version **MUST** be `10`. That means a Windows 10 floor. The release marketed as Windows 11 still reports NT `10.0` and **MUST** use this same file. A second name with `ucrt-11` **MUST NOT** be published for that same program. The only Windows arch this repository builds is `amd64` (`mingw-w64-ucrt-x86_64`). A Windows payload for any other arch **MUST NOT** be committed until `docs/requirements/requirement-windows-git-bash-build-payload.md` builds that arch. The host accepts `ucrt` `10` only when `uname -s` contains `_NT-` and the NT major is 10 or newer.
11. glibc compatibility is one way. A file runs only when every `GLIBC_` symbol it records exists on the machine. A newer-named file **MUST NOT** be sent to an older glibc. An older-named file may run on a newer glibc. `bionic` uses the same direction with the Android API integer: a `bionic-30` file may run on API 30 and newer, and **MUST NOT** be sent to API 29 or older. `setup` chooses by mode. Mode `exact` (Termux when the compiler floor is known, and Windows `ucrt-10`) keeps only a clib-version equal to the host key. Mode `ceiling` (Termux with no compiler target, and glibc, musl, and uclibc) drops any published clib-version newer than the host, then keeps the greatest remaining clib-version, then the greatest app-version. Comparison is `ver_gt`, numeric per component, left to right. It **MUST NOT** round up. If no listed file fits, `setup` **MUST** stop non-zero and say `No published payload fits <arch> <clib>-<clib-version>. Next: tn5250-cli build`. It **MUST NOT** fetch a newer file. It **MUST NOT** invent a URL that `download/index.txt` does not list.
12. On `arm` and `386`, glibc 2.34 is a hard seam: libpthread, libdl, and librt moved into libc, and 64-bit `time_t` is a second ABI. Those two architectures **MUST NOT** publish two `glibc` files on opposite sides of 2.34. One file, entirely below 2.34 or entirely at or above 2.34, not both.
13. `raw.githubusercontent.com` cannot list a directory. Discovery **MUST** be `download/index.txt`. The channel base is `TN5250_PAYLOAD_BASE` when that variable is set, with one trailing slash removed, otherwise `https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/main/download`. `REPO_USER` defaults to `cloudgen`. `REPO_NAME` defaults to `tn5250-cli`. `TN5250_PAYLOAD_BASE` is an override for a test or a mirror. It is not a help flag. One payload filename per line. A blank line is skipped. A line whose first character is `#` is skipped. A trailing CR is stripped. A downloader **MUST NOT** invent a filename that the index does not list. The index **MUST** be committed in the same change as any payload file it names. Until the first payload is committed, the index may be absent. A missing index **MUST** stop with `Cannot read the payload index. Next: tn5250-cli build`.
14. Each payload file **MUST** have a sibling `<filename>.sha256`. The Windows sibling ends in `.exe.sha256`. The file **MUST** be one line whose first field is 64 hex digits, compared case-folded, and **MUST NOT** require the filename on that line, the same shape as `src/tn5250-cli.sha256`. A mismatch **MUST** stop with `Digest mismatch for <filename>. The download stopped.` A missing digest **MUST** stop with `Missing digest for <filename>. The download stopped.` This rule does not change the script companion in `docs/requirements/requirement-shell-automatic-checksum.md`. A missing script companion still warns. A missing payload digest stops.
15. `setup` **MUST** save a non-Windows file as `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` and a Windows file as `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250.exe`. The long filename **MUST NOT** be left on `PATH`. The mode **MUST** be `0755`. The save **MUST** chmod, because a raw download does not keep the executable bit. The committed blob **MUST** be git mode `100755`. The save **MUST NOT** call sudo, `pkg`, `apt`, `apk`, `brew`, or `dnf`. It **MUST** create the `bin` directory as this user when that directory is missing. The saved program **MUST NOT** be named `tn5250-cli`. Human success **MUST** say `Saved <filename> as <path>`. JSON success **MUST** include `path`, `payload`, `payload_arch`, and `payload_clib` (`<clib>-<clib-version>`).
16. `setup -h` and `setup --help` **MUST** exit 0, print the channel, and **MUST NOT** fetch or compile. Any other token after `setup` **MUST** fail and name `tn5250-cli setup -h`. A machine with no payload key (macOS, an unmapped arch, a Termux phone whose SDK is missing, or a compiler floor newer than that SDK) **MUST** stop with `This machine has no published payload name. Next: tn5250-cli build`.
17. A published file **MUST** be a copy of the client `build` installed under `opt/tn5250` (`tn5250`, or `tn5250.exe` on Windows). It **MUST** keep that client's dynamic libraries. This law does not require a second, statically linked build. The glibc number in the name **MUST** still be the highest `GLIBC_` symbol in that copied file, as rule 8 says. The programs under `opt/tn5250` stay the install. The `download/` file is that same client under the published name. macOS has no name in this grammar: the install may succeed, and `download/` **MUST** stay unchanged. A machine other than macOS that has no published name **MUST** stop after the install and **MUST NOT** invent a filename.
18. macOS (libSystem) **MUST NOT** be given a name in this grammar. `setup` on macOS **MUST** stop and name `tn5250-cli build`. This file does not define a `libsystem` token. Termux **MUST** use `bionic`. It **MUST NOT** be given a `glibc`, `musl`, or `uclibc` file.
19. When a project includes a payload, `about` **MUST** show the arch and `<clib>-<clib-version>`. Human lines are `Payload arch:` and `Payload C library:`. JSON keys are `payload_arch` and `payload_clib`. On a host with no payload key, `payload_clib` is `unsupported` and `payload_arch` is the mapped token or `unknown`. `about` **MUST NOT** exit because the key failed. Human `about` **MUST** print `Termux version:` only when `TERMUX_VERSION` is set and not empty. JSON `about` **MUST** always include `termux_version`. When the variable is unset that value is an empty string.
20. Launch **MUST** prefer the saved file from rule 15 when it exists, then the program `build` copied under the payload directory. That preference is also named by `docs/requirements/requirement-domain-tn5250.md`. This file owns the save. It does not own the compile.

### 2.1 How the parts are collected

| Part | Collected from | Not this |
|------|----------------|----------|
| app name | the fixed token `tn5250` | `tn5250-cli`, the upstream tag |
| arch | `uname -m` through the table in rule 5 | a guessed name |
| clib | rule 18 and the host key below | a substitute library |
| clib-version, published file | rules 8, 9, and 10, read from the file or from the compiler that produced it | the phone SDK, a distro suffix, `ldd` for glibc |
| clib-version, this host | the host key below | rounding up |
| app-version | the ship unit `VERSION="MAJOR.MINOR.PATCH"` at the time the file is published | the upstream tag, a commit, `TERMUX_VERSION` |
| `TERMUX_VERSION` | the environment variable, unread and unparsed | a calculated value, a filename field |

Host key, printed as `arch clib clibver mode`:

1. Windows: clib `ucrt`, version `10`, mode `exact`, only when rule 10's NT check passes. Otherwise the key fails.
2. Termux, which means `TERMUX_VERSION` is set and not empty, and this check wins over glibc because `uname -s` is `Linux`. Clib is `bionic`. The phone SDK is the leading digits of `getprop ro.build.version.sdk`. If that property is missing, the key fails. The compiler floor is the integer after `-android` in `clang -dumpmachine`, else `cc -dumpmachine`. If that floor is newer than the phone SDK, the key fails. If the floor exists, the version is the floor and the mode is `exact`. If no compiler target exists, the version is the phone SDK and the mode is `ceiling`.
3. macOS and any other unrecognized platform: the key fails.
4. Otherwise the first four lines of `ldd --version` are read. `musl` selects `musl`. `uClibc` or `uclibc` selects `uclibc`. Anything else selects `glibc`. The version is rule 8 or rule 9. The mode is `ceiling`.

`TERMUX_VERSION` is not calculated. The product reads it. It is not part of the filename. Detection that this variable means Termux stays on `docs/requirements/requirement-termux-cli-coding.md`.

### 2.2 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Directory | `download/` |
| Linux shape | `tn5250-<arch>-<clib>-<clib-version>.<app-version>` |
| Windows shape | that name plus `.exe` |
| App version now | `1.2.0` |
| Channel | `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/download/<filename>` |
| Override | `TN5250_PAYLOAD_BASE` |
| Index | `download/index.txt` |
| Digest | `<filename>.sha256`, one bare hex line |
| Linux save | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250` |
| Windows save | `${TN5250_PREFIX:-${HOME}/.local}/bin/tn5250.exe` |
| Not this path | `${TN5250_PREFIX:-${HOME}/.local}/opt/tn5250` remains the `build` copy |
| This Termux name | `tn5250-arm64-bionic-30.1.1.0` |
| Command | `setup` downloads. `build local` and `build global` compile, then copy into `download/` |

| File | When it is the one to save |
|------|----------------------------|
| `tn5250-amd64-glibc-2.34.1.2.0` | The file committed with product version 1.2.0. Highest `GLIBC_` symbol in that copy is 2.34. Host glibc may be newer. `setup` on a glibc ceiling at or above 2.34 may select it |
| `tn5250-amd64-glibc-2.35.1.1.0` | Grammar example. Host arch `amd64`, glibc 2.35 or newer, and no higher fitting `glibc` line is listed. Refused on glibc 2.34. Not committed |
| `tn5250-amd64-musl-1.2.5.1.1.0` | Host arch `amd64` and musl 1.2.5 or newer. Not a glibc substitute |
| `tn5250-arm64-bionic-30.1.1.0` | Termux, arch `arm64`, compiler floor 30. Exact match. Not the phone SDK 35. Not a glibc file |
| `tn5250-amd64-ucrt-10.1.1.0.exe` | Git Bash on `x86_64`, Windows 10 or the release called Windows 11 |

The committed payload with this version of the law is `download/tn5250-amd64-glibc-2.34.1.2.0`, its sibling `.sha256`, and the matching line in `download/index.txt`. The other names in the table are the grammar. They are not a claim that those bytes exist.

### 2.3 Example (name parts in `/bin/sh`)

```sh
# dash treats ^ inside [] as a literal. [!0-9] means not a digit.
tn5250_glibc_version() {
    _maj=${_line%%.*}
    _maj=${_maj##*[!0-9]}
    _min=${_line#*.}
    _min=${_min%%[!0-9]*}
    printf '%s\n' "${_maj}.${_min}"
}

# Published glibc number: highest GLIBC_x.y in the file, not the host ceiling.
# App version is the ship unit VERSION line.
# printf 'tn5250-%s-glibc-%s.%s\n' "${arch}" "${floor}" "${VERSION}"
```

## Under command line for normal user only

Saving a published payload does not raise privilege.

**This requirement:** `setup` writes under the prefix as this login. It does not call sudo, apt, dnf, apk, brew, or Termux pkg.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: a newer glibc file is not sent to an older machine.
- **Intentional**: one grammar. The product version is a separate dotted field. Termux is `bionic` plus the compiler floor.
- **Anti-fragile**: no fitting line in the index means `build`, not a guessed URL.
- **Over-protect**: `TERMUX_VERSION` is shown and is not part of the name.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

- Publish one glibc file as if it ran on every glibc.
- Round a C-library version up to a newer published file.
- Publish two `arm` or `386` glibc files on opposite sides of 2.34.
- Drop `.exe` from a Windows payload, or add `.exe` to a Linux payload.
- Let `*.exe` in `.gitignore` hide `download/*.exe`.
- Store these files in `bin/`, `dist/`, `build/`, or `out/`.
- Save the long filename onto `PATH`, or name the saved program `tn5250-cli`.
- Put the upstream tag, the commit, or `TERMUX_VERSION` in the filename.
- Make `setup` compile, or make `build` download.
- Spell the tokens `muslc`, `ulibc`, or `android`.
- Name a Termux file with the phone's SDK, or with the Android release, instead of the compiler's API floor.
- Read that floor with `clang -dM -E`.
- Give a Termux host a `glibc`, `musl`, or `uclibc` file.
- Leave the named file out of `download/` after a successful local or global build when the checkout is known.
- Treat `[^0-9]` as not-a-digit in `/bin/sh`. Inside `[]`, dash treats `^` as a literal. The negation is `[!0-9]`.
- Invent a macOS filename.
- Build a second, statically linked client when this law says to copy the installed client.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-domain-tn5250.md` | `build` and host launch (RQ-DOMAIN-TN5250) |
| `docs/requirements/requirement-shell-cli-interface.md` | `setup` is a named verb (RQ-SHELL-CLI-INTERFACE) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Script companion. Payload digests are this file (RQ-SHELL-AUTOMATIC-CHECKSUM) |
| `docs/requirements/requirement-windows-git-bash-build-payload.md` | UCRT64 compile. The published `.exe` is not that `opt/tn5250` copy (RQ-WINDOWS-GIT-BASH-BUILD-PAYLOAD) |
| `docs/requirements/requirement-termux-cli-coding.md` | Termux detection is `TERMUX_VERSION` (RQ-TERMUX-CLI-CODING) |
| `docs/requirements/requirement-termux-build-payload.md` | Termux compile. The published `bionic` file is not that `opt/tn5250` copy (RQ-TERMUX-BUILD-PAYLOAD) |
| `.gitignore` | `download/` stays tracked. `!download/*.exe` and `!download/*.exe.sha256` keep the Windows names |
| `src/tn5250-cli.sha256` | The bare-hex shape a payload digest copies |
| `docs/reviews/test-plan.md` | Proof rows |

## Design-time verification

`download/tn5250-amd64-glibc-2.34.1.2.0` is committed. The save proof uses a `file://` index. It does not compile.

| TP-ID | Proves | Status |
|-------|--------|--------|
| TP-PAY-01 | This file states `tn5250-<arch>-<clib>-<clib-version>.<app-version>`, the glibc floor, Termux `bionic`, and `.exe` only on Windows | ran as a document check on 2026-10-13 |
| TP-PAY-04 | This Termux host's key is `arm64` and `bionic-30`. `about` shows both, and `termux_version` | ran on 2026-10-13. `uname -m` is `aarch64`. clang's target is `aarch64-unknown-linux-android30`. `getprop ro.build.version.sdk` is 35. `TERMUX_VERSION` is `googleplay.2026.10.09` |
| TP-PAY-05 | `setup` with a `file://` index saves the newest app-version for this arch and C library, skips a newer clib-version, mode 0755, and a bad digest stops | ran on 2026-10-13. `tests/payload-setup.sh`. The index listed `bionic-99`. Setup saved `bionic-30` at app-version 1.1.0. No network. No compile |
| TP-PAY-02 | A host older than every listed file of its arch and clib is not given a newer file | exact `bionic` covered by TP-PAY-05: `bionic-99` was listed and was not saved. A glibc ceiling host was not run |
| TP-PAY-03 | `.gitignore` does not ignore `download/` and re-includes `download/*.exe` | ran as a source read on 2026-10-13 |
| TP-PAY-06 | The committed Ubuntu file is `tn5250-amd64-glibc-2.34.1.2.0`, mode `0755`, one bare sha256 line, and a matching `index.txt` line. The glibc number is the highest `GLIBC_` symbol, not the host ceiling | ran on 2026-10-14. `about` reports the host ceiling `glibc-2.39`. The copied file's highest symbol is `GLIBC_2.34` |

Proof home: `docs/reviews/test-plan.md`.

## Terminologies

### Payload filename

**Definition:** A payload filename is the stored name of one prebuilt tn5250 client under `download/`. It names the architecture, the C library, the oldest library version that can load the file, and the product version. On Windows the same name ends in `.exe`. The name on `PATH` after `setup` is `tn5250` or `tn5250.exe`, not this long name.

**Human daily-life explanation:** The payload filename is the label on the box. The last dotted number is which edition of the tool. The library number is which shelf it fits. A newer shelf can hold an older box. An older shelf cannot hold a newer box.

**Daily-life example:** `tn5250-amd64-glibc-2.34.1.2.0` is the committed box. It fits a machine whose glibc is 2.34 or newer. `tn5250-arm64-bionic-30.1.1.0` is the grammar for this Termux phone because the file would be built for API 30. `tn5250-amd64-ucrt-10.1.1.0.exe` is the Windows grammar.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-13 | Active 1.0.0 | Filename law for `download/`. glibc versions compare as a floor. Windows ends in `.exe`. No save command. No payload bytes committed. |
| 2026-10-13 | Active 1.0.1 | Termux is `bionic`. This host's name is `tn5250-arm64-bionic-30`: arch `arm64`, API floor 30 from clang, not the phone SDK 35. macOS still has no token. |
| 2026-10-13 | Active 1.1.0 | The name gains `.<app-version>`. `setup` downloads the newest fitting file from the raw usercontent channel and saves `~/.local/bin/tn5250`. `about` shows arch and `<clib>-<clib-version>`. `TERMUX_VERSION` is shown and is not part of the name. |
| 2026-10-14 | Active 1.2.0 | `build local` and `build global` copy the installed client into `download/` under the published name, with a sibling digest and an index line. The copy keeps the client's dynamic libraries. The glibc number stays the highest `GLIBC_` symbol. `/bin/sh` digit negation is `[!0-9]`. The committed file is `tn5250-amd64-glibc-2.34.1.2.0`. |

**Last Updated**: 2026-10-14
**Owner**: unassigned
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
