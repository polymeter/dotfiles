# Source environment variables (same for all bourne-compatible shells)
[ -f ~/.envvars ] && . ~/.envvars

# Add custom scripts directory if present
[ -d ~/bin ] && PATH="~/bin:$PATH"

# Source bashrc
# Note: .bash_profile is read for login shells, which do not automatically
#       source .bashrc - so let's do that here.
[ -f ~/.bashrc ] && . ~/.bashrc

# Start X if logging in locally to tty1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
