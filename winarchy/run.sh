#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Load helper functions
source ../common/utilities.sh

# Get sudo permission
get_sudo

# Set up tools
source ../common/setup_ssh.sh
source ../common/setup_git.sh
source ../common/setup_yay.sh

# Install packages
packages=(
  man-db
  bat
  fzf
  btop
)
install_packages "${packages[@]}"

# Enabled services
services=(

)
enable_services "${services[@]}"

# Link dot files
dotfiles=(
  
)
link_dotfiles "${dotfiles[@]}"
