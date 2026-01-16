#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install packages
install_packages chezmoi

chezmoi init --apply curtis2point1 --ssh

