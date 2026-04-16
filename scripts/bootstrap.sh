#!/usr/bin/env bash
# bootstrap.sh — installs Ansible and runs the full workstation setup
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ─── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR ]${NC} $*" >&2; exit 1; }

# ─── Detect OS ────────────────────────────────────────────────────────────────
detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if grep -qi arch /etc/os-release 2>/dev/null; then echo "arch"
      else error "Unsupported Linux distro. Only Arch Linux is supported."; fi
      ;;
    *) error "Unsupported OS: $(uname -s)" ;;
  esac
}

OS=$(detect_os)
info "Detected OS: $OS"

# ─── Install Ansible ──────────────────────────────────────────────────────────
install_ansible() {
  if command -v ansible-playbook &>/dev/null; then
    info "Ansible already installed: $(ansible --version | head -1)"
    return
  fi

  info "Installing Ansible..."
  case "$OS" in
    macos)
      if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew install ansible
      ;;
    arch)
      sudo pacman -Sy --noconfirm ansible
      ;;
  esac
}

# ─── Ensure local bin dir exists ──────────────────────────────────────────────
mkdir -p "$HOME/.local/bin"

install_ansible

# ─── Install Galaxy collections ───────────────────────────────────────────────
info "Installing Ansible Galaxy collections..."
ansible-galaxy collection install -r "$REPO_DIR/requirements.yml"

# ─── Run full setup ───────────────────────────────────────────────────────────
info "Running full workstation setup..."
ansible-playbook "$REPO_DIR/playbooks/site.yml" --ask-become-pass

info "Bootstrap complete!"
