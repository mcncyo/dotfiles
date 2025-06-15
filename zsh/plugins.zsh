# ~/.config/zsh/plugins.zsh

# Enable completion system
autoload -Uz compinit
compinit

# Enable better globbing and history
setopt autocd
setopt correct
setopt extended_glob
setopt hist_ignore_all_dups

# FZF support (if installed)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

