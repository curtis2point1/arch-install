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

## Layered Setup

After common bootstrap/Chezmoi setup, run only the layers needed for the machine.

Examples:

```bash
# Server only
bash server/run.sh

# Server with GNOME desktop
bash server/run.sh
bash gui/run.sh
bash gnome/run.sh

# GUI workstation with Hyprland once configured
bash gui/run.sh
bash hyprland/run.sh

# WSL-specific extras
bash wsl/run.sh
```

Layer responsibilities:

- `server/`: server-oriented tools and services such as Docker.
- `gui/`: desktop applications and GUI-common setup shared across graphical environments.
- `gnome/`: GNOME-specific packages, keybindings, portal, and voice/input setup.
- `hyprland/`: Hyprland-specific setup; currently a placeholder until package choices are confirmed.
- `wsl/`: WSL-only packages and integration settings.
- `common/scripts/utilities.sh`: shared Bash helpers used by layer scripts.

Chezmoi owns common packages, dotfiles, Tailscale, Resilio Sync, SSH/GitHub auth, editor config, `mise`, `uv`, and common services. Do not duplicate those in scenario layers.

## AI Agent Context

**Purpose**: Automate common Arch bootstrap plus small scenario-specific setup layers.

**Owner**: Curtis Robinson (solo consultant - Two Point One Analytics)
- Data analyst/engineer working with ecommerce analytics
- Learning Linux, DevOps, and automation best practices

**Layers**:
- **common bootstrap/Chezmoi**: common Arch packages, dotfiles, user services, and development tooling
- **server**: server-specific services/tools
- **gui**: graphical application baseline
- **gnome**: GNOME desktop specifics
- **hyprland**: Hyprland desktop specifics
- **wsl**: WSL-only integration

**Key Scripts**:
- `common/scripts/utilities.sh` - Core functions (install_packages, remove_packages, enable_services, etc.)
- `bootstrap.sh` - pre-Chezmoi bootstrap and update entrypoint
- `server/run.sh`, `gui/run.sh`, `gnome/run.sh`, `hyprland/run.sh`, `wsl/run.sh` - optional scenario layers

**Philosophy**:
- Simple, working code first - refactor later
- Idempotent scripts (safe to run multiple times)
- Learn best practices without over-engineering
- Git rollback safety in dotfiles management

**Workflow**: Run `bootstrap.sh`, let Chezmoi apply common setup, then run only the optional scenario layer scripts needed for the machine.
