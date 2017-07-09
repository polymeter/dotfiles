# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# On systems that compile bash without -DSYS_BASHRC, we should manually source
# the system-wide bashrc.
# Having $PROMPT_COMMAND indicates that the global bashrc is already loaded.
if [ -z "$PROMPT_COMMAND" ]; then
    if [ -f /etc/bash.bashrc ]; then
        # Default path as per bash documentation
        . /etc/bash.bashrc
    elif [ -f /etc/bashrc ]; then
        # On CentOS systems, the global bashrc is different
        . /etc/bashrc
    fi
fi

# Prompt configuration
# This uses 3 variants:
# a) Local user (no ssh): Green username (without hostname)
# b) Remote user (over ssh): Yellow username@hostname
# c) root (same for local and remote): Red root@hostname
if [ $(whoami) == "root" ]; then
    PS1="\[\033[1;31m\]\u@\h \[\033[0;34m\]\w\[\033[0;m\]\n\\$ "
elif [ -z "$SSH_CLIENT" ]; then
    PS1="\[\033[1;32m\]\u \[\033[0;34m\]\w\[\033[0;m\]\n\\$ "
else
    PS1="\[\033[1;33m\]\u@\h \[\033[0;34m\]\w\[\033[0;m\]\n\\$ "
fi

# Ignore duplicates and lines starting with spaces in history
export HISTCONTROL=ignoreboth

# Enable history-based / prefix-based completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

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
