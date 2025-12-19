#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install main Python package
install_packages python

# Install UV
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "UV is already installed."
fi

# Install global Python tools
for tool in ruff pre-commit ipython httpx; do
    if ! uv tool list 2>/dev/null | grep -q "^$tool "; then
        uv tool install "$tool"
    else
        echo "$tool is already installed."
    fi
done

echo "Python setup complete!"
