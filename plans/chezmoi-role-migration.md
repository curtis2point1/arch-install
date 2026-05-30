# Chezmoi Role Migration

## Goal

Move post-bootstrap scenario setup from this repo into Chezmoi role-based scripts so package ownership, service configuration, and dotfiles live in one place.

This repo should become a small bootstrap repo for getting a new Arch or WSL environment ready to run Chezmoi.

## Success Criteria

- [ ] Chezmoi has explicit machine role definitions for `server`, `gui`, `gnome`, `hyprland`, and `wsl`.
- [ ] Chezmoi package data separates common packages from role-specific packages.
- [ ] Chezmoi scripts handle current server, GUI, GNOME, and WSL layer behavior.
- [ ] This repo no longer owns post-Chezmoi scenario setup scripts once migration is complete.
- [ ] This repo keeps only bootstrap docs/scripts needed before Chezmoi can run.
- [ ] Migration is reviewable in small steps and avoids changing install behavior before approval.

## Current State

- Status: active
- Current step: Proposal documented for review.
- Next action: Review this proposal, then decide whether to scaffold Chezmoi roles and initial scripts.

## Open Questions

- Where should per-machine role data live: Chezmoi config data, `.chezmoidata` host map, or another explicit mechanism?
- Should role scripts fail hard when prerequisites are missing, or skip with warnings for partially configured machines?
- Should Docker remain server-only, or should some GUI workstations also include Docker via a separate `docker` capability role?
- What exact helper script interface should Chezmoi use to materialize Google Secret Manager values into local env files?

## Decisions

- 2026-05-26: Keep this repo for pre-Chezmoi bootstrap concerns only.
- 2026-05-26: Move scenario setup into Chezmoi after review: package groups, service enablement, user services, desktop settings, and WSL handlers.
- 2026-05-26: Use explicit roles rather than inferred hostname behavior.
- 2026-05-26: Use canonical `hyprland` spelling for the Hyprland role.
- 2026-05-26: Do not create Chezmoi scaffolding until this proposal is reviewed.
- 2026-05-30: Keep Resilio Sync common, but bind its Web UI to localhost only on common installs. Install Caddy only for the `server` role; server Caddy should expose OpenCode and Resilio.
- 2026-05-30: Use short Cloudflare-managed service hostnames under `2p1.dev` for the primary server, such as `opencode.2p1.dev` and `sync.2p1.dev`. Do not include the machine name in these URLs.
- 2026-05-30: Use Cloudflare DNS-01 certificates through Caddy for custom service domains. Keep path routing and `service.machine.tailnet.ts.net` out of the primary plan; use explicit `machine.tailnet.ts.net:<port>` URLs only as fallback.
- 2026-05-30: Do not plan future setup around 1Password.
- 2026-05-30: Use Google Cloud Secret Manager as the source of truth for managed Linux secrets because GCP and ADC are expected on these systems. Materialize secrets into per-service env files, then load them through systemd `EnvironmentFile=` for services. Do not use one global env file for all services.

## Proposed Boundary

### This Repo Owns

- Initial Arch or WSL bootstrap documentation.
- Minimal bootstrap script that can run before Chezmoi exists.
- Installing prerequisites required to fetch/apply Chezmoi: `sudo`, `git`, `openssh`, `github-cli`, `chezmoi`, `curl`, and `micro`.
- Initial SSH key and GitHub authentication flow.
- User lingering if user-level services need to survive logout.
- Recovery or manual notes for first-boot cases that cannot be safely automated from Chezmoi.

### Chezmoi Owns

- Common package installation.
- Role-specific package installation.
- Dotfiles and application config.
- System services and user services.
- GNOME settings and keybindings.
- WSL-only app integration.
- Server role setup such as Docker, Caddy installation, and `opencode-web.service`.

## Proposed Role Model

Roles should be explicit per machine. A machine may have more than one role.

- `server`: headless/server-oriented services and tools.
- `gui`: graphical baseline shared by desktop environments.
- `gnome`: GNOME-specific packages, settings, services, and keybindings. Requires `gui`.
- `hyprland`: Hyprland-specific packages, portal choice, launcher/status bar, and keybindings. Requires `gui`.
- `wsl`: WSL-only packages and integration behavior.

Potential future capability roles if needed:

- `docker`: Docker packages, service enablement, and group membership if Docker should not be server-only.
- `caddy`: Caddy package/service/config if Caddy should not be server-only.

## Proposed Chezmoi Data Shape

Current package data lives in `.chezmoidata/arch-packages.yaml`. Extend it from common-only lists to role-aware lists.

