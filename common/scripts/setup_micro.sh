#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install Github CLI tool
install_packages micro

if micro -plugin list | grep "lsp" &> /dev/null; then
  echo "LSP plug-in is already installed"
else
  echo "Installing LSP plug-in..."
  micro -plugin install lsp
fi

echo "Micro setup complete!"
