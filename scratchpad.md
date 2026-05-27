# Scratchpad

Recent repo-local context for the Arch bootstrap and Chezmoi setup workstream. Keep this lightweight; move durable details into `docs/` or `plans/` when they need to persist as reference or active work.

## Active

### 2026-05-26 - Chezmoi Transition

- Decision: all setup and configuration scripts should live in Chezmoi once migrated.
- Decision: this repo should retain only the root `bootstrap.sh` and documentation needed before Chezmoi can run.
- Decision: this repo remains the central AI working repo and knowledge base for managing both Chezmoi setup and bootstrap scripts.
- Active plan: `plans/chezmoi-role-migration.md`.
- Durable reference: `docs/chezmoi-setup.md`.
- Open item: transition remaining server, GUI, GNOME, Hyprland, and WSL setup behavior into Chezmoi role-aware package data and role scripts.
- Next action: review `plans/chezmoi-role-migration.md`, then scaffold explicit Chezmoi role data and scripts in `~/.local/share/chezmoi` without changing install behavior until reviewed.
- Note: existing scenario layer directories are transitional source material, not the long-term home for post-bootstrap behavior.
- Note: `hyprland` remains intentionally empty until exact packages, portal choice, launcher/status bar, and keybinding strategy are confirmed.
