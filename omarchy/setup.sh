#!/usr/bin/env bash

packages=(
  bash
  uwsm
)

stow "${packages[@]}"
