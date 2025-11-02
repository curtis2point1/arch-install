#!/usr/bin/env bash

cd -- "$( dirname -- BASH_SOURCE[0] )"

name="$1"
path="$2"

if [ -z "$name" ]; then
  echo "Name not defined"
  exit 1
fi

if [ ! -f "$path" ]; then
  echo "File not found."
  exit 1
fi

echo "Creating new dot file config..."

# Create backup of file
echo "Backing up file..."
echo "${path}.bak"
cp "$path" "${path}.bak"

echo "Creating dotfile package..."
echo "$name"

new_dir="${PWD}/${name}$(dirname -- ${path#$HOME})"
mkdir -p "$new_dir"

# Move file to dotfile repo
echo "Moving file to repo..."
echo "$new_dir"
mv "$path" "$new_dir"

# Run stow
echo "Creating symlink..."
stow "$name" -t ~/
