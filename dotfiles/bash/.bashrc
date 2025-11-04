#!/bin/bash

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# --- Custom ---

# Yazi alias and custom behavior (copied from docs)
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Git aliases
alias lg='lazygit'
alias gac='git add . && git commit -m'

# Export local bin to PATH  *** DO NOT UPDATE COMMENT ***
if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*)
      # Already in PATH, do nothing
      ;;
    *)
      # Not in PATH, prepend it
      export PATH="$HOME/.local/bin:$PATH"
      ;;
  esac
fi
