# Chezmoi Common Arch Bootstrap Spec

## Decision Summary

Use **Chezmoi** for dotfiles and the **common Arch Linux setup layer** that applies across all Arch-based systems:

- Headless server
- Desktop workstation
- Laptop workstation

Keep machine-specific setup outside of Chezmoi for now, using the existing custom Arch install repo and/or Obsidian playbooks. Do not migrate unique desktop, laptop, or server setup into Chezmoi yet.

The immediate goal is to convert only the **core Arch Linux setup** and **common TUI/CLI tooling** from the current custom Arch install repo into Chezmoi-compatible files.

Before Chezmoi can run, keep a short pre-Chezmoi playbook or script for minimum bootstrap dependencies such as `git`, `openssh`, `sudo`, and `chezmoi` itself.

## Scope for Chezmoi

Chezmoi should manage:

- Dotfiles and user-level configuration
- Common Arch package installation
- Common TUI/CLI/dev tooling
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

## Source Inventory from `headless/`

This inventory is intentionally broad. Use it to iteratively decide what belongs in the pre-Chezmoi bootstrap, what belongs inside Chezmoi, and what should be excluded from the common Arch/TUI scope.

### Pre-Chezmoi Setup Candidates

From `headless/README.md`:

- Update the base system with `pacman -Syu`.
- Install initial packages with `pacman -S git micro`.
- Create `~/dev/curtis`.
- Clone `https://github.com/curtis2point1/arch-install.git`.

Likely minimum bootstrap dependencies before `chezmoi init --apply`:

- `git`
- `openssh`
- `chezmoi`
- `micro`

### Package Inventory

From `headless/run.sh` `packages_to_add`:

- `jq`
- `wl-clipboard`
- `shellcheck`
- `man-db`
- `fd`
- `plocate`
- `ripgrep`
- `fzf`
- `bat`
- `eza`
- `fsearch`
- `btop`
- `nvtop`
- `zoxide`
- `starship`
- `lazygit`
- `yazi`
- `7zip`
- `less`
- `zed`
- `visual-studio-code-bin`
- `opencode`
- `ghostty`
- `pacseek`

From `common/scripts/packages.sh` `common_packages`:

- `bash-language-server`
- `shellcheck`
- `man-db`
- `fd`
- `ripgrep`
- `fzf`
- `btop`
- `plocate`
- `zoxide`
- `starship`
- `lazygit`
- `python`
- `nodejs`
- `jq`
- `stow`
- `yazi`
- `7zip`
- `less`

From sourced setup scripts:

- `base-devel`
- `git`
- `yay`
- `nvm`
- `node`
- `python`
- `uv`
- `ruff`
- `pre-commit`
- `ipython`
- `httpx`
- `tailscale`
- `google-cloud-cli`
- `google-cloud-cli-gsutil`
- `google-cloud-cli-bq`
- `openssh`
- `micro`
- `github-cli`
- `docker`
- `docker-compose`
- `lazydocker`
- `rslsync`
- `chezmoi`
- `@anthropic-ai/claude-code`

### Configuration Step Inventory

From `headless/run.sh` and sourced setup scripts:

