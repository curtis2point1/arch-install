#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install Micro package and dependencies
install_packages micro wl-clipboard jq shellcheck

# Install plugins
for plugin in lsp linter; do
  if micro -plugin list | grep -q "$plugin"; then
    echo "$plugin plugin already installed"
  else
    echo "Installing $plugin plugin..."
    micro -plugin install "$plugin"
  fi
done

# Set Micro as default editor
if ! grep -q 'EDITOR=micro' /etc/environment; then
  echo -e 'EDITOR=micro\nVISUAL=micro' | sudo tee -a /etc/environment
fi

# Make immediately available but only works for current terminal scope
export EDITOR=micro

# Create or update settings file
mkdir -p "$HOME/.config/micro"
settings_file="$HOME/.config/micro/settings.json"

desired_settings='{"clipboard": "external", "tabsize": 2, "tabstospaces": true, "linter": true}'

if [ -f "$settings_file" ]; then
    # Merge with existing settings
    jq -s '.[0] * .[1]' "$settings_file" <(echo "$desired_settings") > tmp.$$ && mv tmp.$$ "$settings_file"
else
    echo "$desired_settings" > "$settings_file"
fi

echo "Micro setup complete!"
