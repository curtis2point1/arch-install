#!/bin/bash

echo "Importing package lists..."


######  Packages  ######

common_packages=(
  bash-language-server
  shellcheck
  man-db
  fd
  ripgrep
  fzf
  btop
  plocate
  zoxide
  starship
  lazygit
  python
  nodejs
  jq
  stow
  yazi
  7zip
  less
)


omarchy_packages=()

curtarchy_packages=()

winarchy_packages=()


######  Services  ######

common_services=()

omarchy_services=()

curtarchy_services=()

winarchy_services=()


######  Flatpaks  ######

common_flatpaks=()

omarchy_flatpaks=()

curtarchy_flatpaks=()

winarchy_flatpaks=()


######  Dot Files  ######

common_dotfiles=(
  bash
  micro
  yazi
)

omarchy_dotfiles=()

curtarchy_dotfiles=()

winarchy_dotfiles=()


######  Fonts  ######

common_fonts=()

omarchy_fonts=()

curtarchy_fonts=()

winarchy_fonts=()


echo "Done importing packages lists."
