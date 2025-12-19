#!/binbash

# Only run this file once
if [ -n "${_UTILITIES_LOADED:-}" ]; then
  return 0
fi

echo "Importing utility functions.."
declare -r _UTILITIES_LOADED=true

# Get sudo permission and keep active
prime_sudo() {
  echo "Authenticating for sudo..."
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

# Function to check if a package is installed
is_installed() {
  pacman -Q "$1" &>/dev/null
}

install_packages() {
  # Exit early if no packages were provided.
  if [ $# -eq 0 ]; then
    return 0
  fi

  local packages_to_install=()

  # Loop through all provided package names.
  for pkg in "$@"; do
    # Use pacman's query flag to check if the package is already installed.
    if is_installed "$pkg"; then
      echo "$pkg is already installed."
    else
      # If not installed, add it to our list of packages to install.
      packages_to_install+=("$pkg")
    fi
  done

  # If the list of packages to install is not empty, run the installer.
  if [ ${#packages_to_install[@]} -gt 0 ]; then
	# Confirm yay is installed
	if ! command -v yay &> /dev/null; then
	    echo "Yay not installed. Exiting"
	    exit 1
	fi

    # Update yay
    echo "Updating package manager..."
  	yay -Syu --noconfirm

    echo "Installing missing packages: ${packages_to_install[*]}"
    # The --needed flag is no longer required, as we've already filtered the list.
    yay -S --needed "${packages_to_install[@]}"
  fi
}

# Function to remove packages only if they are currently installed
remove_packages() {
  # Exit early if no packages were provided.
  if [ $# -eq 0 ]; then
    return 0
  fi

  local packages_to_remove=()

  # Build a list of packages that actually exist on the system
  for pkg in "$@"; do
    if is_installed "$pkg"; then
      packages_to_remove+=("$pkg")
    fi
  done

  # If the list has elements then proceed with removal
  if [ ${#packages_to_remove[@]} -gt 0 ]; then
    echo "Removing existing packages: ${packages_to_remove[*]}"
    yay -Rcsn "${packages_to_remove[@]}" || { echo "Uninstall failed. Exiting."; exit 1; }
  else
    echo "No packages to remove."
  fi
}

enable_services() {
  # Exit early if no services were provided.
  if [ $# -eq 0 ]; then
    return 0
  fi

  for service in "$@"; do
    if ! systemctl is-enabled "$service"; then
      echo "Enabling $service..."
      sudo systemctl enable "$service"
    else
      echo "$service already enabled"
    fi
  done
}

# Removes files if they exist and are regular files.
remove_files() {
  local file
  for file in "$@"; do
    # Check if it exists and is a regular file (-f)
    if [[ -f "$file" ]]; then
      rm "$file"
      echo "Removed file: $file"
    elif [[ -e "$file" ]]; then
      echo "Skipping '$file': It exists but is not a regular file."
    else
      # Optional: Comment out if you want silent execution for non-existent files
      echo "Skipping '$file': File does not exist."
    fi
  done
}

# Removes directories recursively if they exist.
remove_directories() {
  local dir
  for dir in "$@"; do
    # Safety: Ensure variable is not empty or root to prevent accidents
    if [[ -z "$dir" || "$dir" == "/" ]]; then
      echo "Error: Unsafe directory path '$dir'. Skipping."
      continue
    fi

    # Check if it exists and is a directory (-d)
    if [[ -d "$dir" ]]; then
      rm -rf "$dir"
      echo "Removed directory: $dir"
    elif [[ -e "$dir" ]]; then
      echo "Skipping '$dir': It exists but is not a directory."
    else
      echo "Skipping '$dir': Directory does not exist."
    fi
  done
}

# Creates directories, including parent directories if needed.
add_directories() {
  local dir
  for dir in "$@"; do
    # -p creates parent directories as needed and doesn't error if it exists
    if [[ ! -d "$dir" ]]; then
      mkdir -p "$dir"
      echo "Created directory: $dir"
    else
      echo "Directory already exists: $dir"
    fi
  done
}

echo "Done importing functions."
