#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing base dependencies..."
sudo apt update
sudo apt install -y zsh git curl unzip wget neovim fzf tmux bat fd-find xclip

echo "📦 Installing Rust (for zoxide and eza)..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

echo "🔧 Installing Rust tools..."
if ! command -v eza &>/dev/null; then
  cargo install eza
fi

if ! command -v zoxide &>/dev/null; then
  cargo install zoxide
fi

echo 'eval "$(zoxide init zsh)"' >> ~/.config/zsh/plugins.zsh

echo "📦 Installing LazyGit..."
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
sudo chown -R $USER:$USER "$SCRIPT_DIR/zsh/powerlevel10k"
find "$SCRIPT_DIR/zsh/powerlevel10k" -name '*.zwc' -delete
cp -r "$SCRIPT_DIR/zsh/powerlevel10k" ~/.config/zsh/
cp "$SCRIPT_DIR/zshenv" ~/.zshenv

echo "📁 Setting up Neovim config..."
mkdir -p ~/.config/nvim
cp -r "$SCRIPT_DIR/nvim/"* ~/.config/nvim/

echo "📁 Setting up tmux config..."
cp "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf

echo "🧵 Enabling auto-tmux in Zsh..."
cat << 'EOF' >> ~/.config/zsh/.zshrc

# --- Auto-start tmux on shell or SSH login ---
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" -o -n "$DISPLAY" ]; then
  tmux attach -t main || tmux new -s main
fi
EOF

echo "🧠 Setting up global Git config..."
cat << EOF > ~/.gitconfig
[user]
  name = Your Name
  email = your@email.com
[core]
  editor = nvim
[alias]
  co = checkout
  st = status
  ci = commit
  br = branch
[init]
  defaultBranch = main
EOF

echo "🔑 Generating SSH key (if needed)..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "your@email.com" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "✅ SSH key created. Add this to GitHub/GitLab:"
  cat "$HOME/.ssh/id_ed25519.pub"
else
  echo "✅ SSH key already exists."
fi

echo "🎉 Dotfiles setup complete! Type 'zsh' or open new terminal to enjoy!"
