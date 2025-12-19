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
if ! nvm list | grep -q 'node'; then
    echo "Installing Node.js..."
    nvm install node
else
    echo "Node.js is already installed via NVM."
fi

# Check and set default alias to latest Node.js
if ! nvm alias | grep -q 'default -> node'; then
    echo "Setting default Node.js version..."
    nvm alias default node
else
    echo "Default Node.js alias is already set."
fi

echo "NodeJS setup complete!"
