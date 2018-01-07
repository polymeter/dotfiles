# Color support
autoload -U colors
colors

# Support for git (and hg, svn)
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:git:*' actionformats ' %b[%a]'
zstyle ':vcs_info:git:*' formats ' %b'
zstyle ':vcs_info:(hg|svn):*' actionformats ' %s:%b[%a]'
zstyle ':vcs_info:(hg|svn):*' formats ' %s:%b'

autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

# Prompt configuration
autoload -U promptinit
promptinit
setopt prompt_subst

if [ -n "$SSH_CLIENT" ]; then
    # When used over SSH, always display user and hostname
    p_user="%(#.%F{red}.%F{yellow})%B%n@%m%b%f "
else
    # When used locally, only display user when root
    p_user="%(#.%F{red}%B%n%b%f .)"
fi
PROMPT='${p_user}%F{blue}%~%f%F{10}${vcs_info_msg_0_}%f${prompt_newline}%(?.%F{green}.%F{red})%#%f '
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
