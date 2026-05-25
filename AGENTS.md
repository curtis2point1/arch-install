# Repository Guidance

## Scope
- This is a Bash automation repo for Arch Linux setup; full `run.sh` scripts mutate the real machine with `sudo`, `pacman`/`yay`, `npm`, GitHub auth, dotfiles, services, and `$HOME` changes.
- Do not run `curtarchy/run.sh`, `omarchy/run.sh`, `winarchy/run.sh`, or dotfile deployment scripts as verification unless Curtis explicitly asks.

## Layout
- `common/scripts/utilities.sh` defines shared helpers: `prime_sudo`, package install/remove, service enablement, file/dir helpers, and GNOME keybindings.
- `common/scripts/packages.sh` holds shared package/service/dotfile arrays; ShellCheck reports these as unused because they are meant to be sourced.
- `common/scripts/setup_*.sh` are setup units; most source `utilities.sh` and call `install_packages`.
- `curtarchy/`, `omarchy/`, and `winarchy/` are environment entrypoints; `dotfiles/` is GNU Stow-style packages rooted at `$HOME`.

## Commands
- Focused lint for one script: `shellcheck path/to/script.sh`.
- Repo-wide lint: `shellcheck common/scripts/*.sh curtarchy/run.sh omarchy/run.sh winarchy/run.sh dotfiles/*.sh`.
- There is no CI, test runner, formatter config, or task runner in this repo.

## Current Gotchas
- `utilities.sh` currently has an invalid shebang (`#!/binbash`), so ShellCheck reports `SC1008`; scripts still source it with Bash.
- `curtarchy/run.sh` and `omarchy/run.sh` source `$current_dir/packages.sh`, but no environment-local `packages.sh` files exist; shared package arrays are in `common/scripts/packages.sh`.
- `winarchy/run.sh` references missing `common/scripts/setup_gemini.sh` and `common/scripts/setup_sync.sh`.
- `dotfiles/setup.sh` sources missing `../utilities.sh`; the actual helper file is `../common/scripts/utilities.sh`.
- `dotfiles/dotstow.sh` is incomplete and contains a `REP_ROOT` typo; do not treat it as production-ready dotfile deployment logic.

## Style
- Keep scripts idempotent where possible: check before installing, removing, creating, linking, or enabling.
- Preserve the existing simple Bash style and lowercase variable/function naming unless touching a file that already uses uppercase constants.
- Prefer adding reusable behavior to `common/scripts/utilities.sh` or a focused `common/scripts/setup_*.sh` instead of duplicating logic in environment entrypoints.
