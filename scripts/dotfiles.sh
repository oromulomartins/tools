#!/usr/bin/env bash
# dotfiles.sh — clones the dotfiles repo and applies GNU Stow
set -euo pipefail

DOTFILES_REPO="https://github.com/oromulomartins/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

STOW_PACKAGES=(alacritty asdf lvim p10k tmux zsh)

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR ]${NC} $*" >&2; exit 1; }

# ─── Ensure stow is installed ─────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  case "$(uname -s)" in
    Darwin) brew install stow ;;
    Linux)  sudo pacman -Sy --noconfirm stow ;;
    *)      error "Cannot install stow: unsupported OS" ;;
  esac
fi

# ─── Clone or update dotfiles ─────────────────────────────────────────────────
if [ -d "$DOTFILES_DIR/.git" ]; then
  info "Updating dotfiles in $DOTFILES_DIR..."
  git -C "$DOTFILES_DIR" pull --rebase
else
  info "Cloning dotfiles to $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# ─── Apply stow ───────────────────────────────────────────────────────────────
# Back up any real files that would conflict with stow symlinks
backup_conflicts() {
  local pkg="$1"
  while IFS= read -r -d '' file; do
    relative="${file#"$DOTFILES_DIR/$pkg/"}"
    target="$HOME/$relative"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      warning "  Backing up $target -> $target.bak"
      mv "$target" "$target.bak"
    fi
  done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
}

info "Applying GNU Stow..."
cd "$DOTFILES_DIR"

for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    info "  stow $pkg"
    backup_conflicts "$pkg"
    stow --restow "$pkg"
  else
    warning "  Package '$pkg' not found in dotfiles, skipping."
  fi
done

info "Dotfiles applied. Restart your shell or run: source ~/.zshrc"
