# ~/.config/zsh/p10k.zsh

# Prompt segments configuration
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time)

# Prompt appearance
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰▶ "

# Directory settings
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

# Git
typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true

# Time format
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

# Icons (require Nerd Fonts)
typeset -g POWERLEVEL9K_DIR_ICON='\uf07c '          # folder
typeset -g POWERLEVEL9K_HOME_ICON='\uf015 '         # home
typeset -g POWERLEVEL9K_VCS_GIT_ICON='\ue0a0 '      # Git logo

