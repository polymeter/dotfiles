#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

# Set wallpaper
if [ -x $(command -v feh) ] && [ -d ~/.wallpapers ]; then
    feh --no-fehbg --randomize --bg-fill ~/.wallpapers &
fi

exec i3
