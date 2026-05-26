#!/usr/bin/env bash
set -euo pipefail

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
repo_root=$(dirname -- "$current_dir")
scripts_dir="$repo_root/common/scripts"
fonts_dir="$repo_root/common/fonts"

# shellcheck source=../common/scripts/utilities.sh disable=SC1091
source "$scripts_dir/utilities.sh"

packages=(
  1password
  1password-cli
  datagrip
  datagrip-jre
  easyeffects
  elephant-all
  fsearch
  ghostty
  google-chrome
  guvcview
  lite-xl
  lpm
  obs-studio
  pavucontrol
  pipewire
  pipewire-pulse
  slack-desktop
  spotify
  typora
  visual-studio-code-bin
  walker
  zed
)

install_fonts() {
  if ! compgen -G "$fonts_dir/*.ttf" >/dev/null; then
    printf 'No fonts found in %s; skipping font install.\n' "$fonts_dir"
    return 0
  fi

  mkdir -p "$HOME/.local/share/fonts"
  cp -n "$fonts_dir"/*.ttf "$HOME/.local/share/fonts/"
  fc-cache -f "$HOME/.local/share/fonts"
}

setup_flatpak() {
  install_packages flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

setup_walker() {
  mkdir -p "$HOME/.config/systemd/user"

  if command -v elephant >/dev/null 2>&1; then
    elephant service enable
    systemctl --user start elephant.service
  else
    printf 'elephant command not found; skipping elephant service setup.\n'
  fi

  cat >"$HOME/.config/systemd/user/walker.service" <<'EOF'
[Unit]
Description=Walker Launcher Service
After=elephant.service
Requires=elephant.service

[Service]
ExecStart=/usr/bin/walker --gapplication-service
Restart=on-failure

[Install]
WantedBy=default.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now walker.service
}

main() {
  prime_sudo
  install_packages "${packages[@]}"
  setup_flatpak
  install_fonts
  setup_walker
  printf 'GUI layer complete.\n'
}

main "$@"