- Prime and keep sudo credentials active.
- Install `yay` when missing, including `git` and `base-devel` prerequisites.
- Create `~/.local/bin`.
- Add `~/.local/bin` to `PATH` through `~/.bashrc`.
- Install NVM with the upstream install script.
- Source NVM for the current session.
- Install latest Node.js through NVM.
- Set NVM default alias to `node`.
- Install Python.
- Install `uv` with the upstream install script.
- Install global `uv` tools: `ruff`, `pre-commit`, `ipython`, `httpx`.
- Install and enable Tailscale with `tailscaled`.
- Run `sudo tailscale up` when Tailscale is not connected.
- Install Google Cloud CLI packages.
- Run `gcloud init` when no Google Cloud account is configured.
- Install OpenSSH.
- Generate an Ed25519 SSH key if `~/.ssh/id_ed25519` is missing.
- Create `~/.ssh/authorized_keys`.
- Set SSH file permissions.
- Enable and start `sshd`.
- Install Micro and related packages.
- Install Micro plugins: `lsp`, `linter`.
- Set `EDITOR=micro` and `VISUAL=micro` in `/etc/environment`.
- Export `EDITOR=micro` for the current shell.
- Create or update `~/.config/micro/settings.json`.
- Install Git and GitHub CLI.
- Authenticate GitHub CLI with required scopes.
- Refresh GitHub CLI scopes when missing SSH-key permissions.
- Add the local SSH key to GitHub with `gh ssh-key add`.
- Configure global Git user email and name.
- Create common directories: `~/sync`, `~/notes`, `~/dev/curtis`, `~/dev/datm`, `~/dev/ripe`, `~/dev/two-point-one`.
- Clone selected work and personal repositories under `~/dev`.
- Install and enable Docker.
- Add the current user to the `docker` group.
- Create `~/sync` for Resilio Sync.
- Install Resilio Sync.
- Add group permissions between user `curtis` and `rslsync`.
- Set group permissions on `$HOME` and `~/sync`.
- Enable and start `rslsync`.
- Open or print the Resilio Sync web UI URL.
- Install Chezmoi.
- Run `chezmoi init --apply curtis2point1 --ssh`.
- Remove any packages listed in `packages_to_remove`.
- Install packages listed in `packages_to_add`.
- Install global npm package `@anthropic-ai/claude-code`.

### Existing Source Caveats

- `headless/run.sh` sources `$current_dir/packages.sh`, but `headless/packages.sh` is not present.
- Several copied steps are not clearly common Arch/TUI setup and likely need exclusion or separate machine-specific playbooks.
- Current scripts mix pre-Chezmoi bootstrap, Chezmoi installation, package installation, service setup, authentication, and repo cloning in one flow.

## Confirmed Refinement Decisions

- 2026-05-25: Install `micro` in `bootstrap.sh` so a terminal editor is available before Chezmoi applies dotfiles.
- 2026-05-25: Allow interactive `gh auth login` during bootstrap and let GitHub CLI upload the SSH key during authentication.
- 2026-05-25: Keep `bootstrap.sh` at the repo root for the shortest practical raw GitHub URL.
- 2026-05-25: Manage Micro configuration and plugins in Chezmoi after bootstrap.
- 2026-05-25: Create all common parent directories in Chezmoi, including `~/dev/curtis`, `~/dev/datm`, `~/dev/ripe`, and `~/dev/two-point-one`, but do not clone repositories in common setup.
- 2026-05-25: Exclude `stow` from the future common package list because Chezmoi replaces Stow for dotfile deployment.
- 2026-05-25: Manage Git identity through Chezmoi, preferably with `dot_gitconfig.tmpl`, rather than imperative `git config --global` commands.
- 2026-05-25: Replace the old NVM/Arch `nodejs` common setup with `mise` as the common runtime manager and install Node.js major version `24`.
- 2026-05-25: Install both `opencode` and Claude Code on all systems; Claude Code should use the native installer: `curl -fsSL https://claude.ai/install.sh | bash`.
- 2026-05-25: Include `wl-clipboard` only if it is required to resolve Micro, terminal, or SSH clipboard behavior; do not include it by default without confirming it helps non-Wayland/headless cases.
- 2026-05-25: Install `mise` through the package manager as part of common Chezmoi setup.
- 2026-05-25: Configure `mise` to install Node.js major version `24`, matching this machine's `~/.config/mise/config.toml` and project `mise.toml` policy.
- 2026-05-25: Update Chezmoi Bash config to activate package-manager `mise` from `PATH`; current machine still needs its native-script `mise` installation migrated to pacman later.
- 2026-05-25: Enable inbound SSH server access commonly by enabling and starting `sshd` on all systems.
- 2026-05-25: Install OpenCode with `yay` package `opencode-bin`.
- 2026-05-25: Investigate Micro/terminal/SSH clipboard behavior before adding `wl-clipboard` or other clipboard packages to common setup.
- 2026-05-25: Treat `git`, `github-cli`, `curl`, `micro`, and `openssh` as pre-Chezmoi bootstrap prerequisites; remove them from the Chezmoi common package list.
- 2026-05-25: Remove Micro plugin installation and `bash-language-server` from common setup because Micro LSP/linter plugins are not used.
- 2026-05-25: Add Google Cloud CLI and BigQuery CLI to common AUR packages; omit deprecated `google-cloud-cli-gsutil`.
- 2026-05-25: Configure Google Cloud interactively in Chezmoi with `gcloud init`, `gcloud auth application-default login`, and default project `two-point-one-dw`.
- 2026-05-25: Do not add Gemini CLI to common setup.
- 2026-05-25: Add Tailscale to common setup: install `tailscale`, enable/start `tailscaled`, and run `sudo tailscale up` when `tailscale status` fails.
- 2026-05-25: Add Resilio Sync to all systems using the packaged user-level `rslsync.service`, not the system service, to avoid file permission issues.
- 2026-05-25: Enable user lingering for Resilio Sync so the user service can run after logout.
- 2026-05-25: Configure Resilio Sync Web UI to listen on `0.0.0.0:8888` so it can be reached over Tailscale.
- 2026-05-25: Add common CLI/TUI tools `direnv`, `glow`, `mosh`, `navi`, `tree`, `zellij`, and `unzip`.
- 2026-05-25: Switch Micro common config to `clipboard = "terminal"` for OSC52 copy-over-SSH; do not add `wl-clipboard` to common packages because it only helps local Wayland clipboard access.
- 2026-05-25: Keep Resilio Sync in common setup for all systems.
- 2026-05-25: Use `ufw` as the default common firewall: deny incoming, allow outgoing, allow all inbound traffic on `tailscale0`, and require explicit rules for non-Tailscale inbound services.

