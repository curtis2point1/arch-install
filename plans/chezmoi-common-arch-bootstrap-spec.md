# Chezmoi Common Arch Bootstrap Spec

## Decision Summary

Use **Chezmoi** for dotfiles and the **common Arch Linux setup layer** that applies across all Arch-based systems:

- Headless server
- Desktop workstation
- Laptop workstation

Keep machine-specific setup outside of Chezmoi for now, using the existing custom Arch install repo and/or Obsidian playbooks. Do not migrate unique desktop, laptop, or server setup into Chezmoi yet.

The immediate goal is to convert only the **common setup logic** from the current custom Arch install repo into Chezmoi-compatible files.

## Scope for Chezmoi

Chezmoi should manage:

- Dotfiles and user-level configuration
- Common Arch package installation
- Common CLI/dev tooling
- Common shell/editor dependencies
- Common directory creation
- Shared setup tasks needed by all Arch systems

Chezmoi should not yet manage:

- Desktop-only GUI app setup
- Laptop-only power or battery tuning
- Server-only Docker/Caddy/service setup
- Complex system hardening
- Client-specific tooling
- Large conditional workflows

## Preferred Chezmoi Script Pattern

Use Chezmoi run scripts only for tasks that should be part of the common bootstrap process.

Recommended script types:

```text
run_once_before_00-arch-common-base.sh
run_once_before_10-arch-aur-helper.sh
run_onchange_after_20-arch-common-packages.sh
run_once_after_30-common-directories.sh
```

### Use `run_once_` for

Tasks that should run only once unless the rendered script content changes:

- Initial bootstrap checks
- Installing an AUR helper
- Setting up common directories
- One-time system initialization tasks

### Use `run_onchange_` for

Tasks that should re-run only when the script or generated package list changes:

- Installing/updating common package lists
- Applying shared tool installation logic

### Avoid plain `run_`

Do not use plain `run_*.sh` for package setup unless the script is safe to execute every time `chezmoi apply` runs.

Plain `run_` scripts execute on every apply, which is not desired for most install/bootstrap tasks.

## Suggested File Layout

```text
~/.local/share/chezmoi/
├── run_once_before_00-arch-common-base.sh
├── run_once_before_10-arch-aur-helper.sh
├── run_onchange_after_20-arch-common-packages.sh.tmpl
├── run_once_after_30-common-directories.sh
├── .chezmoidata/
│   └── arch-packages.yaml
├── dot_config/
├── dot_zshrc
├── dot_gitconfig.tmpl
└── README.md
```

## Package Data

Prefer storing package lists in a data file rather than hardcoding everything directly inside scripts.

Example:

```yaml
# .chezmoidata/arch-packages.yaml

pacman_common:
  - git
  - zsh
  - tmux
  - curl
  - wget
  - jq
  - fzf
  - ripgrep
  - fd
  - bat
  - eza
  - neovim

aur_common:
  - visual-studio-code-bin
```

Then use a templated script such as:

```text
run_onchange_after_20-arch-common-packages.sh.tmpl
```

to generate installation commands from the package lists.

## Script Requirements

All converted scripts should be:

- Safe to re-run where possible
- Non-interactive unless unavoidable
- Clear about what they install or change
- Limited to common Arch setup only
- Written with `set -euo pipefail`
- Organized into small, focused files rather than one large script

Recommended script header:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

## Idempotency Guidance

Before making a change, scripts should check whether the change is already complete.

Examples:

```bash
command -v yay >/dev/null 2>&1 || install_yay
```

```bash
pacman -Qi git >/dev/null 2>&1 || sudo pacman -S --needed --noconfirm git
```

```bash
mkdir -p "$HOME/repos" "$HOME/scripts" "$HOME/.local/bin"
```

Use package-manager idempotency where possible:

```bash
sudo pacman -S --needed --noconfirm package-name
```

## Conversion Instructions for AI Agent

When converting the current custom Arch install repo:

1. Identify setup logic that applies to **all Arch machines**.
2. Move only that common logic into Chezmoi run scripts.
3. Leave desktop-only, laptop-only, and server-only setup out of Chezmoi.
4. Prefer package lists in `.chezmoidata/arch-packages.yaml`.
5. Use `run_once_` or `run_onchange_`; avoid plain `run_`.
6. Keep scripts small, readable, and idempotent.
7. Do not introduce complex host-specific conditional logic yet.
8. Add comments where a task was intentionally excluded because it is machine-specific.

## Intended Workflow

On a new Arch machine:

```bash
chezmoi init --apply <dotfiles-repo>
```

Chezmoi should then:

1. Apply dotfiles.
2. Run common Arch bootstrap scripts.
3. Install common packages and shell/dev dependencies.
4. Leave machine-specific setup to separate playbooks or the existing setup repo.

## Future Direction

If machine-specific setup becomes repetitive enough, consider moving those workflows to Ansible later.

For now:

- Chezmoi = dotfiles + common Arch bootstrap
- Existing setup repo / Obsidian = machine-specific playbooks
- Ansible = optional future system provisioning layer
