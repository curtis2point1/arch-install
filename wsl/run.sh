#!/usr/bin/env bash

ORIGINAL_DIR="$PWD"
cd -- "$( dirname -- "${BASH_SOURCE[0]}")"

# Define scripts directory
SCRIPTS_DIR="../common/scripts"

# Load helper functions
source "$SCRIPTS_DIR/utilities.sh"

# Load packages to add/remove/enable
source "$SCRIPTS_DIR/packages.sh"

# Get sudo permission
prime_sudo

# Set up tools
source "$SCRIPTS_DIR/setup_yay.sh"
source "$SCRIPTS_DIR/setup_python.sh"
source "$SCRIPTS_DIR/setup_ssh.sh"
source "$SCRIPTS_DIR/setup_git.sh"
source "$SCRIPTS_DIR/setup_tailscale.sh"
source "$SCRIPTS_DIR/setup_google_cloud.sh"
source "$SCRIPTS_DIR/setup_gemini.sh"
source "$SCRIPTS_DIR/setup_micro.sh"
source "$SCRIPTS_DIR/setup_dirs.sh"
source "$SCRIPTS_DIR/setup_local_bin.sh"
source "$SCRIPTS_DIR/setup_sync.sh"
source "$SCRIPTS_DIR/clone_repos.sh"

# Install packages
install_packages "${common_packages[@]}"
install_packages "${winarchy_packages[@]}"

# Set browser handlers
gio mime x-scheme-handler/https wslview.desktop
gio mime x-scheme-handler/http wslview.desktop

# Enabled services
#enable_services "${winarchy_services_to_enable[@]}"

# Fonts
#install_packages "${fonts_to_add[@]}"

# Link dot files
#link_dotfiles "${winarchy_dotfiles_to_link[@]}"

cd -- "$ORIGINAL_DIR"
