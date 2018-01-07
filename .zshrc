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

if [ -n "$SSH_CLIENT" ]; then
    p_user="%(#.%F{red}.%F{yellow})%B%n@%m%b%f "
else
    p_user="%(#.%F{red}%B%n%b%f .)"
fi
PROMPT="${p_user}%F{blue}%~%f${prompt_newline}%(?.%F{green}.%F{red})%#%f "
RPROMPT=""

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
KEYTIMEOUT=1 # only 0.1 s to switch to 'normal mode'

bindkey '^?' backward-delete-char # Allow backspacing over insert point
bindkey "^R" history-incremental-search-backward

bindkey -a "K" history-beginning-search-backward
bindkey -a "J" history-beginning-search-forward

# To avoid using raw escape sequences, some zsh versions (e.g. on Debian)
# determine the correct value from terminfo and populate key[...].
# These are used if available, otherwise falling back to the escape sequence.
if [[ -z "$key" ]]; then
    typeset -A key
    key=(Up "^[[A" Down "^[[B")
fi
bindkey "${key[Up]}" history-beginning-search-backward
bindkey "${key[Down]}" history-beginning-search-forward

# Support additional text objects
autoload -U select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted
for m in viopp visual; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

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
if [ $(uname -s) = "Linux" ] || [ $(uname -o) = 'Cygwin' ]; then
    # On Linux, use the dircolors tool
    eval $(dircolors ~/.dircolors)
elif [ $(uname -s) = "FreeBSD" ]; then
    # On FreeBSD, a different format is used
    export LSCOLORS=ExGxFxdxCxDxDxxbxdAeAe
fi

# Source custom aliases and functions (same for all bourne-compatible shells)
[ -f ~/.aliases ] && . ~/.aliases
[ -f ~/.functions ] && . ~/.functions
