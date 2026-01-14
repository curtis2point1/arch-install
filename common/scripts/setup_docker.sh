#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install packages
install_packages docker docker-compose lazydocker

# Enable service
sudo systemctl enable --now docker

# Set group permissions (only if not already in group)
if ! groups "$USER" | grep -q docker; then
    sudo usermod -aG docker "$USER"
    echo "Added $USER to docker group - logout/login required"
fi
