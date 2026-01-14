#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Check if NVM is already installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    # Download and install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    echo "NVM is already installed."
fi

# Source NVM (only if not already sourced in this session)
if ! command -v nvm &> /dev/null; then
    source "$HOME/.nvm/nvm.sh"
fi

# Check if Node.js is installed via NVM
echo "Installing Node.js and setting alias..."
nvm install node
nvm alias default node

echo "NodeJS setup complete!"
