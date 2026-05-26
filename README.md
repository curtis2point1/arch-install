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

## AI Agent Context

**Purpose**: Automate Arch Linux installation and configuration across multiple environments. This is a learning project for bash scripting, Linux infrastructure, and establishing reproducible development workflows.

**Owner**: Curtis Robinson (solo consultant - Two Point One Analytics)
- Data analyst/engineer working with ecommerce analytics
- Learning Linux, DevOps, and automation best practices

**Environments**:
- **omarchy**: Reference/model Arch distro (Nitro laptop)
- **curtarchy**: Custom configuration based on omarchy (desktops/laptops, GUI, Nvidia)
- **winarchy**: Terminal-only Arch for WSL systems
- **common**: Shared scripts and utilities
- **dotfiles**: Centralized dotfiles using GNU stow

**Key Scripts**:
- `common/scripts/utilities.sh` - Core functions (install_packages, remove_packages, enable_services, etc.)
- `common/scripts/packages.sh` - Package definitions for all environments
- `common/scripts/setup_*.sh` - Individual tool setup (yay, git, ssh, python, node, etc.)
- Each environment has a main `run.sh` or `setup.sh` script

**Philosophy**:
- Simple, working code first - refactor later
- Idempotent scripts (safe to run multiple times)
- Learn best practices without over-engineering
- Git rollback safety in dotfiles management

**Workflow**: Each environment sources utilities, installs packages via yay, runs setup scripts, enables services, and links dotfiles with stow.
