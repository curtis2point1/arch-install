# Repository Guidance

## Scope
- This is a Bash automation repo for Arch Linux setup; full `run.sh` scripts mutate the real machine with `sudo`, `pacman`/`yay`, `npm`, GitHub auth, dotfiles, services, and `$HOME` changes.
- Do not run `bootstrap.sh`, scenario `run.sh` scripts, or Chezmoi apply/update commands as verification unless Curtis explicitly asks.

## Layout
- `bootstrap.sh` performs pre-Chezmoi bootstrap/update work.
- `common/scripts/utilities.sh` defines shared helpers: `prime_sudo`, package install/remove, service enablement, file/dir helpers, and GNOME keybindings.
- `server/`, `gui/`, `gnome/`, `hyprland/`, and `wsl/` are optional scenario layers run after common bootstrap/Chezmoi setup.
- Chezmoi owns common packages, dotfiles, Tailscale, Resilio Sync, SSH/GitHub auth, editor config, `mise`, `uv`, and common services.

## Commands
- Focused lint for one script: `shellcheck path/to/script.sh`.
- Repo-wide lint: `shellcheck bootstrap.sh common/scripts/*.sh server/*.sh gui/*.sh gnome/*.sh hyprland/*.sh wsl/*.sh`.
- There is no CI, test runner, formatter config, or task runner in this repo.

## Current Gotchas
- `hyprland/run.sh` is currently a placeholder; do not add guessed Hyprland packages without confirmation.
- `server/run.sh`, `gui/run.sh`, `gnome/run.sh`, and `wsl/run.sh` are machine-mutating and should not be run as tests.

## Style
- Keep scripts idempotent where possible: check before installing, removing, creating, linking, or enabling.
- Preserve the existing simple Bash style and lowercase variable/function naming unless touching a file that already uses uppercase constants.
- Prefer adding reusable behavior to `common/scripts/utilities.sh`; keep scenario-specific behavior inside its layer directory.