## Proposed Grouping for Review

This grouping is a draft for review before implementation. The intent is to separate the minimum work needed to make Chezmoi usable from the common Arch/TUI setup Chezmoi should own.

### 1. Pre-Chezmoi Bootstrap

Purpose: prepare a fresh Arch system enough to run `chezmoi init --apply`.

Assumption: `bootstrap.sh` runs as the target non-root user with sudo privileges. User creation, `wheel` membership, and initial sudo enablement are platform/base-image prerequisites because SSH keys, GitHub CLI auth, and Chezmoi state are user-owned.

Recommended package dependencies:

- `sudo`
- `git`
- `openssh`
- `github-cli`
- `chezmoi`
- `curl`
- `micro`

Recommended setup steps:

- Update the base system with `pacman -Syu`.
- Install minimum bootstrap packages with `pacman -S --needed sudo git openssh github-cli chezmoi curl micro`.
- Generate an Ed25519 SSH key if one is missing.
- Create `~/.ssh/authorized_keys` if needed.
- Set SSH file permissions.
- Run interactive GitHub CLI authentication with SSH as the preferred Git protocol.
- Let GitHub CLI upload the generated SSH public key during authentication when prompted.
- Verify GitHub SSH access with `ssh -T git@github.com`.
- Create `~/dev/curtis` if this repo still needs to be cloned before Chezmoi is available.
- Run `chezmoi init --apply curtis2point1 --ssh` or the confirmed dotfiles repo target.

Recommended GitHub SSH dependency chain:

- `sudo` is available for package installation and system changes.
- `git`, `openssh`, `github-cli`, `chezmoi`, `curl`, and `micro` are installed.
- `~/.ssh` exists with secure permissions.
- `~/.ssh/id_ed25519` exists or is generated.
- GitHub CLI authentication runs interactively with SSH as the Git protocol: `gh auth login --hostname github.com --git-protocol ssh`.
- GitHub CLI uploads the generated SSH public key during authentication when prompted.
- If key upload is skipped or fails, the fallback is `gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication`.
- GitHub SSH access is verified with `ssh -T git@github.com`.
- Chezmoi is initialized over SSH.

Notes:

