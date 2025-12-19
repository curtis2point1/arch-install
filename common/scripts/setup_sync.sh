#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Create directory if needed
add_directories "$HOME/sync"

# Install package if needed
install_packages rslsync

# Add 2-way group permissions
sudo usermod -aG curtis rslsync
sudo usermod -aG rslsync curtis

# Add group permissions to folders
sudo chmod g+rx "$HOME"
sudo chmod -R g+rwX "$HOME/sync"

# Start and enable service
sudo systemctl enable --now rslsync

# Open Resilio Sync admin panel in browser
xdg-open http://localhost:8888