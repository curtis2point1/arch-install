#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install Github CLI tool
install_packages google-cloud-cli

# Authorize
if [[ -z $(gcloud config get-value account 2> /dev/null) ]]; then
  echo "Initializng the GCloud account..."
  gcloud init
else
  echo "GCloud already initialized"
fi
