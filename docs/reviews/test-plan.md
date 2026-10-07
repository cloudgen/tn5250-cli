# Test plan

The authoring host is Ubuntu 24.04 (noble). RQ-UBUNTU owns that host. A row marked ran was shown by a command or a source read on that host.

On 2026-10-07, `tn5250-cli setup` exited 0 on that host. The log did not contain `Installing missing compiler packages`, so sudo was not called. The toolchain was already present. Git cloned tag `v0.18.0` at commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63`. CMake configured with Ninja and `Release`, and identified the C compiler as GNU 13.3.0. OpenSSL 3.0.13 and ncurses were found. The build copied the curses `tn5250`, `lp5250d`, `scs2ascii`, `scs2pdf`, and `scs2ps` under the default prefix `${HOME}/.local`. Those files are owned by the user who started setup. The Windows GCC 14 patch was not applied. An earlier run of the previous script exited 1 with `setup needs Git Bash on Windows, or Debian 12 or 13.` That earlier observation stays on the rows that recorded it.

The missing-package sudo path was not run. Debian, other Linux, jammy, resolute, and Windows compiles were not run.

On 2026-10-07, version 1.0.2 setup on this Ubuntu host applied the connect fix, kept `HEAD` at `cd5980177b9468763bcaa669bf5cacbe7de5ec63`, and wrote `CONNECT-FIX` as `addrinfo-1`. `sslstream.c` still has `int ioctlarg`. A second setup skipped the compile. `menu` on a terminal drew the numbered list. A host token that does not resolve printed `Could not start session:` and did not receive signal 11.

Rows that say “prior smoke” were shown in the specialize run that copied the binary under a temporary home and printed about, help, and an already-installed empty argv. This alignment repeated the rows that say “repeated”.

| TP-ID | Requirement | What would prove it | Status |
|-------|-------------|---------------------|--------|
| TP-WGB-01 | RQ-WINDOWS-GIT-BASH | setup and launch stop outside the Git Bash `OSTYPE` and `uname -s` pair. version still prints the CLI line | ran on the previous script. `setup` and a host token exited 1 with the Git Bash or Debian message. That script printed `tn5250-cli version 0.1.0`. Not a Windows compile. The current script routes this Ubuntu host to the Ubuntu build and prints `tn5250-cli version 1.0.0` |
| TP-WGB-02 | RQ-WINDOWS-GIT-BASH | `tn5250-cli help` and `tn5250-cli setup -h` exit 0 without that detect. `setup --help` is the same case arm | ran on the authoring host. Both exit 0 |
| TP-WGB-03 | RQ-WINDOWS-GIT-BASH | Configure uses Ninja or MinGW Makefiles, `Release`, and `CMAKE_PREFIX_PATH` of the UCRT64 prefix | todo |
| TP-WGB-04 | RQ-WINDOWS-GIT-BASH | Build is `cmake --build --parallel` with `MSYS_NO_PATHCONV=1`, and does not install via autotools or `cmake --install` | todo |
| TP-WGB-05 | RQ-WINDOWS-GIT-BASH | Static `5250` links OpenSSL::SSL, OpenSSL::Crypto, Ws2_32, and Winmm; tn5250, lp5250d, and dftmap are WIN32 executables linked to `5250` | todo |
| TP-WGB-06 | RQ-WINDOWS-GIT-BASH | GCC 14 source fixes are applied before configure and `HEAD` stays the upstream commit | todo |
| TP-WGB-07 | RQ-WINDOWS-GIT-BASH | MSYS2 bash starts through `cmd.exe //c` with `MSYSTEM` and `CHERE_INVOKING` empty | todo |
| TP-WGB-08 | RQ-WINDOWS-GIT-BASH | A build without `tn5250.exe` fails | todo |
| TP-WGB-09 | RQ-WINDOWS-GIT-BASH | The five `mingw-w64-ucrt-x86_64-*` packages are the toolchain install set | todo |
| TP-CLI-01 | RQ-SHELL-CLI-INTERFACE, RQ-WINDOWS-GIT-BASH, RQ-DEBIAN, RQ-UBUNTU, and RQ-OTHER-LINUX | setup, help, version, and host launch are named in the command map and in each platform requirement | ran as a document check on the authoring host |
| TP-CLI-05 | RQ-SHELL-CLI-INTERFACE and RQ-DEBIAN | On Debian 12 or 13, setup follows the Debian build and does not start the Windows toolchain | todo |
| TP-CLI-06 | RQ-SHELL-CLI-INTERFACE and RQ-UBUNTU | On Ubuntu 22.04, 24.04, or 26.04, setup follows the Ubuntu build and does not start the Windows toolchain | ran for 24.04 noble. The log says `Installing tn5250 v0.18.0 for Ubuntu`. 22.04 and 26.04 were not executed |
| TP-CLI-07 | RQ-SHELL-CLI-INTERFACE and RQ-OTHER-LINUX | On other Linux, setup follows the other-Linux build and does not start the Windows toolchain | todo |
| TP-DEB-01 | RQ-DEBIAN | setup accepts Debian 12 and Debian 13. A non-Debian ID is not the Debian situation | todo |
| TP-DEB-02 | RQ-DEBIAN | Configure uses Ninja or Unix Makefiles, Release, and no Windows prefix or MSYS_NO_PATHCONV | todo |
| TP-DEB-03 | RQ-DEBIAN | Static 5250 links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-DEB-04 | RQ-DEBIAN | The curses tn5250 links 5250 and ncurses. lp5250d, scs2ascii, scs2pdf, and scs2ps are produced | todo |
| TP-DEB-05 | RQ-DEBIAN | The Windows GCC 14 patch is not applied on Debian | todo |
| TP-DEB-06 | RQ-DEBIAN | A missing compiler package is installed with the sudo wrap. Git and the compile stay with the invoking person. A present toolchain does not call sudo | todo. The present-toolchain observation was the Ubuntu run, not a Debian host |
| TP-DEB-07 | RQ-DEBIAN | A build without the curses tn5250 fails | todo |
| TP-UBU-01 | RQ-UBUNTU | setup accepts Ubuntu 22.04, 24.04, and 26.04, and does not treat ID_LIKE=ubuntu as those releases | ran for 24.04 noble. 22.04, 26.04, and an ID_LIKE-only host were not executed |
| TP-UBU-02 | RQ-UBUNTU | Configure uses Ninja or Unix Makefiles, Release, and no Windows prefix or MSYS_NO_PATHCONV | ran on the authoring host. Ninja and Release. MSYS_NO_PATHCONV was not set |
| TP-UBU-03 | RQ-UBUNTU | Static 5250 links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | ran on the authoring host. lib5250.a plus libssl and libcrypto on the curses link line. Ws2_32 and Winmm are absent |
| TP-UBU-04 | RQ-UBUNTU | The curses tn5250 links 5250 and ncurses. lp5250d, scs2ascii, scs2pdf, and scs2ps are produced | ran on the authoring host. ldd shows libncurses.so.6. All five programs were copied |
| TP-UBU-05 | RQ-UBUNTU | The Windows GCC 14 patch is not applied on Ubuntu | ran on the authoring host. sslstream.c still has int ioctlarg. The 1.0.2 setup still has int ioctlarg after the connect fix |
| TP-UBU-09 | RQ-UBUNTU and RQ-DOMAIN-TN5250 | The connect fix is applied, `CONNECT-FIX` is `addrinfo-1`, and a host name that does not resolve is not signal 11 | ran on the authoring host. Stamp `addrinfo-1`. `menu` drew the list. The client printed `Could not start session:` |
| TP-UBU-06 | RQ-UBUNTU | A missing compiler package is installed with the sudo wrap. Git and the compile stay with the invoking person. A present toolchain does not call sudo | ran for the present toolchain. The log did not contain `Installing missing compiler packages`. The missing-package path was not run |
| TP-UBU-07 | RQ-UBUNTU | A build without the curses tn5250 fails | todo |
| TP-UBU-08 | RQ-UBUNTU | A VERSION_ID / VERSION_CODENAME mismatch stops setup and does not fall through to other Linux | todo |
| TP-LNX-01 | RQ-OTHER-LINUX | setup accepts Linux that is not Debian 12 or 13, not Ubuntu 22.04, 24.04, or 26.04, and not Termux. macOS and Termux stop | todo |
| TP-LNX-02 | RQ-OTHER-LINUX | Configure uses Ninja or Unix Makefiles, Release, and no Windows prefix or MSYS_NO_PATHCONV | todo |
| TP-LNX-03 | RQ-OTHER-LINUX | Static 5250 links OpenSSL::SSL and OpenSSL::Crypto and does not link Ws2_32 or Winmm | todo |
| TP-LNX-04 | RQ-OTHER-LINUX | The curses tn5250 links 5250 and ncurses. The four syslog programs are produced when syslog.h exists | todo |
| TP-LNX-05 | RQ-OTHER-LINUX | The Windows GCC 14 patch is not applied | todo |
| TP-LNX-06 | RQ-OTHER-LINUX | A missing compiler package is installed with the sudo wrap when the package family is known. Git and the compile stay with the invoking person. A present toolchain does not call sudo. An unknown package manager stops and names the missing tools | todo |
| TP-LNX-07 | RQ-OTHER-LINUX | A build without the curses tn5250 fails | todo |
| TP-LNX-08 | RQ-OTHER-LINUX | A Debian or Ubuntu identity mismatch does not fall through to other Linux | todo |
| TP-CLI-02 | RQ-SHELL-CLI-INTERFACE and RQ-SHELL-CLI-ZERO-ARGUMENTS | Non-interactive empty argv does not configure CMake. When the binary is absent and `SCRIPT_URL` is explicitly empty, the status is non-zero | ran 2026-10-07. Exit 1. stderr: `SCRIPT_URL is empty. Refusing to download.` curl was not started |
| TP-CLI-03 | RQ-SHELL-CLI-INTERFACE | `setup -h` exits 0 without a platform check | ran, repeated. Exit 0 |
| TP-CLI-04 | RQ-SHELL-CLI-INTERFACE | An unknown setup option exits non-zero and mentions `tn5250-cli setup --help` | ran, repeated. `setup --bogus` exits 1 |
| TP-SH-01 | RQ-SHELL-SCRIPT-CODING | Ship unit shebang is `#!/bin/sh`. The script sets `-u` and does not set `-e` globally | ran. `sh -n` and `dash -n` exit 0. That is a syntax check, not a dash runtime run |
| TP-SH-02 | RQ-SHELL-SCRIPT-CODING | Executed sudo is only `util_sudo`, and only for the package install | ran as a source read after the sudo edit. The only executed `sudo "$@"` is inside `util_sudo`. An earlier source read, before that edit, found no executed sudo. The Ubuntu setup on 2026-10-07 did not call it |
| TP-SUDO-01 | RQ-SHELL-SUDO-COMMAND | The only executed sudo in the ship unit is inside `util_sudo`, and the package ensure is the caller | ran as a source read. `tn5250_run_elevated` is the caller |
| TP-SUDO-02 | RQ-SHELL-SUDO-COMMAND | When the compiler packages are already present, setup does not call sudo | ran on the authoring host. Ubuntu 24.04 setup exited 0 and did not print `Installing missing compiler packages` |
| TP-SUDO-03 | RQ-SHELL-SUDO-COMMAND | Git, cmake, and make are not arguments of `util_sudo` | ran as a source read. The elevated argv is apt-get, apk, dnf, pacman, or zypper |
| TP-SUDO-04 | RQ-SHELL-SUDO-COMMAND | `--json` or a closed terminal does not wait for a sudo password | todo |
| TP-SUDO-05 | RQ-SHELL-SUDO-COMMAND | One setup verb. A normal user continues. Root with nobody to return to stops before git. A sudo launch returns to that person before git | ran for the normal user, including a leftover `SUDO_USER` while not root: exit 0, existing install. `fakeroot` with no person: exit 1 before git. `fakeroot` with an unknown person: exit 1 before git. The `runuser` return was not executed |
| TP-SUDO-06 | RQ-SHELL-SUDO-COMMAND | Setup help names one command and does not tell the person to prefix setup with sudo. That text is the mixed elevated sudo model | source read of `tn5250_setup_help` after the 1.0.0 alignment. The three plain lines name one command, in-tool sudo for missing packages, and git and the compile staying with the user |
| TP-SH-03 | RQ-SHELL-SCRIPT-CODING | The coding-style requirement does not restate the CMake generator or the link libraries | ran as a document check |
| TP-ZERO-01 | RQ-SHELL-CLI-ZERO-ARGUMENTS | Already installed non-interactive empty argv exits 0 and does not configure CMake | ran on the authoring host. Temporary home, installed copy, exit 0, `already installed`. curl was not started |
| TP-ZERO-02 | RQ-SHELL-CLI-ZERO-ARGUMENTS | Not installed, explicit empty `SCRIPT_URL`, non-interactive empty argv exits non-zero and does not call curl | ran 2026-10-07. Same command as TP-CLI-02 |
| TP-ZERO-03 | RQ-SHELL-CLI-ZERO-ARGUMENTS and RQ-SHELL-CLI-DEFAULT-INTERACTION | Interactive empty argv opens the numbered list and does not place the CLI | ran on the authoring host. A pty sent `9`. Exit 0. The list was shown. `SCRIPT_URL is not set` was not printed |
| TP-ZERO-04 | RQ-SHELL-CLI-ZERO-ARGUMENTS | `--json` with no command on a terminal is self-install, not the list and not help | ran on the authoring host. A pty ran `--json`. Exit 1. No choose prompt. The JSON error names the empty channel |
| TP-IDEM-01 | RQ-SHELL-IDEMPOTENCY | Second non-interactive empty argv on an installed binary exits 0 | ran on the authoring host. Same run as TP-ZERO-01 |
| TP-IDEM-02 | RQ-SHELL-IDEMPOTENCY | Setup skip when ref and revision match | todo |
| TP-OUT-01 | RQ-SHELL-OUTPUT-REQUIREMENTS | `--json version` prints one JSON object and no `[INFO]` line | ran, repeated |
| TP-SM-01 | RQ-SHELL-SELF-MANAGEMENT | `about` exits 0 and includes payload fields | ran, prior smoke |
| TP-SM-02 | RQ-SHELL-SELF-MANAGEMENT | `self-update` with an empty `SCRIPT_URL` is non-zero | todo |
| TP-SM-03 | RQ-SHELL-SELF-MANAGEMENT | `self-uninstall` does not remove a payload directory | todo |
| TP-SUM-01 | RQ-SHELL-AUTOMATIC-CHECKSUM | Install with an explicit empty `SCRIPT_URL` exits non-zero before curl | ran 2026-10-07. Same command as TP-CLI-02 |
| TP-SUM-02 | RQ-SHELL-AUTOMATIC-CHECKSUM | A mismatched companion aborts install | todo |
| TP-STO-01 | RQ-SHELL-CLI-STORAGE | `about` prints an effective storage line | ran, prior smoke |
| TP-MOD-01 | RQ-SHELL-MODULAR-FUNCTION-DESIGN | `tn5250_setup` exists and `inst_perform_install` does not configure CMake | ran as a source read. `cmake` calls are in `tn5250_build_windows` and `tn5250_build_debian` |
| TP-INT-01 | RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | Non-interactive empty argv does not wait for input | ran, repeated. Exit 1 before any choose prompt |
| TP-MENU-01 | RQ-SHELL-CLI-DEFAULT-INTERACTION | `menu` off a terminal exits 1 and names help | ran on the authoring host. stderr: `menu needs a terminal. Next: tn5250-cli help`. `--json menu` on a pipe exits 1 with that sentence in a JSON error and no stdout |
| TP-MENU-02 | RQ-SHELL-CLI-DEFAULT-INTERACTION | A wrong number reprints the list and does not exit | ran on the authoring host. A pty sent `3` then `9`. Exit 0. `3 is not on this list.` The list was printed twice |
| TP-MENU-03 | RQ-SHELL-CLI-DEFAULT-INTERACTION | Row 8 opens self-management, 0 returns to the front, and 9 exits 0 | ran on the authoring host. A pty sent `8`, `0`, `9`. Exit 0. Front title twice. Self-management title once |
| TP-MENU-04 | RQ-SHELL-CLI-DEFAULT-INTERACTION | Row 82 runs about, then the front list is shown again | ran on the authoring host. A pty sent `8`, `82`, `9`. Exit 0. About text appeared. Front title twice |
| TP-MENU-05 | RQ-SHELL-CLI-DEFAULT-INTERACTION | `menu --json` on a terminal still draws the list | ran on the authoring host. A pty sent `9`. Exit 0. The list was shown. JSON help was not printed |
| TP-INT-02 | RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | `setup -h` prints flags and does not prompt | ran, repeated |
| TP-DOM-01 | RQ-DOMAIN-TN5250 | Help lists setup and host launch after the Type 0 rows | ran, prior smoke |
| TP-DOM-02 | RQ-DOMAIN-TN5250 | `setup -h` exits 0 on a machine that is not Git Bash and not Debian 12 or 13 | ran, repeated |
| TP-DOM-03 | RQ-DOMAIN-TN5250 | An unknown setup option exits non-zero | ran, repeated |
| TP-DOM-04 | RQ-DOMAIN-TN5250 | A host token on a machine the script does not route exits non-zero and does not configure CMake | ran, repeated, on the previous script. Message: `launch needs Git Bash on Windows, or Debian 12 or 13.` The current script routes this Ubuntu host to the Ubuntu build |
