#!/usr/bin/env bash

# --- Configuration ---
# The target directory for your symlinks. Defaults to the user's home directory.
TARGET_DIR="${1:-$HOME}"
STOW_DIR=$(pwd) # Assumes the script is run from the root of the dotfiles repo.

echo "Stow Directory: $STOW_DIR"
echo "Target Directory: $TARGET_DIR"
echo "---"

# --- Main Logic ---
# Find all *files* in the current directory, excluding the .git directory and this script.
# Then, for each file, construct the target path and remove it if it exists.
find . -type f -not -path '*/.git/*' -not -name "$(basename "$0")" | while IFS= read -r file; do
  # Remove the leading './' from the find output to get a clean relative path
  relative_path="${file#./}"

  # Construct the full path to the target file
  target_path="$TARGET_DIR/$relative_path"

  # Check if the target file or symlink actually exists before trying to remove it
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    echo "Conflict found. Removing: $target_path"
    # rm -f "$target_path"
  fi
done

echo "---"
echo "Pre-stow cleanup complete."
