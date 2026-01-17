#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Create directory if needed
add_directories "$HOME/sync"

# Install package if needed
install_packages syncthing

# Start and enable service
sudo systemctl --user enable --now syncthing

# Open Syncthing admin panel in browser (only if display available)
if xdg-open http://localhost:8384 2>/dev/null; then
    :
else
    echo "Syncthing web UI available at: http://localhost:8384"
fi
