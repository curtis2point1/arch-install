#!/usr/bin/env bash

ORIGINAL_DIR="$PWD"
cd -- "$( dirname -- "${BASH_SOURCE[0]}")"

# Load helper functions
source ../common/utilities.sh

# Load packages to add/remove/enable
source ../common/packages.sh

# Get sudo permission
prime_sudo

# Set up tools
../common/setup_ssh.sh
../common/setup_git.sh
../common/setup_yay.sh
../common/setup_dirs.sh

# Install packages
install_packages "${winarchy_packages_to_add[@]}"

# Enabled services
enable_services "${winarchy_services_to_enable[@]}"

# Fonts
install_packages "${fonts_to_add[@]}"

# Link dot files
link_dotfiles "${winarchy_dotfiles_to_link[@]}"

cd -- "$ORIGINAL_DIR"
