#!/usr/bin/env bash

echo "Installed nvidia drivers"
sudo pacman -S --needed  nvidia nvidia-open nvidia-settings libva-nvidia-driver

echo "No other configuration performed"
