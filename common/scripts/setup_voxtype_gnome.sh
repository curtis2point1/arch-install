#!/bin/bash

set -euo pipefail

MODEL="medium.en"
UNIT="voxtype.service"

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Setup vdotool
source "$current_dir/setup_ydotool.sh"

# Install packages
install_packages voxtype wtype wl-clipboard

# --- 1) Download model only if missing ---
# Use voxtype's check output as the truth source.
if voxtype setup check 2>/dev/null | grep -q "Model '${MODEL}' installed"; then
  echo "Voxtype model ${MODEL} already installed"
else
  voxtype setup --download --model "$MODEL"
fi

# --- 2) Install systemd user service only if needed ---
# Only run `voxtype setup systemd` if the unit file isn't known to systemd.
if systemctl --user list-unit-files "$UNIT" >/dev/null 2>&1; then
  echo "$UNIT already exists"
else
  voxtype setup systemd
  systemctl --user daemon-reload
fi

# Enable only if not enabled
if systemctl --user is-enabled --quiet "$UNIT" 2>/dev/null; then
  echo "$UNIT already enabled"
else
  systemctl --user enable "$UNIT"
fi

# Start only if not active (avoid restarting every run)
if systemctl --user is-active --quiet "$UNIT"; then
  echo "$UNIT already running"
else
  systemctl --user start "$UNIT"
fi

# --- 4) Safe status checks ---
voxtype setup check || true
