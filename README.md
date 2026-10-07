# tn5250-cli

[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://github.com/cloudgen/tn5250-cli)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE.md)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/cloudgen/tn5250-cli?style=flat-square)](https://github.com/cloudgen/tn5250-cli)

`tn5250-cli` installs and launches the upstream TN5250 terminal client. You type `tn5250-cli setup`. On Debian, Ubuntu, and other Linux, missing compiler packages are installed with sudo from inside that command. Git and the compile stay with you, including when setup was started with sudo.

## Features

- One setup command for your user and for a sudo launch.
- Windows Git Bash builds the Windows programs.
- Debian 12 and 13, Ubuntu 22.04, 24.04, and 26.04, and other Linux build the curses program.
- The built client is copied under the install prefix, default `~/.local`.
- `help` and `version` print text and do not compile.

Upstream is [tn5250/tn5250](https://github.com/tn5250/tn5250) tag `v0.18.0` at commit `cd5980177b9468763bcaa669bf5cacbe7de5ec63`. That client keeps its own license. This installer is MIT.

## Quick Installation

This release does not publish a `curl | sh` channel. `SCRIPT_URL` is empty unless you export it.

```sh
git clone git@github.com:cloudgen/tn5250-cli.git
cd tn5250-cli
src/tn5250-cli setup
```

Setup asks for the administrator password only when compiler packages are missing. If the compiler is already installed, setup does not call sudo.

## Usage

```sh
tn5250-cli setup
tn5250-cli setup --prefix ~/.local --ref v0.18.0
tn5250-cli help
tn5250-cli version
tn5250-cli myibmi.example.com
```

`tn5250-cli setup -h` prints the setup options and does not compile.

After a successful setup, the installer is copied to `~/.local/bin/tn5250-cli` unless you passed `--prefix`.

## Version

Product version **1.0.0** is the `VERSION` line in `src/tn5250-cli`.

## License

The installer is [MIT](./LICENSE.md). Copyright (c) 2026 Wong Chun Fai, aka: Cloudgen (cloudgen.wong@gmail.com).
