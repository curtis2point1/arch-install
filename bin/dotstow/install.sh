#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )
REPO_ROOT=$( dirname "$SCRIPT_DIR" )

# Load common utilities; inlcudes 'install_packages' function
source "${REPO_ROOT}/common/utilities.sh"

# Install stow if needed
if ! command -v stow &>/dev/null; then
  install_packages stow
fi

# Create bin directory if needed
if [[ ! -d "${HOME}/.local/bin/" ]]; then
  echo "Creating ~/.local/bin/ directory..."
  mkdir -p "${HOME}/.local/bin/"
fi

# Create symlink to add 'dotstow' command to PATH
echo "Creating symlink in ~/.local/bin/ directory..."
ln -sf "${SCRIPT_DIR}/dotstow.sh"  "${HOME}/.local/bin/dotstow"

echo "Dotstow installation complete."
