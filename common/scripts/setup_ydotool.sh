#!/bin/bash

SERVICE_NAME="ydotoold.service"
SERVICE_PATH="$HOME/.config/systemd/user/$SERVICE_NAME"

# Ensure user is in the input group
if ! id -nG "$USER" | tr ' ' '\n' | grep -qx "input"; then
  echo "Adding $USER to the 'input' group (requires sudo)..."
  sudo usermod -aG input "$USER"
  echo "NOTE: You'll need to log out/in (or reboot) for group membership to apply to GUI apps like Voxtype."
else
  echo "$USER is already in the 'input' group"
fi

# Create service file only if it doesn't already exist
if [[ ! -f "$SERVICE_PATH" ]]; then
  echo "Creatign ydotool.service..."
  mkdir -p "$HOME/.config/systemd/user"
  cat > "$SERVICE_PATH" <<'EOF'
[Unit]
Description=ydotoold (Wayland input helper)

[Service]
ExecStart=/usr/bin/ydotoold --socket-path=%t/.ydotool_socket --socket-perm=0600
Restart=on-failure

[Install]
WantedBy=default.target
EOF

  systemctl --user daemon-reload
else
  echo "ydotoold.service already exists — skipping creation"
fi

# Enable service only if not already enabled
if ! systemctl --user is-enabled --quiet ydotoold.service; then
  echo "Enabling ydotool.service..."
  systemctl --user enable ydotoold.service
else
  echo "ydotoold.service already enabled"
fi

# Start service only if not already running
if ! systemctl --user is-active --quiet ydotoold.service; then
  echo "Starting ydotool.service..."
  systemctl --user start ydotoold.service
else
  echo "ydotoold.service already running"
fi
