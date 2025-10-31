#!/usr/bin/env bash

echo "Beginnging home directory setup"

mkdir -p "$HOME"/{bin,desktop,downloads,opt,pictures,sync,vaults}
mkdir -p "$HOME"/projects/{curtis,datm,ripe,two-point-one}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ln -sf "${SCRIPT_DIR}/dotfiles" "${HOME}/dotfiles" 

echo "Directory setup complete!"

