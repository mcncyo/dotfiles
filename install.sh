#!/bin/bash
set -e

# Make script location-aware
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect if running as root (e.g., inside Docker)
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

echo "🔍 Detecting package manager..."

# Set package manager and common install command
if command -v apt &>/dev/null; then
  PKG_UPDATE="$SUDO apt update"
  PKG_INSTALL="$SUDO apt install -y"
  DEPS="zsh git curl unzip wget neovim fzf tmux xclip build-essential"
elif command -v dnf &>/dev/null; then
  PKG_UPDATE="$SUDO dnf makecache"
  PKG_INSTALL="$SUDO dnf install -y"
  DEPS="zsh git curl unzip wget neovim fzf tmux xclip @development-tools"
elif command -v pacman &>/dev/null; then
  PKG_UPDATE="$SUDO pacman -Sy"
  PKG_INSTALL="$SUDO pacman -S --noconfirm"
  DEPS="zsh git curl unzip wget neovim fzf tmux xclip base-devel"
elif command -v apk &>/dev/null; then
  PKG_UPDATE="$SUDO apk update"
  PKG_INSTALL="$SUDO apk add"
  DEPS="zsh git curl unzip wget neovim fzf tmux xclip build-base"
else
  echo "❌ Unsupported package manager"
  exit 1
fi

echo "🔧 Updating package lists..."
eval "$PKG_UPDATE"

echo "📦 Installing base dependencies..."
eval "$PKG_INSTALL $DEPS"

echo "📦 Installing Rust (for eza)..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# Add Rust to path persistently if installed
if [ -f "$HOME/.cargo/env" ]; then
  mkdir -p ~/.config/zsh
  echo 'source "$HOME/.cargo/env"' >> ~/.config/zsh/exports.zsh
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.config/zsh/exports.zsh
fi

echo "📦 Installing eza with cargo..."
if ! command -v eza &>/dev/null; then
  cargo install eza
else
  echo "✅ eza already installed"
fi

echo "📦 Installing LazyGit..."
if ! command -v lazygit &>/dev/null; then
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)
  wget "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" -O lazygit.tar.gz
  tar xf lazygit.tar.gz lazygit
  $SUDO install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
else
  echo "✅ LazyGit already installed"
fi

# ✅ Set Zsh as the default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔄 Changing default shell to Zsh..."
  chsh -s "$(which zsh)" || echo "⚠️ chsh failed (probably running in Docker)."
fi

# ✅ Auto-start tmux in Zsh if inside interactive terminal
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  echo "🚀 Launching tmux inside Zsh..."
  exec zsh -c "tmux"
else
  exec zsh
fi