```yaml
pacman_common:
  - shellcheck
  - man-db
  - less
  - unzip
  - jq

aur_common:
  - claude-code
  - opencode-bin

pacman_server:
  - caddy
  - docker
  - docker-compose
  - lazydocker

aur_server: []

pacman_gui:
  - ghostty
  - google-chrome
  - walker

aur_gui:
  - visual-studio-code-bin

pacman_gnome:
  - voxtype
  - wl-clipboard
  - wtype
  - xdg-desktop-portal-gnome
  - ydotool

aur_gnome: []

pacman_hyprland: []
aur_hyprland: []

pacman_wsl:
  - wslu

aur_wsl: []
```

Machine roles could be configured separately from package data. Example shape:

```yaml
roles:
  - server
  - gui
  - gnome
```

## Proposed Chezmoi Script Structure

Keep scripts ordered by dependency and use templates for role conditionals.

```text
run_once_before_00-arch-preflight.sh
run_once_before_10-arch-yay.sh
run_onchange_before_20-arch-packages.sh.tmpl
run_once_after_30-common-directories.sh
run_onchange_after_40-common-services.sh.tmpl
run_onchange_after_45-tailscale.sh
run_onchange_after_46-firewall.sh
run_onchange_after_47-resilio-sync.sh
run_onchange_after_50-mise-tools.sh.tmpl
run_onchange_after_60-python-tools.sh.tmpl
run_onchange_after_70-google-cloud.sh.tmpl
run_onchange_after_80-curl-installers.sh
run_onchange_after_90-server-services.sh.tmpl
run_onchange_after_91-gui-setup.sh.tmpl
run_onchange_after_92-gnome-setup.sh.tmpl
run_onchange_after_93-hyprland-setup.sh.tmpl
run_onchange_after_94-wsl-setup.sh.tmpl
```

The exact numbering can change, but role scripts should run after package installation.

## Proposed Initial Role Behavior

### `server`

- Install `caddy`, `docker`, `docker-compose`, and `lazydocker`.
- Enable and start `docker.service`.
- Add the current user to the `docker` group when missing.
- Create/update `~/.config/systemd/user/opencode-web.service` using the already-installed `opencode` from common setup.
- Enable and start `opencode-web.service`.
- Manage a Caddyfile that exposes OpenCode and Resilio through Caddy, then enable and start `caddy.service`.
- Keep upstream app listeners on localhost. Use a different upstream port when Caddy listens on the same external port, unless Caddy is explicitly bound to a non-localhost interface address.
- Use Cloudflare DNS-only records under `2p1.dev` for short service hostnames without machine names, such as `opencode.2p1.dev` and `sync.2p1.dev`.
- Use Caddy with a Cloudflare DNS provider module for DNS-01 certificate issuance. Store the Cloudflare API token in Google Cloud Secret Manager and materialize it to a per-service env file such as `/etc/caddy/cloudflare.env`; load that file with a Caddy systemd `EnvironmentFile=` override.
- Avoid path-based routing by default because many apps assume they are mounted at `/`.

### `gui`

- Install GUI baseline packages.
- Install bundled fonts into `~/.local/share/fonts` and refresh font cache.
- Configure Flatpak and Flathub if still desired.
- Configure Walker and Elephant user services if those remain part of the GUI baseline.

### `gnome`

- Install GNOME-specific packages.
- Configure `ydotoold.service` as a user service.
- Install/configure Voxtype and its model.
- Apply GNOME workspace/keybinding settings through `gsettings`.

### `hyprland`

- Keep empty until exact package list, portal, launcher/status bar, and keybinding strategy are confirmed.

### `wsl`

- Install `wslu`.
- Set HTTP/HTTPS handlers to `wslview.desktop` when `gio` and `wslview` are available.
- Keep first-boot WSL user/default-user setup as documentation unless a safe automation path is confirmed.

## Migration Plan

1. Review and approve this proposal.
2. Add role data scaffolding in Chezmoi without changing behavior.
3. Update the package install template to include common packages plus packages for selected roles.
4. Move server service behavior into a Chezmoi role script.
5. Move WSL behavior into a Chezmoi role script.
6. Move GUI and GNOME behavior into Chezmoi role scripts.
7. Leave Hyprland as an empty role until requirements are known.
8. Simplify this repo to bootstrap-only docs/scripts after Chezmoi role setup is verified.

## Progress Log

### 2026-05-26 - Decision Documented

- Changed: Created this migration proposal.
- Files touched: `plans/chezmoi-role-migration.md`.
- Findings: Current scenario scripts are all post-Chezmoi concerns and fit Chezmoi role scripts.
- Blockers: Awaiting review before creating Chezmoi scaffolding.
- Next: Review role definitions, data shape, and script structure.
