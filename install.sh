#!/bin/bash
set -e

# Make script location-aware
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing base dependencies..."
sudo apt update
sudo apt install -y zsh git curl unzip wget neovim fzf tmux xclip

echo "📦 Installing Rust (for eza)..."
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# Add Rust to path persistently if installed
if [ -f "$HOME/.cargo/env" ]; then
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
  wget "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar -xzf "lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" lazygit
  sudo mv lazygit /usr/local/bin
  rm "lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  echo "✅ LazyGit installed"
else
  echo "✅ LazyGit already installed"
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
chsh -s "$(which zsh)"
mkdir -p ~/.config/zsh
cp "$SCRIPT_DIR/zsh/"*.zsh ~/.config/zsh/
if [ -d "$SCRIPT_DIR/zsh/powerlevel10k" ]; then
  echo "🎨 Setting up Powerlevel10k theme..."
  sudo chown -R "$USER:$USER" "$SCRIPT_DIR/zsh/powerlevel10k"
  find "$SCRIPT_DIR/zsh/powerlevel10k" -name '*.zwc' -delete
  cp -r "$SCRIPT_DIR/zsh/powerlevel10k" ~/.config/zsh/
else
  echo "⚠️  Powerlevel10k theme directory not found. Skipping theme setup."
fi
cp "$SCRIPT_DIR/.zshenv" ~/.zshenv

echo "📁 Setting up Neovim config..."
mkdir -p ~/.config/nvim
cp -r "$SCRIPT_DIR/nvim/"* ~/.config/nvim/

echo "📁 Setting up tmux config..."
cp "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf

echo "🧵 Enabling auto-tmux in Zsh..."
cat << 'EOF' >> ~/.config/zsh/.zshrc

# --- Auto-start tmux on shell or SSH login ---
# --- Enable 12-hour clock format ---
export TIMEFMT=$'%D{%I:%M:%S %p}  %J  %P  %*'

# --- Enable copy/paste in terminal (if terminal supports it) ---
autoload -Uz select-word-style
select-word-style bash
bindkey -e
bindkey '^[[200~' bracketed-paste-begin

if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" -o -n "$DISPLAY" ]; then
  tmux attach -t main || tmux new -s main
fi
EOF

echo "🧠 Setting up global Git config..."
read -rp "Enter your Git user name: " GIT_NAME
read -rp "Enter your Git email: " GIT_EMAIL

cat << EOF > ~/.gitconfig
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL
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
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "✅ SSH key created. Add this to GitHub/GitLab:"
  cat "$HOME/.ssh/id_ed25519.pub"
else
  echo "✅ SSH key already exists."
fi

echo "📎 Linking nano and pico to Neovim..."
sudo ln -sf "$(command -v nvim)" /usr/local/bin/nano
sudo ln -sf "$(command -v nvim)" /usr/local/bin/pico

echo "🎉 Dotfiles setup complete! Start Zsh or SSH again to enjoy your tmux-powered environment."

echo "🔑 Setting up SSH for GitHub..."

# Generate SSH key if it doesn't exist
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "✅ SSH key created. Add this to GitHub:"
  cat "$HOME/.ssh/id_ed25519.pub"
else
  echo "✅ SSH key already exists."
fi

# Check if dotfiles is a Git repo and SSH is not configured
if git rev-parse --is-inside-work-tree &>/dev/null; then
  CURRENT_REMOTE=$(git remote get-url origin)
  if echo "$CURRENT_REMOTE" | grep -q "^https://"; then
    echo "🔁 Updating Git remote to use SSH..."
    SSH_REMOTE=$(echo "$CURRENT_REMOTE" | sed -E 's~https://github.com/~git@github.com:~' | sed 's~\.git$~~')
    git remote set-url origin "$SSH_REMOTE.git"
    echo "✅ Remote set to $SSH_REMOTE.git"
  fi
fi
