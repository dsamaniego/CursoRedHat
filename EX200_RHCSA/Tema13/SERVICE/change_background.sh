#!/bin/bash


if [ $(date +%H) -lt 14 ];
then
    cp /usr/share/gnome-shell/theme/background_am.png /usr/share/gnome-shell/theme/noise-texture.png
else
   cp /usr/share/gnome-shell/theme/background_pm.png /usr/share/gnome-shell/theme/noise-texture.png
fi


