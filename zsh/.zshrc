# ~/.config/zsh/.zshrc

# Set history options
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST

# Source other config parts
source "${ZDOTDIR:-$HOME/.config/zsh}/exports.zsh"
source "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"
source "${ZDOTDIR:-$HOME/.config/zsh}/functions.zsh"
source "${ZDOTDIR:-$HOME/.config/zsh}/prompt.zsh"
source "${ZDOTDIR:-$HOME/.config/zsh}/plugins.zsh"