- Installing `openssh` is required for SSH client tools.
- Enabling or starting `sshd` is not required for cloning GitHub repositories over SSH during bootstrap, but common Chezmoi setup should enable inbound SSH server access later.
- `micro` should be installed in the pre-Chezmoi bootstrap so an editor is available before dotfiles are applied.
- Interactive `gh auth login` is acceptable for this bootstrap because it is a one-time trust/auth step on a new machine.
- The pre-Chezmoi bootstrap should be one script that executes this full sequence, using existing setup scripts as reference material rather than sourcing the current mixed setup flow directly.
- User creation, `wheel` membership, and initial sudoers configuration should remain in WSL, image-specific, or bare-metal install notes for now.

### Pre-Chezmoi Script Access Strategy

Recommended approach:

- Keep the canonical bootstrap script in this `arch-install` repo at the project root as `bootstrap.sh`.
- Make the script accessible without SSH GitHub auth, because its job is to create SSH GitHub auth.
- Store only the one-line invocation and manual fallback notes in Obsidian.
- Document the new-system steps and explicit script URL in the root `README.md`.

Preferred access pattern on a fresh system:

```bash
curl -fsSL https://raw.githubusercontent.com/curtis2point1/arch-install/main/bootstrap.sh | bash
```

Headless access options:

- If the machine has a console, type the one-line `curl | bash` command from the Obsidian note or another trusted reference.
- If the machine has temporary password SSH access, SSH in with the initial user and run the one-line command.
- If `curl` is unavailable but `pacman` works, install `curl` or use `git clone https://github.com/curtis2point1/arch-install.git` as a fallback before running the script locally.

Security and reliability notes:

- The raw script URL must point to a reviewed branch, tag, or commit before use on real machines.
- Prefer a pinned tag or commit for stable installs once the script is mature.
- Obsidian is useful as a human playbook, but should not be the canonical executable source because it is harder to fetch and run reliably on a new headless system.

Platform-specific pre-Chezmoi notes:

- WSL install commands, `/etc/wsl.conf`, and `wsl --terminate` belong in a WSL/headless playbook, not the common Chezmoi flow.
- Bare-metal install partitioning, bootloader, networking, and user creation details should remain outside this Chezmoi plan unless a later Arch install playbook is created.

### 2. Chezmoi Common Core Arch Setup

Purpose: install and configure packages and settings that should exist on every Arch system.

Common package manager/base dependencies:

- `base-devel`
- `yay`

Common shell and terminal packages:

- `shellcheck`
- `man-db`
- `less`
- `unzip`
- `jq`
- `direnv`
- `fd`
- `ripgrep`
- `fzf`
- `bat`
- `eza`
- `glow`
- `plocate`
- `zoxide`
- `starship`
- `7zip`
- `mosh`
- `navi`
- `tree`

Common TUI packages:

- `btop`
- `lazygit`
- `yazi`
- `zellij`
- `pacseek`

Common editor/config packages:

- `micro` is installed by `bootstrap.sh`; Chezmoi manages its config and plugins.

Common language/runtime packages and tools:

- `python`
- `uv`
- `ruff`
- `pre-commit`
- `ipython`
- `httpx`
- `mise`
- Node.js major version `24` managed by `mise`.
- `tailscale`
- `ufw`

Common AI/agent tooling:

- `opencode-bin`
- `google-cloud-cli`
- `google-cloud-cli-bq`
- `rslsync`
- Claude Code via `curl -fsSL https://claude.ai/install.sh | bash`.

Common Chezmoi-managed configuration steps:

- Install `yay` if missing.
- Install common pacman/AUR package lists from `.chezmoidata/arch-packages.yaml`.
- Create `~/.local/bin`.
- Ensure `~/.local/bin` is on `PATH` through a Chezmoi-managed shell file rather than mutating `~/.bashrc` imperatively.
- Install and configure `mise`.
- Configure `mise` with `node = "24"`.
- Install Node.js through `mise`.
- Install `uv`.
- Install global `uv` tools: `ruff`, `pre-commit`, `ipython`, `httpx`.
- Enable and start `sshd`.
- Configure Micro settings through Chezmoi-managed files.
- Set default editor through shell/profile configuration where possible.
- Create common directories: `~/notes`, `~/dev/curtis`, `~/dev/datm`, `~/dev/ripe`, `~/dev/two-point-one`.
- Configure global Git user email and name through Chezmoi-managed `dot_gitconfig.tmpl` rather than imperative `git config --global`.
- Configure Google Cloud account, application default credentials, and default project `two-point-one-dw`.
- Enable and start `tailscaled`.
- Run `sudo tailscale up` when Tailscale is not authenticated or reachable.
- Configure Resilio Sync with user-owned storage and Web UI on `0.0.0.0:8888`.
- Disable the system `rslsync` service if enabled.
- Enable linger for the current user.
- Enable and start the user-level `rslsync` service.
- Configure `ufw` to deny incoming traffic by default, allow outgoing traffic, allow all inbound traffic on `tailscale0`, and enable the firewall.

