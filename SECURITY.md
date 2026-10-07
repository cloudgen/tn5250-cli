# Security

## Reporting

Report a vulnerability in this installer to cloudgen.wong@gmail.com. Please include the version from `tn5250-cli version` and the command you ran. Do not include passwords.

## What this project is

`tn5250-cli` installs and launches the upstream TN5250 client. The installer is this repository. The client source is cloned from the upstream project at setup time and keeps that project's license.

## Install channel

This release does not set `SCRIPT_URL`. There is no `curl | sh` channel until an operator exports `SCRIPT_URL`, or exports both `REPO_USER` and `REPO_NAME`.

When `SCRIPT_URL` is set and no `CHECKSUM` pin is set, install tries the companion file at `${SCRIPT_URL}.sha256`:

- A matching SHA-256 digest continues the install.
- A mismatch stops the install.
- A missing companion warns and continues without that check.

The digest published beside the script in this repository is `src/tn5250-cli.sha256` (SHA-256, one hex line).

## Privilege

`tn5250-cli setup` is the command to type. Missing compiler packages may ask for an administrator password. Git and the compile stay with the person who started setup. This tool does not write a sudoers file.
