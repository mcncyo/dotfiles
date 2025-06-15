# 🛠️ Dotfiles Setup for Pop!_OS

This repo contains my personal Zsh and Neovim configuration, with a one-command installer to set everything up on a fresh machine.

---

## ✅ What This Setup Includes

- [Zsh](https://www.zsh.org/) with:
  - Modular config in `~/.config/zsh`
  - Powerlevel10k prompt
  - Useful aliases and functions
  - Nerd Font support (Hack Nerd Font)
- [Neovim](https://neovim.io/) with custom settings (`init.lua`)
- [eza](https://github.com/eza-community/eza) — modern `ls`
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder
- Rust-based installation of `eza` (if needed)
- Automatic Nerd Font installation
- Auto-sets Zsh as the default shell

---

## 🚀 Installation

### 1. Clone this repo

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer

```bash
./install.sh
```

This script:
- Installs needed packages
- Sets up your Zsh + Powerlevel10k config
- Copies Neovim config
- Installs Hack Nerd Font
- Sets Zsh as your default shell

---

## 🖥️ Final Steps

1. **Change your terminal font** to **Hack Nerd Font**:
   - GNOME Terminal → Preferences → Profile → Custom Font → `Hack Nerd Font`

2. **Start Zsh** (or open a new terminal):

```bash
zsh
```

3. If you'd like to re-run the Powerlevel10k prompt wizard:

```bash
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
autoload -Uz p10k
p10k configure
```

---

## 📂 Directory Structure

```text
dotfiles/
├── install.sh
├── README.md
├── zsh/
│   ├── .zshenv
│   └── .config/zsh/
│       ├── aliases.zsh
│       ├── exports.zsh
│       ├── functions.zsh
│       ├── plugins.zsh
│       ├── prompt.zsh
│       ├── p10k.zsh
│       └── powerlevel10k/   ← cloned theme
├── nvim/
│   └── .config/nvim/
│       └── init.lua
```

---

## 🛠 Tips

- Edit your Zsh config in `~/.config/zsh`
- Your default prompt is defined in `p10k.zsh`
- Edit Neovim config in `~/.config/nvim/init.lua`

---

## 📬 TODO (Optional Add-ons)

- Add `lazy.nvim` plugin manager to Neovim
- Add language server setup (LSP)
- Add tmux config
- Add VSCode settings sync

---

## 🧠 License

This setup is yours to use and modify.
