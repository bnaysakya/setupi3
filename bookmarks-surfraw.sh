#!/bin/bash
BROWSER=firefox
surfraw -browser=$BROWSER "$(cat ~/.config/surfraw/bookmarks | sed '/^$/d' | sed '/^#/d' | sed '/^\//d' | sort -n | rofi -dmenu -mesg ">>> Edit to add new bookmarks at ~/.config/surfraw/bookmarks" -i -p "bookmarks: " -lines 7 -eh 2 -fullscreen -padding 50  -font 'System San Francisco Display 18' -opacity 90)"
