#!/bin/bash
set -e

# Make script location-aware
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing base dependencies..."
sudo apt update
sudo apt install -y zsh git curl unzip wget neovim fzf tmux

echo "📦 Installing Rust (for eza)..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "✅ Rust already installed"
fi

echo "📦 Installing eza with cargo..."
if ! command -v eza &>/dev/null; then
  cargo install eza
else
  echo "✅ eza already installed"
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
  echo "✅ Hack Nerd Font installed"
else
  echo "✅ Hack Nerd Font already present"
fi

echo "📁 Setting up Zsh config..."

# Set Zsh as default shell
chsh -s "$(which zsh)"

# Copy modular config
mkdir -p ~/.config/zsh
cp "$SCRIPT_DIR/zsh/"*.zsh ~/.config/zsh/

# Fix theme permissions and remove compiled files
sudo chown -R $USER:$USER "$SCRIPT_DIR/zsh/powerlevel10k"
find "$SCRIPT_DIR/zsh/powerlevel10k" -name '*.zwc' -delete
cp -r "$SCRIPT_DIR/zsh/powerlevel10k" ~/.config/zsh/

# Copy .zshenv
cp "$SCRIPT_DIR/.zshenv" ~/.zshenv

echo "📁 Setting up Neovim config..."
mkdir -p ~/.config/nvim
cp -r "$SCRIPT_DIR/nvim/"* ~/.config/nvim/

echo "📁 Setting up tmux config..."
cp "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf

echo "✅ All done! Set your terminal font to 'Hack Nerd Font' and start Zsh with: zsh"
