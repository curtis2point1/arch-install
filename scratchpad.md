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

## Checkpoints

### 2026-05-30 - Chezmoi Server HTTPS

- Status: documented the routing decision; ready to resume implementation after context reset.
- Completed: added durable docs for Cloudflare-managed short service domains under `2p1.dev`, chose Google Cloud Secret Manager with per-service materialized env files for secrets, and queued the work item.
- Plan: `plans/chezmoi-role-migration.md`.
- Decisions: use URLs like `opencode.2p1.dev` and `sync.2p1.dev`; omit machine names; use Cloudflare DNS-only records to the primary server's Tailscale IP; use Caddy with Cloudflare DNS-01; avoid path routing and `service.machine.tailnet.ts.net` as primary plans; do not assume future 1Password usage; use Google Cloud Secret Manager as source of truth and per-service env files loaded by systemd for service secrets.
- Touched/planned files: `docs/chezmoi-setup.md`, `plans/chezmoi-role-migration.md`, `scratchpad.md`, future Chezmoi Caddy/server role files under `~/.local/share/chezmoi`.
- Open questions: exact helper script interface for materializing Google Secret Manager values into local env files.
- Next: implement Chezmoi server-role Caddy package/config/service changes using Google Secret Manager as source of truth and per-service env files loaded by systemd.
- Promote candidates: none.

## Queued Tasks

- Implement primary-server custom service domains with Cloudflare and Caddy. Use short service URLs under `2p1.dev` without machine names because there will be one primary server for these mappings. Example targets: `opencode.2p1.dev` and `sync.2p1.dev`. Publish Cloudflare DNS-only records to the primary server's Tailscale IP, use Caddy with the Cloudflare DNS provider for DNS-01 certificates, and reverse proxy each hostname to localhost-only service ports. Do not use path routing, `.ts.net` service subdomains, or 1Password-based token handling as the primary plan. Use Google Cloud Secret Manager as the source of truth for the Cloudflare token, materialized into a per-service Caddy env file and loaded by systemd.
- Add a Chezmoi script to configure SSH settings so SSH login uses keys only and does not allow password authentication.
- Review and implement the Chezmoi UFW firewall update to allow loopback and Tailscale connections while continuing to deny unintended inbound traffic.
- Add a Chezmoi script to configure passwordless sudo for the `wheel` group.

Passwordless sudo template:

```bash
#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

cat > "$tmp" <<'EOF'
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF

visudo -cf "$tmp"
sudo install -m 0440 -o root -g root "$tmp" /etc/sudoers.d/10-wheel-nopasswd
```
