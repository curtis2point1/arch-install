# arch-install

## New Arch Bootstrap

Use the root `bootstrap.sh` script for the minimum setup required before Chezmoi can take over common Arch configuration.

Run this as the target non-root user with sudo privileges. User creation, `wheel` membership, and initial sudoers setup must already be complete.

Canonical URL:

```text
https://raw.githubusercontent.com/curtis2point1/arch-install/main/bootstrap.sh
```

One-line install command:

```bash
curl -fsSL https://raw.githubusercontent.com/curtis2point1/arch-install/main/bootstrap.sh | bash
```

Expected bootstrap flow:

- Update the base Arch system.
- Install minimum dependencies: `sudo`, `git`, `openssh`, `github-cli`, `chezmoi`, `curl`, and `micro`.
- Ensure SSH keys exist with correct permissions.
- Authenticate GitHub CLI using SSH as the Git protocol.
- Let GitHub CLI upload the SSH public key during authentication.
- Verify GitHub SSH access.
- Run Chezmoi init/apply over SSH.

Headless access options:

- Use console access and type the one-line command.
- Use temporary password SSH, then run the one-line command remotely.
- If `curl` is missing, install it with `pacman` or clone this repo over HTTPS and run `bash bootstrap.sh` locally.

Security note: once the script is stable, prefer using a pinned tag or commit URL for real machine installs.

## Chezmoi Boundary

Decision: this repo should keep only the pre-Chezmoi bootstrap script and related docs/plans. All setup and configuration scripts should move into Chezmoi, including common setup and role-specific server, GUI, GNOME, Hyprland, and WSL behavior.

This repo remains the central AI working repo and knowledge base for managing both the bootstrap script and the Chezmoi setup.

Current transition references:

- `scratchpad.md`: recent repo-local context and next action.
- `plans/chezmoi-role-migration.md`: active migration plan.
- `docs/chezmoi-setup.md`: catalog of the current Chezmoi setup.

The existing scenario layer directories are transitional source material until their behavior is migrated into Chezmoi roles. Do not add new guessed scenario behavior here.

## AI Agent Context

**Purpose**: Maintain the minimal Arch bootstrap script and the AI knowledge base for Chezmoi-managed setup.

**Owner**: Curtis Robinson (solo consultant - Two Point One Analytics)
- Data analyst/engineer working with ecommerce analytics
- Learning Linux, DevOps, and automation best practices

**Layers**:
- **bootstrap**: minimum packages, SSH/GitHub auth, and `chezmoi init/apply`
- **Chezmoi common**: common Arch packages, dotfiles, user services, and development tooling
- **Chezmoi roles**: future server, GUI, GNOME, Hyprland, and WSL setup

**Key Scripts**:
- `bootstrap.sh` - pre-Chezmoi bootstrap and update entrypoint
- Chezmoi scripts under `~/.local/share/chezmoi` - post-bootstrap setup and configuration

**Philosophy**:
- Simple, working code first - refactor later
- Idempotent scripts (safe to run multiple times)
- Learn best practices without over-engineering
- Git rollback safety in dotfiles management

**Workflow**: Run `bootstrap.sh`, then let Chezmoi apply common setup and role-specific setup as that migration is completed.
