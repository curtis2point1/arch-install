#!/usr/bin/env bash

packages=(
  bash
  uwsm
)


# Check git status to ensure we can roll back changes without unintended consequences
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: Uncommitted changes exist in the repository."
  echo "Please commit or stash your changes before proceeding."
  exit 1
fi

# Overwrites local files with target files then creates sym links
stow --adopt "${packages[@]}"

# Undo the local files changes
git restore .
