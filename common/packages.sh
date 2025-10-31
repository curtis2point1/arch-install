#!/usr/bin/env bash

echo "Importing package lists..."


######  Packages  ######

omarchy_packages_to_add=(
  micro  
)

omarchy_packages_to_remove=()

curtarchy_packages_to_add=(
  micro
  yazi
  fzf
  bat
  btop
  lazygit

)

winarchy_packages_to_add=(
  micro
  yazi
  fzf
  bat
  btop
  lazygit
)


######  Services  ######

omarchy_services_to_enable=()

curtarchy_services_to_enable=()

winarchy_services_to_enable=()


######  Flatpaks  ######

omarchy_flatpaks_to_add=()

curtarchy_flatpaks_to_add=()

winarchy_flatpaks_to_add=()


######  Dot Files  ######
omarchy_dotfiles_to_add=(
  bash
  micro
  yazi
)

curtarchy_dotfiles_to_add=(
  bash
  micro
  yazi
)

winarchy_dotfiles_to_add=(
  bash
  micro
  yazi
)


######  Fonts  ######

fonts_to_add=()


echo "Done importing packages lists."
