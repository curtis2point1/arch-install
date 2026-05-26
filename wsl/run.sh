#!/usr/bin/env bash
set -euo pipefail

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
repo_root=$(dirname -- "$current_dir")
scripts_dir="$repo_root/common/scripts"

# shellcheck source=../common/scripts/utilities.sh disable=SC1091
source "$scripts_dir/utilities.sh"

packages=(
  wslu
)

is_wsl() {
  grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
}

setup_browser_handlers() {
  if command -v gio >/dev/null 2>&1 && command -v wslview >/dev/null 2>&1; then
    gio mime x-scheme-handler/https wslview.desktop
    gio mime x-scheme-handler/http wslview.desktop
  else
    printf 'gio or wslview not found; skipping browser handler setup.\n'
  fi
}

main() {
  if ! is_wsl; then
    printf 'Error: WSL layer should only be run inside WSL.\n' >&2
    exit 1
  fi

  prime_sudo
  install_packages "${packages[@]}"
  setup_browser_handlers
  printf 'WSL layer complete. Ensure /etc/wsl.conf sets the default user if this is a new distro.\n'
}

main "$@"
