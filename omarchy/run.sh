#!/bin/bash

# --- Directories
current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
repo_root=$( dirname -- "$current_dir" )
scripts_dir="$repo_root/common/scripts"
assets_dir="$repo_root/common/assets"

# --- Variables
packages_to_add=""
packages_to_remove=""
services_to_enable=""
dotfiles_to_link=""

# --- Load dependencies
source "$scripts_dir/utilities.sh"
source "$current_dir/packages.sh"

# --- Get permissions
prime_sudo

# --- Install & remove packages
remove_packages "${packages_to_remove[@]}"
install_packages "${packages_to_add[@]}"

# --- Enable services
# enable_services "${services_to_enable[@]}"

# --- Link dotfiles
# link_dotfiles "$dotfiles_to_link[@]"

# --- Run setup scripts
source "$scripts_dir/setup_tailscale.sh"
source "$scripts_dir/setup_google_cloud.sh"
source "$scripts_dir/setup_ssh.sh"
source "$scripts_dir/setup_micro.sh"
source "$scripts_dir/setup_git.sh"
source "$scripts_dir/setup_dirs.sh"
