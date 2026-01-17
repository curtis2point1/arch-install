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

# Open Resilio Sync admin panel in browser (only if display available)
if [ -n "$DISPLAY" ]; then
    xdg-open http://localhost:8888
else
    echo "Resilio Sync web UI available at: http://localhost:8888"
fi