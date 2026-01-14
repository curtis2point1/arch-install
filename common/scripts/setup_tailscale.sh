#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install packages
install_packages tailscale

if [[ $(systemctl is-enabled tailscaled) == "enabled" ]]; then
  echo "Tailscale already enabled."
else
  echo "Enabling Tailscale..."
  sudo systemctl enable --now tailscaled
fi

if tailscale status &> /dev/null; then
  echo "Tailscale is already running"
else
  echo "Starting Tailscale..."
  sudo tailscale up
fi
