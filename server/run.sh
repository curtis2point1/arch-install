#!/usr/bin/env bash
set -euo pipefail

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
repo_root=$(dirname -- "$current_dir")
scripts_dir="$repo_root/common/scripts"

# shellcheck source=../common/scripts/utilities.sh disable=SC1091
source "$scripts_dir/utilities.sh"

packages=(
  caddy
  docker
  docker-compose
  lazydocker
)

setup_docker() {
  sudo systemctl enable --now docker

  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    printf '%s is already in the docker group.\n' "$USER"
  else
    sudo usermod -aG docker "$USER"
    printf 'Added %s to the docker group; log out and back in for this shell to see it.\n' "$USER"
  fi
}

setup_opencode_web() {
  local service_name="opencode-web.service"
  local service_path="$HOME/.config/systemd/user/$service_name"
  local opencode_path

  if ! opencode_path="$(command -v opencode)"; then
    printf 'opencode command not found; run common setup before configuring the opencode web service.\n' >&2
    return 1
  fi

  mkdir -p "$HOME/.config/systemd/user"

  cat >"$service_path" <<EOF
[Unit]
Description=opencode web server
Documentation=https://opencode.ai
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=$HOME
ExecStart=$opencode_path serve
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now "$service_name"
}

main() {
  prime_sudo
  install_packages "${packages[@]}"
  setup_docker
  setup_opencode_web
  printf 'Server layer complete.\n'
}

main "$@"
