#
# ████████         ██     
#░░░░░░██         ░██     
#     ██    ██████░██     
#    ██    ██░░░░ ░██████ 
#   ██    ░░█████ ░██░░░██
#  ██      ░░░░░██░██  ░██
# ████████ ██████ ░██  ░██
#░░░░░░░░ ░░░░░░  ░░   ░░ 
#
zle -N autosuggest-accept

# Auto Add {{{
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# }}}

# Plugins {{{
# Auto Add {{{
### Added by Zplugin's installer
source '/home/ruwey/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk
# }}}

# Prompt
zplugin ice depth=1; zplugin light romkatv/powerlevel10k

# For the selection menu when looking at autocomplete
#zplugin ice wait'!1'
#zplugin snippet OMZ::lib/completion.zsh

# Crasis menu
zplugin ice wait'!1'
zplugin light zdharma/zui
zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'
zplugin load zdharma/zplugin-crasis

# Fish like syntax highlighting
zplugin ice wait'!0'
zplugin light zdharma/fast-syntax-highlighting 

# Fish like autosuggestions
zplugin ice wait'!1' atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
# }}}

# Configuration {{{ 
# Set color scheme from wpgtk
#(cat $HOME/.config/wpg/sequences &)

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
{%@@ if colorscheme == "Nord" @@%}
eval $(dircolors ~/.dir_colors)
{%@@ endif @@%}
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# Vim bindings for completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# PowerLine 10K (Prompt) {{{
# Config
# Don't give me annoying config dialog
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Choose elements
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vi_mode)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)

## Vi Mode
POWERLEVEL9K_VI_INSERT_MODE_STRING='I'
POWERLEVEL9K_VI_COMMAND_MODE_STRING='N'

# Vcs
# Icons
POWERLEVEL9K_VCS_BRANCH_ICON=' '
POWERLEVEL9K_VCS_COMMIT_ICON=' '
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=' '
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=' '
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=' '
POWERLEVEL9K_VCS_GIT_ICON=' '
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=' '
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=' '
POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=' '
POWERLEVEL9K_VCS_STAGED_ICON=' '
POWERLEVEL9K_VCS_STASH_ICON=' '
POWERLEVEL9K_VCS_UNSTAGED_ICON=' '
POWERLEVEL9K_VCS_UNTRACKED_ICON=' '

# Dir
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

## OS Icon
POWERLEVEL9K_LINUX_ARCH_ICON=' '

# Style
{%@@ if colorscheme == "Mntns" @@%}
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=' '

# Vi Mode
POWERLEVEL9K_VI_MODE_BACKGROUND='red'
POWERLEVEL9K_VI_MODE_FOREGROUND='black'
#
## Status
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='yellow'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='black'
#
## Dir
POWERLEVEL9K_DIR_BACKGROUND='black'
POWERLEVEL9K_DIR_FOREGROUND='green'

# OS Icon
POWERLEVEL9K_OS_ICON_BACKGROUND='red'
POWERLEVEL9K_OS_ICON_FOREGROUND='black'
{%@@ endif @@%}
#}}}
#}}}

# Aliases {{{

# Bind ctrl + f to autosuggestions
bindkey '^f' autosuggest-accept

# Dot Files Git
alias cfg='git --work-tree=$HOME/.dot --git-dir=$HOME/.dot/.git'

# Make vim go to neovim
alias -g vim='nvim'

# Ranger
alias r='ranger'

# Long list
alias ll='ls -la'

# LS with color
alias ls='ls --color'

# Dotdrop
alias dotdrop="DOTDROP_CONFIG=~/.dotdrop/config.yaml ~/.dotdrop/dotdrop.sh"

# Alias c for clear
alias c=clear

alias scdl="youtube-dl --embed-thumbnail -f mp3 -i --add-metadata"
# }}}

# vim:foldmethod=marker
