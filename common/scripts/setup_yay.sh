SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "${SCRIPT_DIR}/utilities.sh"

# Install yay AUR helper if not present
if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."

  # Make sure dependencies are installed
  install_packages git base-devel
  
  # Create a secure temporary directory and ensure it's cleaned up on exit
  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT

  git clone https://aur.archlinux.org/yay.git "$TMP_DIR"
  
  cd "$TMP_DIR"
  makepkg -si --noconfirm

else
  echo "yay is already installed."
fi

echo "Finished yay config script"
