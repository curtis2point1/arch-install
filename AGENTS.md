# Repository Guidance

## Scope
- This is the central AI working repo and knowledge base for Arch bootstrap and Chezmoi-managed setup decisions.
- Long term, this repo should own only pre-Chezmoi bootstrap code plus docs/plans; all setup and configuration scripts should live in Chezmoi.
- It is appropriate to edit files under `~/.local/share/chezmoi` when managing Chezmoi-owned setup from this repo.
- Do not run `bootstrap.sh`, scenario `run.sh` scripts, or Chezmoi apply/update commands as verification unless Curtis explicitly asks.

## Layout
- `bootstrap.sh` performs pre-Chezmoi bootstrap/update work.
- `scratchpad.md` contains recent repo-local context and next actions.
- `docs/` contains durable reference for bootstrap and Chezmoi setup.
- `plans/` contains active/refactor plans.
- `server/`, `gui/`, `gnome/`, `hyprland/`, and `wsl/` are transitional source material until their behavior is migrated into Chezmoi roles.
- Chezmoi owns common packages, dotfiles, Tailscale, Resilio Sync, SSH/GitHub auth, editor config, `mise`, `uv`, common services, and should own future role-specific setup.

## Commands
- Focused lint for one script: `shellcheck path/to/script.sh`.
- Repo-wide lint: `shellcheck bootstrap.sh common/scripts/*.sh server/*.sh gui/*.sh gnome/*.sh hyprland/*.sh wsl/*.sh`.
- There is no CI, test runner, formatter config, or task runner in this repo.

## Current Gotchas
- `hyprland/run.sh` is currently a placeholder; do not add guessed Hyprland packages without confirmation.
- `server/run.sh`, `gui/run.sh`, `gnome/run.sh`, and `wsl/run.sh` are machine-mutating and should not be run as tests.
- The previous layered-script model is superseded by `plans/chezmoi-role-migration.md`; do not add new scenario setup here unless Curtis explicitly changes the boundary.

## Style
- Keep scripts idempotent where possible: check before installing, removing, creating, linking, or enabling.
- Preserve the existing simple Bash style and lowercase variable/function naming unless touching a file that already uses uppercase constants.
- While transitional scripts remain, preserve their existing helper/style patterns; do not expand the old layer model unless Curtis explicitly reopens that boundary.
