#!/usr/bin/env bash

core_packages={
	micro
}

# Install packages
sudo pacman -S --noconfirm --needed "${core_packages[@]}"
