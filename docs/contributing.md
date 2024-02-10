# Contributing guide

This document provides guidelines for contributing to the toolkit.

1. Install required software (see [Dependencies](#dependencies)).
2. Make changes, ensure [Linting and unit testing](#linting-and-unit-testing) and [Manual testing](#manual-testing)), then commit.

   Initial commit messages should follow the [Conventional Commits](https://www.conventionalcommits.org/) style (e.g. `feat(opencore): add new driver`).
3. Send a pull request with your changes.
4. A maintainer will review the pull request and make comments.

   Prefer adding additional commits over amending and force-pushing since it can be difficult to follow code reviews when the commit history changes.

   Commits will be squashed when they're merged.

## Dependencies

The following dependencies must be installed on the development system:

- [Bash](https://www.gnu.org/software/bash/) > 4.0
- [Coreutils](https://www.gnu.org/software/coreutils/) > 8.15
- [OpenSSL](https://www.openssl.org/) 1.1 (required for Wget)
- [Wget](https://www.gnu.org/software/wget/)

Should you use [Homebrew](https://brew.sh/) on macOS, full list of dependencies could be installed with

```shell
brew bundle
```

## Linting and unit testing

Many of the files in the repository can be linted and unit tests can be run to maintain a standard of quality.

Run `make lint test`.

## Manual testing

To download all necessary packages and extract files to the `EFI` folder in the current directory, issue

```shell
make run
```

Once done, follow [replace placeholders](#replace-placeholders), mount EFI partition and copy `EFI` folder there.

## Manual testing latest code

There's no need to clone this repository, just run

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/vovinacci/OpenCore-ASUS-ROG-MAXIMUS-XI-HERO/master/create-efi.sh)"
```

Once done, follow [replace placeholders](#replace-placeholders), mount EFI partition and copy `EFI` folder there.

## Replace placeholders

Two things to be done manually before moving everything to actual EFI partition:

- Replace `{{SERIAL}}`, `{{BOARDSERIAL}}` and `{{SMUUID}}` with actual values in `EFI/OC/config.plist`.

  If you don't have one, great example on how to do this could be found
  [here](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#generate-a-new-serial).
- Replace `{{MACADDRESS}}` with actual `en0` MAC address value in `EFI/OC/config.plist`.

  Another great example on how to do it is [here](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#fixing-en0).
