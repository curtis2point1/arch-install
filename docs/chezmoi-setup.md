# Chezmoi Setup

## Purpose

Chezmoi owns the repeatable machine state after the initial bootstrap: packages, dotfiles, app config, common services, and eventually role-specific setup.

This `arch-install` repo remains the central AI working repo and knowledge base for managing both Chezmoi and the pre-Chezmoi bootstrap script. The long-term code boundary is:

- `arch-install`: minimal pre-Chezmoi bootstrap, recovery notes, plans, and setup documentation.
- Chezmoi: common setup, role setup, dotfiles, package data, services, and application configuration.

## Source Locations

- Chezmoi source directory: `~/.local/share/chezmoi`
- Chezmoi package data: `~/.local/share/chezmoi/.chezmoidata/arch-packages.yaml`
- Bootstrap repo: `/home/curtis/dev/curtis/arch-install`
- Active migration plan: `plans/chezmoi-role-migration.md`
- Recent repo-local context: `scratchpad.md`

## Bootstrap Boundary

The root `bootstrap.sh` prepares a fresh Arch or WSL environment enough to run Chezmoi. It currently:

- Requires the target non-root user to have sudo privileges.
- Enables user lingering.
- Installs bootstrap packages: `sudo`, `git`, `openssh`, `github-cli`, `chezmoi`, `curl`, and `micro`.
- Creates or repairs an Ed25519 SSH keypair.
- Authenticates GitHub CLI using SSH.
- Uploads the SSH public key to GitHub when needed.
- Verifies GitHub SSH access.
- Runs `chezmoi update` if the source repo already exists, otherwise `chezmoi init --apply`.

Do not add post-bootstrap package groups, desktop setup, service setup, or app config to this repo unless it is required before Chezmoi can run.

## Current Chezmoi Common Data

Current common package data is in `.chezmoidata/arch-packages.yaml`.

Pacman common packages:

- `shellcheck`, `man-db`, `less`, `unzip`, `jq`, `direnv`, `fd`, `ripgrep`, `fzf`, `bat`, `eza`, `glow`, `typst`, `plocate`, `zoxide`, `starship`, `7zip`, `btop`, `lazygit`, `mosh`, `navi`, `tree`, `yazi`, `zellij`, `python`, `uv`, `mise`, `tailscale`, `ufw`, `ghostty-terminfo`

AUR common packages:

- `claude-code`, `google-cloud-cli`, `google-cloud-cli-bq`, `pacseek`, `opencode-bin`, `rslsync`

Other common data:

- `gcloud_project`: `two-point-one-dw`
- `mise_node`: `24`
- `uv_tools`: `ruff`, `pre-commit`, `ipython`, `httpx`

## Current Chezmoi Scripts

Chezmoi setup scripts are ordered by filename and should remain idempotent where possible.

- `run_once_before_00-arch-preflight.sh`: verifies target user, Arch Linux, `sudo`, and primes sudo.
- `run_once_before_10-arch-yay.sh`: installs `yay` when missing, using `git` and `base-devel`.
- `run_onchange_before_20-arch-common-packages.sh.tmpl`: installs common pacman and AUR packages from `.chezmoidata/arch-packages.yaml`.
- `run_once_after_30-common-directories.sh`: creates common directories under `~/.local`, `~/sync`, `~/vaults`, and `~/dev`.
- `run_onchange_after_40-common-services.sh`: enables and starts `sshd`.
- `run_onchange_after_45-tailscale.sh`: enables and starts `tailscaled`, then runs `tailscale up` if not authenticated.
- `run_onchange_after_46-firewall.sh`: configures UFW default deny incoming, default allow outgoing, allows inbound on `tailscale0`, enables UFW, and starts `ufw.service` when systemd is available.
- `run_onchange_after_47-resilio-sync.sh`: prepares Resilio directories, disables the system `rslsync` service if active, enables user lingering, and enables the user `rslsync` service.
- `run_onchange_after_50-mise-tools.sh.tmpl`: installs Node through `mise` using `mise_node`.
- `run_onchange_after_60-python-tools.sh.tmpl`: installs configured `uv` tools when missing.
- `run_onchange_after_70-google-cloud.sh.tmpl`: runs interactive Google Cloud auth/config when needed and sets the default project.
- `run_onchange_after_80-curl-installers.sh`: reserved placeholder; no curl-based installers are currently configured.

## Managed Dotfiles And Config

Chezmoi currently manages these major config areas:

