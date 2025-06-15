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

echo "🔧 Installing base dependencies..."
$SUDO apt update
$SUDO apt install -y zsh git curl unzip wget neovim fzf tmux xclip build-essential

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

echo "✅ Setup complete!"
