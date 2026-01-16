#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install packages
install_packages elephant-all walker

# Create user-level service
elephant service enable
systemctl --user start elephant.service

# Create Walker user-level service
cat > ~/.config/systemd/user/walker.service << 'EOF'
[Unit]
Description=Walker Launcher Service
After=elephant.service
Requires=elephant.service

[Service]
ExecStart=/usr/bin/walker --gapplication-service
Restart=on-failure

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now walker.service
