#!/bin/bash

packages_to_remove=(
)

packages_to_add=(
  micro
  yazi
  iptables-nft # New iptables version needed by Tailscale
  tailscale # Need to run setup
  flatpak # Need setup to define mirrors
  syncthing # Set up via GUI
  stow
  nodejs
  google-cloud-cli # Need to run setup
  opencode
  google-chrome
)

user_services_to_enable=(
  syncthing # systemctl enable --user --now syncthing.service
)

system_services_to_enable=()

dotfiles_to_link=()

