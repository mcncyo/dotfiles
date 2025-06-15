# Dotfiles Setup

A complete dotfiles setup for Zsh, tmux, Neovim, Git, and useful CLI tools — including auto-tmux, clipboard support, 12-hour clock formatting, and more.

## 🚀 Features

- ⚙️ Zsh configuration with modular `.zsh` files
- 🧵 Auto-start `tmux` on terminal or SSH login
- 🧠 Git global config setup (prompts for name and email)
- 🌈 Powerlevel10k theme support (if available)
- 🔤 Hack Nerd Font auto-installation
- 📝 Neovim configuration setup
- 🔁 `nano` and `pico` aliases to Neovim
- 🔧 Tools installed:
  - `zsh`, `git`, `curl`, `wget`, `unzip`, `fzf`, `tmux`, `neovim`
  - Rust + Cargo (used to install `eza`)
  - `lazygit` (latest release from GitHub)
- 🔒 SSH key auto-generation (if missing)
- 📋 Clipboard support with `xclip`
- 🕒 12-hour time formatting in shell
- ✅ Auto-detect and convert Git remote from HTTPS to SSH

## 📦 Installation

1. **Clone this repo:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git
   cd dotfiles
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Set terminal font to `Hack Nerd Font`:**
   - After install, open your terminal emulator settings and choose `Hack Nerd Font`.

4. **Add your SSH key to GitHub:**
   - If the installer generated a new SSH key, copy it:
     ```bash
     cat ~/.ssh/id_ed25519.pub
     ```
   - Then go to [GitHub SSH settings](https://github.com/settings/keys) and add it.

## 💡 Tips

- After reboot or re-login, `zsh` and `tmux` will auto-launch.
- Use `nvim` instead of `nano` or `pico` — all are now linked to Neovim.
- Your global `.gitconfig` will be initialized using your input during install.
- You can modify `.zshenv` and any file in `~/.config/zsh/` to tweak behavior.

## 📁 File Structure

```
dotfiles/
├── install.sh              # Main installer
├── .tmux.conf              # tmux configuration
├── .zshenv                 # Loads the Zsh config
├── zsh/
│   ├── aliases.zsh         # Custom aliases
│   ├── exports.zsh         # Environment variables
│   ├── functions.zsh       # Custom functions (optional)
│   └── powerlevel10k/      # Optional theme folder
└── nvim/                   # Neovim configuration
```

## 🧼 Cleanup

To remove tmux sessions:
```bash
tmux kill-session -a
```

To regenerate your SSH key:
```bash
rm -f ~/.ssh/id_ed25519*
ssh-keygen -t ed25519 -C "your@email.com"
```