### 3. Exclude from Common Chezmoi Scope for Now

GUI desktop applications:

- `fsearch`
- `zed`
- `visual-studio-code-bin`
- `ghostty`
- `wl-clipboard`, because Micro uses terminal OSC52 clipboard mode for common SSH-friendly behavior.

Hardware-specific or desktop-specific tools:

- `nvtop`, unless NVIDIA monitoring is confirmed as common.

Network/service setup:

None currently; Tailscale moved into common setup.

Cloud and account authentication:

- GitHub CLI authentication and scope refresh
- `gh ssh-key add`

Server or machine-specific services:

- `docker`
- `docker-compose`
- `lazydocker`
- Docker service enable/start
- Adding user to the `docker` group
- `rslsync`
- System-level Resilio Sync service, group permission workaround, and browser launch are excluded because common setup uses the user service.

Client/work repository setup:

- Cloning selected work and personal repositories under `~/dev`.
- Any client-specific directories or repo lists beyond generic parent directory creation.

Potentially redundant after Chezmoi migration:

- Imperative edits to `~/.bashrc`, if Chezmoi owns shell configuration.
- Imperative edits to `/etc/environment`, unless default editor must be system-wide.

### 4. Open Grouping Questions

None.

Clipboard investigation notes:

- Micro's `clipboard = "external"` uses external tools on Linux such as `xclip`, `xsel`, or `wl-clipboard`; if those tools are missing or unusable, Micro falls back to an internal clipboard.
- Micro's `clipboard = "terminal"` uses terminal OSC52 behavior and can work over SSH when the terminal supports it.
- Micro's documentation notes that GNOME Terminal does not support this OSC52 feature.
- `wl-clipboard` can help local Wayland sessions but does not solve remote SSH clipboard access by itself.
- Current Chezmoi Micro settings use `clipboard = "terminal"`.
- Do not add `wl-clipboard` to common packages; keep it machine-specific if a local Wayland desktop needs it later.

## Proposed Chezmoi Dependency Chain

Use the pre-Chezmoi `bootstrap.sh` only to reach `chezmoi init --apply`. After Chezmoi starts, split common setup into small ordered scripts.

### Phase 0: Files Applied by Chezmoi

Chezmoi should manage these files directly where possible:

- Shell/profile configuration for `~/.local/bin` and `mise` activation.
- `~/.config/mise/config.toml` from `dot_config/mise/config.toml.tmpl` with Node.js major version `24`.
- Micro settings under `~/.config/micro/`.
- Git identity/config via `dot_gitconfig.tmpl`.
- Package data under `.chezmoidata/arch-packages.yaml`.

### Phase 1: Preflight and AUR Helper

Recommended scripts:

```text
run_once_before_00-arch-preflight.sh
run_once_before_10-arch-yay.sh
```

Responsibilities:

- Confirm the system is Arch Linux.
- Confirm the script is not running as root.
- Confirm `sudo` is available.
- Install `base-devel` and `git` if needed for AUR helper bootstrap.
- Install `yay` if missing.

### Phase 2: Common Packages

Recommended script:

```text
run_onchange_before_20-arch-common-packages.sh.tmpl
```

Responsibilities:

- Read package groups from `.chezmoidata/arch-packages.yaml`.
- Install common repo packages with `sudo pacman -S --needed --noconfirm` where possible.
- Install AUR packages with `yay -S --needed --noconfirm`.
- Keep `opencode-bin` in the AUR package list.
- Exclude `stow`.
- Exclude `wl-clipboard` until clipboard behavior is investigated.

