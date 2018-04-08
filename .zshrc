# Color support
autoload -Uz colors
colors

# Support for git (and hg, svn)
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:git:*' actionformats ' %b[%a] %m'
zstyle ':vcs_info:git:*' formats ' %b %m'
zstyle ':vcs_info:(hg|svn):*' actionformats ' %s:%b[%a]'
zstyle ':vcs_info:(hg|svn):*' formats ' %s:%b'

# Show commits ahead/behind (credit: https://github.com/zsh-users/zsh)
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "+${ahead}" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

# Prompt configuration
autoload -Uz promptinit
promptinit
setopt prompt_subst

if [ -n "$SSH_CLIENT" ]; then
    # When used over SSH, always display user and hostname
    p_user="%(#.%F{red}.%F{yellow})%B%n@%m%b%f "
else
    # When used locally, only display user and hostname when root
    p_user="%(#.%F{red}%B%n@%m%b%f .)"
fi
PROMPT='${p_user}%F{blue}%~%f%F{10}${vcs_info_msg_0_}%f %F{cyan}${VIRTUAL_ENV:t}%f${prompt_newline}%(?.%F{green}.%F{red})%#%f '
RPROMPT=""

# Disable automatic prompt modification, we handle that ourselves.
export VIRTUAL_ENV_DISABLE_PROMPT=1

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
if [ -z "$key" ]; then
    typeset -A key
    key=(Up "^[[A" Down "^[[B")
fi
bindkey "${key[Up]}" history-beginning-search-backward
bindkey "${key[Down]}" history-beginning-search-forward

# Support additional text objects (only supported by zsh >= 5.0.8)
autoload -Uz is-at-least
if is-at-least 5.0.8; then
    autoload -Uz select-bracketed select-quoted
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
fi

# Misc options
setopt autocd
setopt extendedglob
setopt nomatch
unsetopt beep
unsetopt notify

# Completion
autoload -Uz compinit
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

# Enable fzf if available
# Try all known possible install locations (packaging-dependent).
fzf_paths=(
/usr/share/fzf # Arch linux package
/usr/local/share/examples/fzf/shell # FreeBSD pkg
)
for cand_path in $fzf_paths; do
    if [ -f "$cand_path/key-bindings.zsh" ]; then
        source "$cand_path/key-bindings.zsh"
        break
    fi
done
unset fzf_paths cand_path

# Source custom aliases and functions (same for all bourne-compatible shells)
[ -f ~/.aliases ] && . ~/.aliases
[ -f ~/.functions ] && . ~/.functions
