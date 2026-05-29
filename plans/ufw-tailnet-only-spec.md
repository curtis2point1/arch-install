# UFW Tailnet-Only Firewall — Setup Spec

## Context

Services on personal workstations and servers (OpenCode server, Dagster, Metabase, etc.) need to be accessible from:

- The host itself (loopback)
- Other devices on the Tailscale network

They should **not** be reachable from the public internet or local LAN.

## Approach

Bind services to `0.0.0.0` as normal, then use UFW to filter inbound traffic by interface:

- Allow `lo` (same-machine access)
- Allow `tailscale0` (all tailnet traffic, including SSH)
- Deny everything else inbound

### Why interface-based filtering (not subnet-based)

- Covers IPv4 (`100.64.0.0/10`) and IPv6 (`fd7a:115c:a1e0::/48`) automatically
- Survives changes to Tailscale's address allocation
- One rule covers all current and future services on the host
- Services stay vanilla — no per-service binding logic or systemd ordering

### Why no WAN SSH

SSH access is fully covered by the `tailscale0` rule. Removing public SSH eliminates the largest attack surface on the host.

## Tradeoffs

- **Bootstrap dependency**: Tailscale must be installed and authenticated before applying the firewall, or the host becomes unreachable.
- **Tailscale outage = no remote access**: If Tailscale auth/network fails, the host is reachable only via console. Acceptable for personal infrastructure; not appropriate for production where out-of-band access is critical.
- **All-or-nothing on `tailscale0`**: Any service bound to `0.0.0.0` becomes reachable to every tailnet device. Use Tailscale ACLs if finer control is needed.

## Deployment Order (fresh host)

1. SSH in via WAN
2. Install and authenticate Tailscale; confirm `tailscale ip -4` returns an address
3. Open a second SSH session over the Tailscale IP to verify connectivity
4. Run the script in the Tailscale session
5. Confirm WAN SSH is blocked and Tailscale SSH still works

## Chezmoi Placement

- **Profile**: server (and optionally desktop, if desktops also host tailnet-only services)
- **Filename**: `run_once_after_ufw-tailnet-only.sh`
- **Prefix behavior**: `run_once_after_` runs the script once after `chezmoi apply`. Chezmoi tracks the hash in its state; re-runs only when the script content changes.

## Script

```bash
#!/usr/bin/env bash
# run_once_after_ufw-tailnet-only.sh
# Configures UFW to allow inbound traffic only from loopback and tailscale0.
# All external/WAN inbound traffic is blocked, including SSH.

set -euo pipefail

# Verify ufw is installed
if ! command -v ufw >/dev/null 2>&1; then
    echo "ERROR: ufw not installed. Install with: sudo pacman -S ufw" >&2
    exit 1
fi

# Verify tailscale0 interface exists (warn but don't fail — interface may come up later)
if ! ip link show tailscale0 >/dev/null 2>&1; then
    echo "WARNING: tailscale0 interface not found. Rules will apply once tailscale starts." >&2
fi

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow loopback (same-machine access to services)
sudo ufw allow in on lo

# Allow all traffic from tailnet (includes SSH, service ports, etc.)
sudo ufw allow in on tailscale0

# Enable (idempotent — safe to re-run)
sudo ufw --force enable

# Show resulting config
sudo ufw status verbose
```

## Verification

After applying:

```bash
# Should show: Status: active, Default: deny (incoming), Anywhere on lo + tailscale0 allowed
sudo ufw status verbose

# From another tailnet device — should succeed
ssh user@<tailscale-hostname>

# From a WAN connection — should time out / connection refused
ssh user@<public-ip>
```

## Rollback

```bash
sudo ufw disable
# or, to wipe all rules:
sudo ufw --force reset
```
