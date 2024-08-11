#!/bin/bash

task=(
  update_freq=60
  script="$PLUGIN_DIR/calendar.sh"
  icon=􁐑
  background.color=$(getcolor green)
  background.height=24
  background.corner_radius=16
  icon.font.size=16
  icon.padding_left=$PADDINGS
  icon.padding_right=0
  icon.color="$(getcolor black 75)"
  label.color="$(getcolor black 75)"
  label.padding_right=$PADDINGS
  label.font.size=12
  label.font.style=Bold
  click_script="open -a /System/Applications/Calendar.app"
)

sketchybar  --add item task left    \
            --set task "${task[@]}"
