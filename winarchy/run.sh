#!/usr/bin/env bash

ORIGINAL_DIR="$PWD"
cd -- "$( dirname -- "${BASH_SOURCE[0]}")"

# Load helper functions
source ../common/scripts/utilities.sh

# Load packages to add/remove/enable
source ../common/scripts/packages.sh

# Get sudo permission
prime_sudo

# Set up tools
../common/scripts/setup_yay.sh
../common/scripts/setup_python.sh
../common/scripts/setup_ssh.sh
../common/scripts/setup_git.sh
../common/scripts/setup_tailscale.sh
../common/scripts/setup_google_cloud.sh
../common/scripts/setup_micro.sh
../common/scripts/setup_dirs.sh
../common/scripts/setup_local_bin.sh

# Install packages
install_packages "${common_packages[@]}"
install_packages "${winarchy_packages[@]}"

# Enabled services
#enable_services "${winarchy_services_to_enable[@]}"

# Fonts
#install_packages "${fonts_to_add[@]}"

# Link dot files
#link_dotfiles "${winarchy_dotfiles_to_link[@]}"

cd -- "$ORIGINAL_DIR"
