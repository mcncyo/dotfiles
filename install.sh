#!/bin/bash
set -e

echo "🔧 Installing base dependencies..."
sudo apt update
sudo apt install -y zsh git curl unzip wget neovim fzf

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
cp zsh/*.zsh ~/.config/zsh/

# Fix theme permissions and remove compiled files
sudo chown -R $USER:$USER zsh/powerlevel10k
find zsh/powerlevel10k -name '*.zwc' -delete
cp -r zsh/powerlevel10k ~/.config/zsh/

# Copy .zshenv
cp .zshenv ~/.zshenv

echo "📁 Setting up Neovim config..."
mkdir -p ~/.config/nvim
cp -r nvim/* ~/.config/nvim/

echo "✅ All done! Set your terminal font to 'Hack Nerd Font' and start Zsh with: zsh"
