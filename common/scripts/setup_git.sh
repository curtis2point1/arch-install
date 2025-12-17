#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install Github CLI tool
install_packages git github-cli

# Handle authentication and permissions
required_scopes=(
  "repo"
  "read:org"
  "workflow"
  "gist"
  "admin:ssh_signing_key"
  "admin:public_key"
)

scope_string=$(IFS=,; echo "${required_scopes[*]}")
auth_status=$(gh auth status 2> /dev/null)

if [ $? -ne 0 ]; then
  echo "Github CLI not authenticated. Running login..."
  gh auth login --hostname github.com --scopes "$scope_string"
elif
  ! echo "$auth_status" | grep -qF "admin:ssh_signing_key"; then
  echo "Authenticated but missing ssh signing key permission.  Adding now..."
  gh auth refresh --hostname github.com --scopes "$scope_string"
else
  echo "Already authenticated and have necessary permissions."
fi

# Ensure SSH keys are configured
pub_key_path="$HOME/.ssh/id_ed25519.pub"

if [ ! -f "$pub_key_path" ]; then
  echo "Local SSH key not configured. Running setup now..."
  "$script_dir/setup_ssh.sh"  
fi

echo "Checking GitHub for existing SSH key..."
remote_keys=$(gh ssh-key list 2> /dev/null)

if [ $? -ne 0 ]; then
  echo "Error: Could not retrieve SSH keys from GitHub. Please check auth status." >&2
else
  echo "Attempting to add SSH key (might already be added)"
  gh ssh-key add "$pub_key_path"
fi

echo "Setting user config info..."
git config --global user.email "curtis@2point1analytics.com"
git config --global user.name "Curtis"

echo "Github setup complete!"

