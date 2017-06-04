#!/bin/bash
BROWSER=firefox
surfraw -browser=$BROWSER $(sr -elvi | awk -F'-' '{print $1}' | sed '/:/d' | awk '{$1=$1};1' | rofi -kb-row-select "Tab" -kb-row-tab "Control+space" -dmenu -mesg ">>> Tab = Autocomplete" -i -p "websearch: " -lines 7 -eh 2 -fullscreen -padding 50  -font 'System San Francisco Display 18' -opacity 90)
