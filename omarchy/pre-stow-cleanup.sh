#!/usr/bin/env bash

# --- Configuration ---
# The target directory for your symlinks.
TARGET_DIR="${1:-$HOME}"
# The directory where this script is located (your dotfiles repo).
STOW_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# --- Mode ---
# Set to "true" to actually delete files. Anything else is a dry run.
DRY_RUN="false"
if [[ "$2" == "--dry-run" ]]; then
  DRY_RUN="true"
  echo "--- DRY RUN MODE --- (No files will be deleted)"
fi

echo "Stow Directory: ${STOW_DIR}"
echo "Target Directory: ${TARGET_DIR}"
echo "--------------------"

# --- Main Logic ---
# Change to the stow directory to ensure `find` starts in the right place.
cd "${STOW_DIR}" || exit

# Find all *files* within this directory, excluding .git and this script.
# The `find .` command is recursive by default.
find . -type f -not -path '*/.git/*' -not -name "$(basename "$0")" | while IFS= read -r file; do
  # Get a clean relative path (e.g., "./nvim/init.lua" becomes "nvim/init.lua")
  relative_path="${file#./}"
  target_path="${TARGET_DIR}/${relative_path}"

  # Check if a file or symlink exists at the target location.
  if [ -e "${target_path}" ] || [ -L "${target_path}" ]; then
    if [ "${DRY_RUN}" = "true" ]; then
      echo "WOULD REMOVE: ${target_path}"
    else
      echo "Removing conflict: ${target_path}"
      rm -f "${target_path}"
    fi
  fi
done

echo "--------------------"
echo "Cleanup complete."
