# Security

## Reporting

Report a vulnerability in this installer to cloudgen.wong@gmail.com. Please include the version from `tn5250-cli version` and the command you ran. Do not include passwords.

## What this project is

`tn5250-cli` installs and launches the upstream TN5250 client. The installer is this repository. The client source is cloned from the upstream project at setup time and keeps that project's license.

## Install channel

`SCRIPT_URL` defaults to `https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli`. `REPO_USER` defaults to `cloudgen` and `REPO_NAME` defaults to `tn5250-cli`. Export `SCRIPT_URL` to use another script address. An empty `SCRIPT_URL` refuses the download.

```sh
curl -fsSL https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli | sh
```

On Linux, a root login uses `sudo curl -fsSL https://raw.githubusercontent.com/cloudgen/tn5250-cli/main/src/tn5250-cli | sudo sh`. Git Bash uses the command without sudo.

When `SCRIPT_URL` is set and no `CHECKSUM` pin is set, install tries the companion file at `${SCRIPT_URL}.sha256`:

- A matching SHA-256 digest continues the install.
- A mismatch stops the install.
- A missing companion warns and continues without that check.

The digest published beside the script in this repository is `src/tn5250-cli.sha256` (SHA-256, one hex line).

## Privilege

`tn5250-cli setup` is the command to type. Missing compiler packages may ask for an administrator password. Git and the compile stay with the person who started setup. This tool does not write a sudoers file.