Proposed package groups:

```yaml
pacman_common:
  - shellcheck
  - man-db
  - less
  - unzip
  - jq
  - direnv
  - fd
  - ripgrep
  - fzf
  - bat
  - eza
  - glow
  - plocate
  - zoxide
  - starship
  - 7zip
  - btop
  - lazygit
  - mosh
  - navi
  - tree
  - yazi
  - zellij
  - python
  - uv
  - mise
  - tailscale
  - ufw

aur_common:
  - google-cloud-cli
  - google-cloud-cli-bq
  - pacseek
  - opencode-bin
  - rslsync

gcloud_project: two-point-one-dw

mise_node: "24"

uv_tools:
  - ruff
  - pre-commit
  - ipython
  - httpx
```

### Phase 3: Directories and Services

Recommended scripts:

```text
run_once_after_30-common-directories.sh
run_onchange_after_40-common-services.sh
run_onchange_after_45-tailscale.sh
run_onchange_after_46-firewall.sh
run_onchange_after_47-resilio-sync.sh
```

Responsibilities:

- Create `~/.local/bin`.
- Create `~/notes`.
- Create `~/dev/curtis`, `~/dev/datm`, `~/dev/ripe`, and `~/dev/two-point-one`.
- Enable and start `sshd`.
- Enable and start `tailscaled`.
- Run `sudo tailscale up` when `tailscale status` fails.
- Configure Resilio Sync user config at `~/.config/rslsync/rslsync.conf`.
- Create `~/sync` and `~/.local/share/rslsync`.
- Disable the system `rslsync` service if enabled.
- Enable linger for the current user.
- Enable and start the user-level `rslsync` service.
- Configure `ufw` to deny inbound non-Tailscale traffic and allow all inbound traffic on `tailscale0`.

Resilio Sync implementation comparison:

- Existing `common/scripts/setup_resilio_sync.sh` installs `rslsync`, creates `~/sync`, adds group permissions between user `curtis` and system user `rslsync`, changes `$HOME`/`~/sync` group permissions, and enables the system `rslsync` service.
- Chezmoi implementation installs `rslsync` from AUR package data, uses the packaged user service from `/usr/lib/systemd/user/rslsync.service`, and stores data under the target user's home directory.
- Chezmoi implementation intentionally avoids `rslsync` system user/group permission changes because files are owned by the target user.
- Chezmoi implementation enables linger with `loginctl enable-linger "$USER"` so the user service can run after logout.
- Chezmoi implementation configures the Web UI listener as `0.0.0.0:8888` for access over Tailscale.
- Common `ufw` setup restricts inbound access to the Web UI to Tailscale unless a machine-specific rule opens port `8888` elsewhere.

Tailscale implementation comparison:

- Existing `common/scripts/setup_tailscale.sh` installs `tailscale`, enables/starts `tailscaled`, then runs `sudo tailscale up` if `tailscale status` fails.
- Chezmoi implementation keeps the same behavior but splits package installation into `.chezmoidata/arch-packages.yaml` and uses `run_onchange_after_45-tailscale.sh` only for service/auth setup.
- Chezmoi implementation uses `systemctl is-enabled --quiet tailscaled` instead of command substitution against `systemctl is-enabled` output.
- Chezmoi implementation checks that `tailscale` and `systemctl` exist before attempting setup.

### Phase 4: Runtime and Tool Configuration

Recommended scripts:

```text
run_onchange_after_50-mise-tools.sh.tmpl
run_onchange_after_60-python-tools.sh.tmpl
run_onchange_after_70-google-cloud.sh.tmpl
```

Responsibilities:

- Run `mise install` after Chezmoi applies `~/.config/mise/config.toml`.
- Install global Python tools with `uv tool install`: `ruff`, `pre-commit`, `ipython`, `httpx`.
- Run `gcloud init` if no Google Cloud account is configured.
- Run `gcloud auth application-default login` if ADC is not configured.
- Set the default Google Cloud project to `two-point-one-dw`.

### Phase 5: Curl/Bash Installers

