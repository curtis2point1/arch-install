#!/bin/bash

# --- Directories
current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
repo_root=$( dirname -- "$current_dir" )
scripts_dir="$repo_root/common/scripts"
assets_dir="$repo_root/common/assets"

# --- Variables
packages_to_add=(
  jq
  wl-clipboard
  shellcheck
  man-db
  fd
  plocate
  ripgrep
  fzf
  bat
  eza
  fsearch # Everything search replacement
  btop # modern version of htop
  nvtop # nvidia status monitor
  zoxide
  starship
  lazygit
  yazi
  7zip
  less
  xdg-desktop-portal-gnome # for screensharing
  zed
  visual-studio-code-bin
  opencode
  ghostty
  slack-desktop
  spotify
  typora
  lite-xl
  lpm # plug-in manager for lite-xl
  datagrip
  datagrip-jre # custom java runtime for datagrip
  easyeffects # audio effects
  guvcview # video image controls (basic)
  pavucontrol # audio controls (basic)
  walker # custom launcher
  1password
  1password-cli
  obs-studio
  pipewire # audio
  pipewire-pulse # audio w/ legacy compatibility
  google-chrome
  pacseek # TUI package manager
)
packages_to_remove=""

# --- Load dependencies
source "$scripts_dir/utilities.sh"
source "$current_dir/packages.sh"

# --- Get permissions
prime_sudo

# --- Run setup scripts
source "$scripts_dir/setup_yay.sh"
source "$scripts_dir/setup_local_bin.sh"
source "$scripts_dir/setup_node.sh"
source "$scripts_dir/setup_python.sh"
source "$scripts_dir/setup_tailscale.sh"
source "$scripts_dir/setup_google_cloud.sh"
source "$scripts_dir/setup_ssh.sh"
source "$scripts_dir/setup_micro.sh"
source "$scripts_dir/setup_git.sh"
source "$scripts_dir/setup_dirs.sh"
source "$scripts_dir/clone_repos.sh"
source "$scripts_dir/setup_docker.sh"
source "$scripts_dir/setup_sync.sh"
source "$scripts_dir/setup_voxtype_gnome.sh"
source "$scripts_dir/setup_chezmoi.sh"

# --- Install & remove packages
remove_packages "${packages_to_remove[@]}"
install_packages "${packages_to_add[@]}"

# Node packages
npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli
