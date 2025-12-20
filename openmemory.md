# OpenMemory Guide

## Overview

This is an Arch Linux installation and configuration automation project. It provides reproducible setups for different environments: omarchy (reference laptop), curtarchy (GUI desktops with Nvidia), winarchy (WSL terminal-only), and common shared utilities. The project uses bash scripting with idempotent operations, GNU stow for dotfile management, and yay for package management.

Owner: Curtis Robinson (solo consultant at Two Point One Analytics, data analyst/engineer learning Linux/DevOps).

Philosophy: Simple working code first, learn best practices, git rollback safety.

## Architecture

- **common/**: Shared scripts and utilities
  - scripts/: Core setup scripts (setup\_\*.sh), utilities.sh (core functions), packages.sh (package lists)
- **omarchy/**: Reference environment (Nitro laptop)
- **curtarchy/**: GUI environment with Nvidia support
- **winarchy/**: WSL terminal-only environment
- **dotfiles/**: Centralized dotfiles managed with GNU stow

Workflow: Source utilities → Load packages → Install/remove packages → Run setup scripts → Enable services → Link dotfiles.

## User Defined Namespaces

- Leave blank - user populates

## Components

- **utilities.sh**: Core functions (install_packages, remove_packages, enable_services, add_directories, etc.) - idempotent design
- **setup\_\*.sh scripts**: Individual tool setups (yay, git, ssh, python, node, micro, etc.)
- **packages.sh**: Package definitions per environment
- **run.sh/setup.sh**: Main entry points per environment
- **dotstow.sh**: Custom dotfile management script (incomplete)
- **dotfiles/setup.sh**: Stow-based dotfile deployment with git safety

## Patterns

- Idempotent scripts: Safe to run multiple times, check before acting
- Modular structure: Common utilities sourced by environment-specific scripts
- Package management: yay for AUR, pacman for official repos
- Dotfile management: GNU stow for symlinking, git-aware deployment
- Error handling: Exit on failures, informative messages
- Directory management: Custom user dirs, remove defaults

## Code Style

- Indentation: 2 spaces (configured in micro editor settings)
- Tabstospaces: true (in micro config)
- Bash scripting: Functions with local variables, error checking
- Comments: Descriptive, inline explanations
- File structure: Consistent naming (setup\_\*.sh, lowercase)