Recommended script:

```text
run_onchange_after_80-curl-installers.sh
```

Responsibilities:

- Install Claude Code with `curl -fsSL https://claude.ai/install.sh | bash`.
- Confirm idempotency before running the installer on every Chezmoi apply.
- Do not install OpenCode here because `opencode-bin` belongs in the AUR package list.
- Use this script for tools whose supported install method is a curl/bash installer rather than pacman or AUR.

## Preferred Chezmoi Script Pattern

Use Chezmoi run scripts only for tasks that should be part of the common bootstrap process.

Recommended script types:

```text
run_once_before_00-arch-preflight.sh
run_once_before_10-arch-yay.sh
run_onchange_before_20-arch-common-packages.sh.tmpl
run_once_after_30-common-directories.sh
run_onchange_after_40-common-services.sh
run_onchange_after_45-tailscale.sh
run_onchange_after_46-firewall.sh
run_onchange_after_50-mise-tools.sh.tmpl
run_onchange_after_60-python-tools.sh.tmpl
run_onchange_after_70-google-cloud.sh.tmpl
run_onchange_after_80-curl-installers.sh
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
├── run_once_before_00-arch-preflight.sh
├── run_once_before_10-arch-yay.sh
├── run_onchange_before_20-arch-common-packages.sh.tmpl
├── run_once_after_30-common-directories.sh
├── run_onchange_after_40-common-services.sh
├── run_onchange_after_45-tailscale.sh
├── run_onchange_after_46-firewall.sh
├── run_onchange_after_47-resilio-sync.sh
├── run_onchange_after_50-mise-tools.sh.tmpl
├── run_onchange_after_60-python-tools.sh.tmpl
├── run_onchange_after_70-google-cloud.sh.tmpl
├── run_onchange_after_80-curl-installers.sh
├── .chezmoidata/
│   └── arch-packages.yaml
├── dot_config/
│   ├── mise/
│   │   └── config.toml.tmpl
│   └── micro/
│       └── settings.json
│   └── rslsync/
│       └── rslsync.conf.tmpl
├── dot_bashrc
├── dot_gitconfig.tmpl
└── README.md
```

## Package Data

Prefer storing package lists in a data file rather than hardcoding everything directly inside scripts.

Example:

```yaml
# .chezmoidata/arch-packages.yaml

pacman_common:
  - shellcheck
  - man-db
  - less
  - unzip
  - jq
  - direnv
  - fd
  - ripgrep
  - fzf
  - bat
  - eza
  - glow
  - plocate
  - zoxide
  - starship
  - 7zip
  - btop
  - lazygit
  - mosh
  - navi
  - tree
  - yazi
  - zellij
  - python
  - uv
  - mise
  - tailscale
  - ufw

aur_common:
  - google-cloud-cli
  - google-cloud-cli-bq
  - pacseek
  - opencode-bin
  - rslsync

gcloud_project: two-point-one-dw

mise_node: "24"

uv_tools:
  - ruff
  - pre-commit
  - ipython
  - httpx
```

Then use a templated script such as:

