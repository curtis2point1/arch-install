#!/usr/bin/env bash

ORIGINAL_DIR="$PWD"
cd -- "$( dirname -- "${BASH_SOURCE[0]}")"

# Load utility functions
source ../utilities.sh

install_packages git stow

# Check git status to ensure we can roll back changes without unintended consequences
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: Uncommitted changes exist in the repository."
  echo "Please commit or stash your changes before proceeding."
  exit 1
fi

# Overwrite local files with target files then create sym links
echo "Performing stow action..."
stow --adopt "$@"

# Undo the local files changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Undoing stow changes to local files..."
  git restore .
fi

echo "Stow complete."
cd -- "$ORIGINAL_DIR"
