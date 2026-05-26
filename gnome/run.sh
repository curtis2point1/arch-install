#!/usr/bin/env bash
set -euo pipefail

current_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
repo_root=$(dirname -- "$current_dir")
scripts_dir="$repo_root/common/scripts"

# shellcheck source=../common/scripts/utilities.sh disable=SC1091
source "$scripts_dir/utilities.sh"

packages=(
  voxtype
  wl-clipboard
  wtype
  xdg-desktop-portal-gnome
  ydotool
)

setup_ydotool() {
  local service_name="ydotoold.service"
  local service_path="$HOME/.config/systemd/user/$service_name"

  if id -nG "$USER" | tr ' ' '\n' | grep -qx input; then
    printf '%s is already in the input group.\n' "$USER"
  else
    sudo usermod -aG input "$USER"
    printf 'Added %s to the input group; log out and back in for GUI apps to see it.\n' "$USER"
  fi

  if [[ ! -f "$service_path" ]]; then
    mkdir -p "$HOME/.config/systemd/user"
    cat >"$service_path" <<'EOF'
[Unit]
Description=ydotoold (Wayland input helper)

[Service]
ExecStart=/usr/bin/ydotoold --socket-path=%t/.ydotool_socket --socket-perm=0600
Restart=on-failure

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
  fi

  systemctl --user enable --now "$service_name"
}

setup_voxtype() {
  local model="medium.en"
  local unit="voxtype.service"

  setup_ydotool

  if voxtype setup check 2>/dev/null | grep -q "Model '${model}' installed"; then
    printf 'Voxtype model %s already installed.\n' "$model"
  else
    voxtype setup --download --model "$model"
  fi

  if systemctl --user list-unit-files "$unit" --no-legend 2>/dev/null | grep -q "^$unit"; then
    printf '%s already exists.\n' "$unit"
  else
    voxtype setup systemd
    systemctl --user daemon-reload
  fi

  systemctl --user enable --now "$unit"
  voxtype setup check || true
}

setup_keybindings() {
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 9

  for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings "switch-to-application-$i" "[]"
    gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Super><Shift>$i']"
  done

  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Shift>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

  local bindings=(
    "Walker|walker|<Super>space"
    "Terminal|ghostty|<Super>Return"
    "1Password|1password|<Super><Shift>p"
    "VS Code|code|<Super><Shift>c"
    "FSearch|fsearch|<Super><Shift>f"
    "Zed|zeditor|<Super><Shift>z"
    "Obsidian|obsidian|<Super><Shift>o"
    "Slack|slack|<Super><Shift>s"
    "Typora|typora|<Super><Shift>t"
    "Datagrip|gtk-launch jetbrains-datagrip|<Super><Shift>d"
    "Lite XL|lite-xl|<Super><Shift>l"
    "Chrome|google-chrome-stable|<Super><Shift>b"
    "Gmail|google-chrome-stable --profile-directory=Default --app-id=fmgjjmmmlfnkbppncabfkddbjimcfncm|<Super><Shift>e"
  )

  set_gnome_keybindings "${bindings[@]}"
}

main() {
  prime_sudo
  install_packages "${packages[@]}"
  setup_voxtype
  setup_keybindings
  printf 'GNOME layer complete.\n'
}

main "$@"
