#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing base dependencies..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y zsh git curl unzip wget neovim fzf tmux bat fd-find xclip wl-clipboard

echo "📦 Installing Rust (for zoxide and eza)..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

echo "🔧 Updating Rust tools..."
cargo install eza --force
cargo install zoxide --force

echo "📦 Installing LazyGit..."
..."
if ! command -v lazygit &>/dev/null; then
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)
  wget "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar -xzf "lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" lazygit
  sudo mv lazygit /usr/local/bin
  rm "lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
fi

echo "🔤 Installing Hack Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

if [ ! -f "HackNerdFont-Regular.ttf" ]; then
  wget -O Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
  unzip -o Hack.zip
  rm Hack.zip
  fc-cache -fv
fi

echo "📁 Setting up Zsh config..."
chsh -s "$(which zsh)"
mkdir -p ~/.config/zsh
cp "$SCRIPT_DIR/zsh/"*.zsh ~/.config/zsh/
echo "🎉 Dotfiles setup complete! Type 'zsh' or open new terminal to enjoy!"
