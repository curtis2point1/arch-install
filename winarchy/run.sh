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
../common/scripts/setup_ssh.sh
../common/scripts/setup_git.sh
../common/scripts/setup_yay.sh
../common/scripts/setup_dirs.sh

# Install packages
install_packages "${winarchy_packages_to_add[@]}"

# Enabled services
enable_services "${winarchy_services_to_enable[@]}"

# Fonts
install_packages "${fonts_to_add[@]}"

# Link dot files
link_dotfiles "${winarchy_dotfiles_to_link[@]}"

cd -- "$ORIGINAL_DIR"
