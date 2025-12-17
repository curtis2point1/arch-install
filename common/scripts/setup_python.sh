#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install main Python package
install_packages python

# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install global Python tools
uv tool install ruff
uv tool install pre-commit
uv tool install ipython
uv tool install httpx

echo "Python setup complete!"
