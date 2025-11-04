#!/bin/bash

echo "Starting DotStow..."


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_ROOT=$( dirname -- $( dirname -- "$SCRIPT_DIR" ) )
DOT_DIR="${REP_ROOT}/dotfiles/"
TARGET_DIR="$HOME"

# --- 1. Argument Validation ---
# First, check if you have at least one argument (the command).
if [ "$#" -lt 1 ]; then
  echo "Error: No command specified. Use 'create' or 'deploy'."
  exit 1
fi

# --- 2. Command Dispatch ---
# Use the first argument to decide what to do.
COMMAND="$1"

case "$COMMAND" in
  create)
    # For 'create', we expect 3 total arguments.
    if [ "$#" -ne 3 ]; then
      echo "Usage: $0 create <target_file> <package_name>"
      exit 1
    fi

    file="$2"
    package="$3"

    if [[ ! -f "$file" ]]; then
      echo "Not a valid file path.  Existing."
      exit 1
    fi

    if [[ -z "$package" ]]; then
      echo "No package name provided.  Exiting."
      exit 1
    fi

    relative_dir=$( dirname -- "$file")
    

    
    
    ;;

  deploy)
    # For 'deploy', we expect 2 total arguments.
    if [ "$#" -ne 2 ]; then
      echo "Usage: $0 deploy <package_name>"
      exit 1
    fi
    # Logic for deploying a package goes here.
    # $2 will be the package name.
    ;;

  *)
    # This is the catch-all for any unknown command.
    echo "Error: Unknown command '$COMMAND'. Use 'create' or 'deploy'."
    exit 1
    ;;
esac

echo "Successfully completed $0 $1"
