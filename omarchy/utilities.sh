#!/usr/bin/env bash

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &> /dev/null
}

# Function to remove packages only if they are currently installed
remove_packages_if_exist() {
  local packages_to_check=("$@")
  local installed_packages_to_remove=()

  # Build a list of packages that actually exist on the system
  for pkg in "${packages_to_check[@]}"; do
    if is_installed "$pkg"; then
      installed_packages_to_remove+=("$pkg")
    fi
  done

  # If the list is not empty, proceed with removal
  if [ ${#installed_packages_to_remove[@]} -ne 0 ]; then
    echo "Removing existing packages: ${installed_packages_to_remove[*]}"
    yay -Rsn --noconfirm "${installed_packages_to_remove[@]}"
  else
    echo "No packages from the list found to remove."
  fi
}