- Bash: `.bashrc`, aliases, PATH setup, `mise`, `zoxide`, `navi`, `fzf`, `eza`, `opencode` attach helper, Yazi directory-change helper, and local override loading.
- Chezmoi helper functions: `dotgit`, `dotdiff`, `dotapply`, `dotadd`, `dotpull`, and `dotpush` in `~/.config/bash/dotfunctions.sh`.
- Git: global identity and default pull/init behavior through `dot_gitconfig.tmpl`.
- Micro: terminal clipboard, wrapping, tab, and color settings.
- Mise: Node version from `.chezmoidata`.
- Resilio Sync: templated device name, storage path, PID path, and Web UI listening on `127.0.0.1:8888`.
- OpenCode: global `AGENTS.md`, commands, skills, `opencode.json`, and TUI config.
- Claude: `CLAUDE.md`, settings, statusline script, and placeholder directories.
- Navi: exact cheats for Chezmoi, Git, SSH, Yazi, Caddy, Tmux, Yay, Google Cloud, UV, Harlequin, Tailscale, systemctl, and related workflows.
- Yazi: manager layout, preview wrapping, keymap, init, and theme files.
- Tmux: prefix, mouse, base index, and history settings.
- SQLFluff: global BigQuery/raw templater defaults and lowercase capitalization policy.
- Git Scope: repository roots include `~/dev/curtis`, `~/dev/pretty-litter`, `~/dev/two-point-one`, and `~/.local/share/chezmoi`.

## Role Migration Target

The remaining open setup work is to move current scenario behavior into Chezmoi roles:

- `server`: Docker, Caddy reverse proxy for OpenCode/Resilio via short `2p1.dev` service hostnames, server tools, and `opencode-web.service`.
- `gui`: graphical baseline packages, fonts, Flatpak/Flathub if still desired, and GUI user services if retained.
- `gnome`: GNOME packages, `ydotoold`, Voxtype, portals, settings, and keybindings.
- `hyprland`: empty until exact package list and configuration strategy are confirmed.
- `wsl`: `wslu`, browser handler integration, and any safe WSL-only automation.

Open design questions live in `plans/chezmoi-role-migration.md`.

## Server HTTPS Routing Decision

- Use Cloudflare-managed DNS records under `2p1.dev` for primary server service URLs.
- Do not include the machine name in service URLs because there will be one primary server for these mappings and shorter URLs are preferred.
- Target URL shape: `https://opencode.2p1.dev`, `https://sync.2p1.dev`, and future `https://<service>.2p1.dev` names.
- Publish Cloudflare DNS-only records, either per-service or wildcard, pointing to the primary server's Tailscale IP.
- Use Caddy with the Cloudflare DNS provider module to obtain certificates through DNS-01 challenges.
- Keep upstream services bound to localhost-only ports and reverse proxy from Caddy by hostname.
- Avoid path-based routing because app assets, redirects, cookies, WebSockets, and SPA routing often assume `/`.
- Avoid `service.machine.tailnet.ts.net` as the primary plan because Tailscale-managed certificates do not appear to support arbitrary subdomains below a machine MagicDNS name.
- Keep explicit external ports on `machine.tailnet.ts.net` only as a fallback.
- Use Google Cloud Secret Manager as the source of truth for Cloudflare API credentials because GCP and ADC are core dependencies on managed Linux installs.
- Materialize secrets into per-service env files for runtime use rather than making each app talk to Secret Manager directly.
- For Caddy, materialize the Cloudflare DNS token to a root-owned env file such as `/etc/caddy/cloudflare.env`, load it with a systemd `EnvironmentFile=`, and reference the value from the Caddyfile.
- Prefer per-service env files over one global secrets file so each service receives only the secrets it needs.
- For non-service apps, prefer app-native auth or config. Use `direnv`/ignored project env files for project-local secrets, and use the same Secret Manager materialization pattern only when a CLI or user service needs a reusable local secret file.

## Safe Verification

Allowed without explicit approval:

- Read files in this repo or in `~/.local/share/chezmoi`.
- Run static checks against edited shell scripts, such as `shellcheck path/to/script.sh`, when no scripts are executed.
- Run non-mutating git inspection commands such as `git status` and `git diff`.

Requires explicit Curtis approval:

- `bootstrap.sh`
- Chezmoi `apply`, `update`, or `init --apply`
- Chezmoi run scripts
- Scenario `run.sh` scripts while they remain in this repo
- Commands that install packages, enable services, authenticate tools, or mutate `$HOME`
