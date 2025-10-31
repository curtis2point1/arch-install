#!/usr/bin/env bash

echo "Running stow from ${PWD}"

packages=(
  bash
  micro
  uwsm
  user-dirs
)


# Check git status to ensure we can roll back changes without unintended consequences
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: Uncommitted changes exist in the repository."
  echo "Please commit or stash your changes before proceeding."
  exit 1
fi

# Overwrite local files with target files then create sym links
stow --adopt "${packages[@]}"

# Undo the local files changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Undoing stow changes to local files"
  git restore .
fi

echo "Stow complete."
