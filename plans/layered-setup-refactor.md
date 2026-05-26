# Layered Setup Refactor

## Goal

Refactor this repo after the common bootstrap/Chezmoi migration so it only contains scenario-specific Arch setup layers that can run after common setup.

## Success Criteria

- [x] Legacy environment entrypoints are replaced or clearly retired.
- [x] Scenario layers exist for `server/`, `gui/`, `gnome/`, `hyprland/`, and `wsl/`.
- [x] Each layer is rerunnable and only assumes the common bootstrap/Chezmoi baseline plus declared prerequisite layers.
- [x] Common-Chezmoi-owned setup is removed from scenario scripts to avoid duplicate installs/config.
- [x] README documents the intended layer order and examples.
- [x] Focused shell syntax/lint checks pass for changed scripts.

## Current State

- Status: completed
- Current step: Layered refactor implemented and statically verified.
- Next action: Review the refactor diff, then commit if accepted.

## Open Questions

- None.

## Decisions

- 2026-05-26: Common bootstrap/Chezmoi setup is complete; this repo should now focus on scenario-specific layers.
- 2026-05-26: Layer model is `server/`, `gui/`, `gnome/`, `hyprland/`, and `wsl/` after common bootstrap/Chezmoi.
- 2026-05-26: Layer dependencies should be one-way: `server` after common, `gui` after common, `gnome`/`hyprland` after `gui`, and `wsl` after common.
- 2026-05-26: Use canonical `hyprland/` spelling.
- 2026-05-26: Delete obsolete common setup scripts instead of keeping a deprecated transition folder; git history preserves them.

## Initial Classification Hypothesis

- Common-Chezmoi-owned/deprecated here: `setup_yay.sh`, `setup_local_bin.sh`, `setup_node.sh`, `setup_python.sh`, `setup_tailscale.sh`, `setup_google_cloud.sh`, `setup_ssh.sh`, `setup_micro.sh`, `setup_git.sh`, `setup_dirs.sh`, `setup_chezmoi.sh`, `setup_resilio_sync.sh`, `packages.sh` common package arrays.
- Server candidates: `setup_docker.sh`, server/headless packages, service-only setup.
- GUI candidates: `setup_fonts.sh`, `setup_flatpak.sh`, GUI app packages, audio/video basics.
- GNOME candidates: `setup_keybindings_gnome.sh`, `setup_voxtype_gnome.sh`, GNOME portal/settings/keybindings.
- Hyprland candidates: no current first-class script; create placeholder/layer structure only unless requirements are confirmed.
- WSL candidates: `wslu`, `gio mime ... wslview.desktop`, `/etc/wsl.conf` documentation/tasks.
- Deprecated or needs review: `clone_repos.sh`, `setup_syncthing.sh`, `setup_resume_service.sh`, `setup_walker.sh`, `setup_ydotool.sh`, old `headless/`, `omarchy/` entrypoints.

## Progress Log

### 2026-05-26 - Plan Created

- Changed: Created this repo-local refactor plan.
- Files touched: `plans/layered-setup-refactor.md`.
- Findings: Existing repo already has `wsl/` and `gnome/`; `headless/` README appears copied from WSL; old entrypoints still source many common setup scripts that Chezmoi now owns.
- Blockers: None.
- Next: Inventory script contents and implement the smallest safe layer refactor.

### 2026-05-26 - Layer Refactor Implemented

- Changed: Replaced old `headless/` and `omarchy/` entrypoints with `server/`, `gui/`, `gnome/`, `hyprland/`, and `wsl/` layers.
- Changed: Removed obsolete `common/scripts/setup_*.sh`, `packages.sh`, and `clone_repos.sh` scripts now owned by Chezmoi/common setup or no longer part of this repo's layer model.
- Changed: Kept and fixed `common/scripts/utilities.sh` as the shared helper file.
- Changed: Updated `README.md`, `AGENTS.md`, and layer README files with the new setup flow.
- Files touched: `AGENTS.md`, `README.md`, `common/scripts/utilities.sh`, `server/*`, `gui/*`, `gnome/*`, `hyprland/*`, `wsl/*`, removed legacy scripts and old `headless/`/`omarchy/` files.
- Verification: `bash -n bootstrap.sh common/scripts/utilities.sh server/run.sh gui/run.sh gnome/run.sh hyprland/run.sh wsl/run.sh`; `shellcheck bootstrap.sh common/scripts/utilities.sh server/run.sh gui/run.sh gnome/run.sh hyprland/run.sh wsl/run.sh`; `git diff --check`.
- Findings: `hyprland/run.sh` remains an intentional placeholder until exact packages and setup steps are confirmed.
- Blockers: None.
- Next: Review the refactor diff, then commit if accepted.
