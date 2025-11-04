#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )
REPO_ROOT=$( dirname "$SCRIPT_DIR" )

# Load common utilities; inlcudes 'install_packages' function
source "${REPO_ROOT}/common/scripts/utilities.sh"

# Install stow if needed
if ! command -v stow &>/dev/null; then
  install_packages stow
fi

# Set up local bin directory if needed
"${REPO_ROOT}/common/scripts/setup_local_bin.sh"

# Create symlink to add 'dotstow' command to PATH
echo "Creating symlink in ~/.local/bin/ directory..."
ln -sf "${SCRIPT_DIR}/dotstow.sh"  "${HOME}/.local/bin/dotstow"

echo "Dotstow installation complete."
