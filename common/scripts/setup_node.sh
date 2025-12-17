#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Remove any existing installations
remove_packages nodejs nvm

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# in lieu of restarting the shell
source "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install node

# Set default node version to latest
nvm alias default node

echo "NodeJS setup complete!"
