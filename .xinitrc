#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

# Disable DPMS and screen saver
if [ -x $(command -v xset) ]; then
    xset -dpms
    xset s off
fi

exec i3
