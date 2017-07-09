# Color support
autoload -U colors
colors

# Prompt configuration
# This uses 3 variants:
# a) Local user (no ssh): Green username (without hostname)
# b) Remote user (over ssh): Yellow username@hostname
# c) root (same for local and remote): Red root@hostname
autoload -U promptinit
promptinit

if [ -z "$SSH_CLIENT" ]; then
    PROMPT="%{%(#.$fg[red]%B%n@%m.$fg[green]%B%n)%}%b %{$fg[blue]%}%~%{$reset_color%}
%# "
else
    PROMPT="%{%(#.$fg[red].$fg[yellow])%}%B%n@%m%b %{$fg[blue]%}%~%{$reset_color%}
%# "
fi
RPROMPT="%(?..%{$fg[red]%}%B!%b%{$reset_color%})"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# Keybindings
bindkey -v
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Misc options
setopt autocd
setopt extendedglob
setopt nomatch
unsetopt beep
unsetopt notify

# Completion
autoload -U compinit
compinit

# Disable completion of hostnames from /etc/hosts
zstyle ':completion:*' hosts off

# Set LS_COLORS
if [ $(uname -s) = "Linux" ]; then
    # On Linux, use the dircolors tool
    eval $(dircolors ~/.dircolors)
elif [ $(uname -s) = "FreeBSD" ]; then
    # On FreeBSD, a different format is used
    export LSCOLORS=ExGxFxdxCxDxDxxbxdAeAe
fi

# Source custom aliases and functions (same for all bourne-compatible shells)
[ -f ~/.aliases ] && . ~/.aliases
[ -f ~/.functions ] && . ~/.functions
