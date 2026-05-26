#!/usr/bin/env bash
set -euo pipefail

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
repo_root=$(dirname -- "$current_dir")
scripts_dir="$repo_root/common/scripts"

# shellcheck source=../common/scripts/utilities.sh disable=SC1091
source "$scripts_dir/utilities.sh"

packages=(
  docker
  docker-compose
  lazydocker
)

setup_docker() {
  install_packages "${packages[@]}"

  sudo systemctl enable --now docker

  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    printf '%s is already in the docker group.\n' "$USER"
  else
    sudo usermod -aG docker "$USER"
    printf 'Added %s to the docker group; log out and back in for this shell to see it.\n' "$USER"
  fi
}

main() {
  prime_sudo
  setup_docker
  printf 'Server layer complete.\n'
}

main "$@"
