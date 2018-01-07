# Add custom scripts directory if present
if [ -d ~/bin ]; then
    typeset -U path
    path+=~/bin
fi

# Start X if logging in locally to tty1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
