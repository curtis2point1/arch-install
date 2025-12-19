#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install package
if ! command -v gemini &> /dev/null; then
    npm install -g @google/gemini-cli
else
    echo "Gemini CLI is already installed."
fi

# Add dotfile for default user settings

echo "Gemini CLI setup complete!"
