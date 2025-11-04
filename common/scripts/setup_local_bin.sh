#!/bin/bash

echo "Starting local bin setup..."

# Create directory if needed
if [[ ! -d "${HOME}/.local/bin/" ]]; then
  echo "Creating ~/.local/bin/ directory..."
  mkdir -p "${HOME}/.local/bin/"
else
  echo "Directory already exists."
fi

# Update bashrc file to include path if needed
BASHRC_MARKER="# Export local bin to PATH"

# Check if the marker already exists in ~/.bashrc
if ! grep -qF "$BASHRC_MARKER" ~/.bashrc; then
  echo "Path configuration not found. Adding it now..."
  # Use a here-document to append the multi-line block
  cat <<'EOF' >> ~/.bashrc

# Export local bin to PATH  *** DO NOT UPDATE COMMENT ***
if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*)
      # Already in PATH, do nothing
      ;;
    *)
      # Not in PATH, prepend it
      export PATH="$HOME/.local/bin:$PATH"
      ;;
  esac
fi
EOF

else
  echo "Path already configured."
fi

echo "Local bin setup complete."