```text
run_onchange_before_20-arch-common-packages.sh.tmpl
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

## Progress Log

### 2026-05-25 - Bootstrap and Chezmoi Common Setup Draft

- Changed: Added root-level `bootstrap.sh` to this repo for pre-Chezmoi GitHub SSH auth and Chezmoi initialization.
- Changed: Added common Chezmoi package data and ordered run scripts in `~/.local/share/chezmoi`.
- Changed: Added Chezmoi-managed `mise` config template for Node.js major version `24`.
- Changed: Updated Chezmoi-managed Bash config to activate `mise` from `PATH`, so package-manager installs work.
- Changed: Added Chezmoi-managed `dot_gitconfig.tmpl` preserving current rendered Git identity and existing Git defaults.
- Changed: Removed bootstrap prerequisite packages from Chezmoi common package data: `git`, `github-cli`, `curl`, `micro`, and `openssh`.
- Changed: Added Google Cloud CLI/BQ packages and guarded Google Cloud auth/default project setup to Chezmoi.
- Changed: Added Tailscale package and guarded Tailscale service/auth setup to Chezmoi.
- Changed: Added Resilio Sync package, user-level config, linger setup, and user service enablement to Chezmoi.
- Files touched: `bootstrap.sh`, `README.md`, `plans/chezmoi-common-arch-bootstrap-spec.md`.
- Chezmoi files touched: `.chezmoidata/arch-packages.yaml`, `dot_bashrc`, `run_once_before_00-arch-preflight.sh`, `run_once_before_10-arch-yay.sh`, `run_onchange_before_20-arch-common-packages.sh.tmpl`, `run_once_after_30-common-directories.sh`, `run_onchange_after_40-common-services.sh`, `run_onchange_after_45-tailscale.sh`, `run_onchange_after_47-resilio-sync.sh`, `run_onchange_after_50-mise-tools.sh.tmpl`, `run_onchange_after_60-python-tools.sh.tmpl`, `run_onchange_after_70-google-cloud.sh.tmpl`, `run_onchange_after_80-curl-installers.sh`, `dot_config/mise/config.toml.tmpl`, `dot_config/rslsync/rslsync.conf.tmpl`, `dot_gitconfig.tmpl`.
- Verification: `shellcheck bootstrap.sh`; `shellcheck` on new static Chezmoi scripts; `chezmoi execute-template` piped to `shellcheck` for templated Chezmoi scripts; `chezmoi diff` dry run.
- Findings: Initial `dot_gitconfig.tmpl` would have removed existing Git defaults, so it was corrected to preserve current rendered `.gitconfig` behavior.
- Findings: `dot_bashrc` has pre-existing ShellCheck warnings unrelated to the `mise` activation change.
- Findings: `chezmoi diff` still reports mode-only changes for `.config/yazi/yazi-default.toml` and `.gitconfig`; review before applying.
- Blockers: None currently.
- Next: Review before any real `chezmoi apply`.

### 2026-05-25 - Micro OSC52 Clipboard Decision

- Changed: Switched Chezmoi-managed Micro config from external clipboard helpers to terminal OSC52 clipboard mode.
- Files touched: `plans/chezmoi-common-arch-bootstrap-spec.md`.
- Chezmoi files touched: `dot_config/micro/settings.json`.
- Verification: `jq empty ~/.local/share/chezmoi/dot_config/micro/settings.json`.
- Findings: Micro documents `clipboard = "terminal"` as the mode that works over SSH via OSC52; WezTerm allows OSC52 clipboard writes but ignores read queries; Windows Terminal exposes `compatibility.allowOSC52` defaulting to `true` for OSC52 clipboard writes.
- Blockers: Paste through Micro's own clipboard command may depend on terminal OSC52 read support; terminal paste shortcuts remain the practical fallback for terminals that only support writes.
- Next: Review before any real `chezmoi apply`.

### 2026-05-25 - UFW Tailscale-Only Inbound Baseline

- Changed: Added `ufw` to common pacman packages.
- Changed: Added a Chezmoi firewall setup script that denies incoming traffic by default, allows outgoing traffic, allows all inbound traffic on `tailscale0`, and enables `ufw`.
- Files touched: `plans/chezmoi-common-arch-bootstrap-spec.md`.
- Chezmoi files touched: `.chezmoidata/arch-packages.yaml`, `run_onchange_after_46-firewall.sh`.
- Findings: Tailscale's own UFW hardening guidance uses `sudo ufw default deny incoming`, `sudo ufw default allow outgoing`, and `sudo ufw allow in on tailscale0` so services are reachable over Tailscale but not public/LAN interfaces by default.
- Residual risk: Non-Tailscale inbound access such as LAN SSH, LAN Resilio Web UI, public web apps, or direct LAN service discovery will be blocked unless a machine-specific rule explicitly opens it.
- Next: Review before any real `chezmoi apply`.

## Future Direction

If machine-specific setup becomes repetitive enough, consider moving those workflows to Ansible later.

For now:

- Chezmoi = dotfiles + common Arch bootstrap
- Existing setup repo / Obsidian = machine-specific playbooks
- Ansible = optional future system provisioning layer
