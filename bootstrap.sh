#!/usr/bin/env bash
set -euo pipefail

github_user="${GITHUB_USER:-curtis2point1}"
ssh_key_comment="${SSH_KEY_COMMENT:-curtis@2point1analytics.com}"
ssh_key_path="${SSH_KEY_PATH:-$HOME/.ssh/id_ed25519}"
chezmoi_target="${CHEZMOI_TARGET:-$github_user}"
chezmoi_source="${CHEZMOI_SOURCE:-$HOME/.local/share/chezmoi}"

log() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_user_with_sudo() {
  if [[ "${EUID}" -eq 0 ]]; then
    fail "Run this as the target user with sudo privileges, not as root. SSH keys, GitHub auth, and Chezmoi state are user-owned."
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    fail "sudo is not installed. Install sudo and add this user to wheel before running bootstrap.sh."
  fi

  sudo -v
}

require_user_linger() {
  local target_user
  target_user="$(id -un)"

  if ! command -v loginctl >/dev/null 2>&1; then
    fail "loginctl is not available. Enable systemd user lingering for $target_user before running bootstrap.sh."
  fi

  if [[ "$(loginctl show-user "$target_user" -p Linger 2>/dev/null)" == "Linger=yes" ]]; then
    printf 'User lingering is already enabled for %s.\n' "$target_user"
    return 0
  fi

  log "Enabling user lingering"

  sudo loginctl enable-linger "$target_user"

  if [[ "$(loginctl show-user "$target_user" -p Linger 2>/dev/null)" != "Linger=yes" ]]; then
    fail "Failed to enable systemd user lingering for $target_user."
  fi
}

install_bootstrap_packages() {
  log "Installing bootstrap packages"
  sudo pacman -Syu --needed --noconfirm sudo git openssh github-cli chezmoi curl micro
}

ensure_ssh_key() {
  log "Configuring SSH key"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [[ ! -f "$ssh_key_path" && ! -f "$ssh_key_path.pub" ]]; then
    ssh-keygen -t ed25519 -C "$ssh_key_comment" -N "" -f "$ssh_key_path"
  elif [[ -f "$ssh_key_path" && ! -f "$ssh_key_path.pub" ]]; then
    ssh-keygen -y -f "$ssh_key_path" >"$ssh_key_path.pub"
  elif [[ ! -f "$ssh_key_path" && -f "$ssh_key_path.pub" ]]; then
    fail "Public key exists but private key is missing: $ssh_key_path. Move the public key or set SSH_KEY_PATH."
  else
    printf 'SSH key already exists: %s\n' "$ssh_key_path"
  fi

  touch "$HOME/.ssh/authorized_keys"
  chmod 600 "$HOME/.ssh/authorized_keys"
  chmod 600 "$ssh_key_path"
  chmod 644 "$ssh_key_path.pub"
}

authenticate_github() {
  log "Authenticating GitHub CLI"

  if gh auth status --hostname github.com >/dev/null 2>&1; then
    printf 'GitHub CLI is already authenticated.\n'
  else
    gh auth login --hostname github.com --git-protocol ssh
  fi
}

verify_github_ssh() {
  local gh_output
  local ssh_output

  log "Verifying GitHub SSH access"

  ssh_output="$(ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true)"
  printf '%s\n' "$ssh_output"

  if [[ "$ssh_output" == *"successfully authenticated"* ]]; then
    return 0
  fi

  log "Uploading SSH key with GitHub CLI fallback"
  if ! gh_output="$(gh ssh-key add "$ssh_key_path.pub" --type authentication 2>&1)"; then
    if [[ "$gh_output" == *"already exists"* || "$gh_output" == *"key is already in use"* ]]; then
      printf '%s\n' "$gh_output"
    else
      printf '%s\n' "$gh_output" >&2
    fi
  elif [[ -n "$gh_output" ]]; then
    printf '%s\n' "$gh_output"
  fi

  ssh_output="$(ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true)"
  printf '%s\n' "$ssh_output"

  [[ "$ssh_output" == *"successfully authenticated"* ]] || fail "GitHub SSH authentication failed."
}

run_chezmoi() {
  log "Running Chezmoi"
  mkdir -p "$HOME/dev/curtis"

  if [[ -e "$chezmoi_source" && ! -d "$chezmoi_source/.git" ]]; then
    fail "Chezmoi source exists but is not a Git repo: $chezmoi_source"
  fi

  if [[ -d "$chezmoi_source/.git" ]]; then
    chezmoi update
  else
    chezmoi init --apply "$chezmoi_target" --ssh
  fi
}

main() {
  require_user_with_sudo
  require_user_linger
  install_bootstrap_packages
  ensure_ssh_key
  authenticate_github
  verify_github_ssh
  run_chezmoi
  log "Bootstrap complete"
}

main "$@"
