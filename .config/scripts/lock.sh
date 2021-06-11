#!/bin/sh -e

# Take a screenshot
scrot -o /tmp/screen_locked.png

# Pixellate it 10x
convert /tmp/screen_locked.png -scale 10% -blur 0x1 -resize 1000% /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png

