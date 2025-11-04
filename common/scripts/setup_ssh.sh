#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install package if needed
install_packages openssh

# Generate keys
if [ -f ~/.ssh/id_ed25519 ]; then
  # Key exists, skip creation.
  echo "SSH key already exists."
else
  # Key does not exist, proceed with creation.
  echo "SSH key not found, generating now..."
  ssh-keygen -t ed25519 -C "curtis@2point1analytics.com"
fi

# Create authorized keys files if needed
touch ~/.ssh/authorized_keys

# Set permissions
echo "Setting SSH directory permissions"

chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

echo "Done with SSH setup"

