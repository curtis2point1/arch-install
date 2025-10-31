SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "${SCRIPT_DIR}/utilities.sh"

# Install Github CLI tool
install_packages github-cli

# Handle authentication and permissions
REQUIRED_SCOPES=(
  "repo"
  "read:org"
  "workflow"
  "gist"
  "admin:ssh_signing_key"
  "admin:public_key"
)

SCOPE_STRING=$(IFS=,; echo "${REQUIRED_SCOPES[*]}")
auth_status=$(gh auth status 2> /dev/null)

if [ $? -ne 0 ]; then
  echo "Github CLI not authenticated. Running login..."
  gh auth login --hostname github.com --scopes "${SCOPE_STRING}"
elif
  ! echo "$auth_status" | grep -qF "admin:ssh_signing_key"; then
  echo "Authenticated but missing ssh signing key permission.  Adding now..."
  gh auth refresh --hostname github.com --scopes "${SCOPE_STRING}"
else
  echo "Already authenticated and have necessary permissions."
fi

# Ensure SSH keys are configured
pub_key_path="$HOME/.ssh/id_ed25519.pub"

if [ ! -f "$pub_key_path" ]; then
  echo "Local SSH key not configured. Running setup now..."
  "${SCRIPT_DIR}/setup_ssh.sh"  
fi

echo "Checking GitHub for existing SSH key..."
remote_keys=$(gh ssh-key list 2> /dev/null)

if [ $? -ne 0 ]; then
  echo "Error: Could not retrieve SSH keys from GitHub. Please check auth status." >&2
else
  echo "Attempting to add SSH key (might already be added)"
  gh ssh-key add "$pub_key_path"
fi

