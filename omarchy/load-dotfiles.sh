#!/usr/bin/env bash

STOW_DIR="./dotfiles"
TARGET_DIR="~/"

packages=(
  bash
  uwsm
)


# Check git status to ensure we can roll back changes without unintended consequences
if [ -n "$(git status ${STOW_DIR} --porcelain)" ]; then
  echo "Error: Uncommitted changes exist in the repository."
  echo "Please commit or stash your changes before proceeding."
  exit 1
fi

# Overwrites local files with target files then creates sym links
stow --adopt "${packages[@]}"

# Undo the local files changes
# Check git status to ensure we can roll back changes without unintended consequences
if [ -n "$(git status ${STOW_DIR} --porcelain)" ]; then
  echo "Undoing stow changes to local files"
  git restore ${STOW_DIR}
fi

echo "Stow complete."
