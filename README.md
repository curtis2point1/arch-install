# arch-install

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