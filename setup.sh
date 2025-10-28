#!/usr/bin/env bash

# Prompt for sudo if needed
sudo -v

# Keep alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Create home directories
source ./scripts/directories.sh

# Install packages
source ./scripts/packages.sh

# Configure Nvidia
read -p "Set up Nvidia GPU? [y/N] " choice
if [[ $choice == "y" ]]; then
  # ./scripts.nvidia.sh
  echo "Nvidia script TBD"	
fi

# Enable services
# source ./scripts/services.sh
