#!/usr/bin/env bash

# Load dependencies
source ./utilities
source ./packages.conf

# Update package manager
yay -Syu --noconfirm

# Deleted uneeded packages
remove_packages_if_exist "${packages_to_remove[@]}"

# Install packages
yay -S --needed --noconfirm "${packages_to_add[@]}"

# Load dotfiles
cd ./dotfiles
source ./setup.sh
cd ../


# Directories
ln -s ./dotfiles ~/
rm -rf Desktop Documents Downloads Music Pictures Public Templates Videos Work
mkdir -p ~/{bin,desktop,documents,downloads,opt,pictures,projects,sync,vaults}
mkdir -p ~/projects/{curtis,two-point-one,datm,ripe}
