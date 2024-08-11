#!/bin/bash

render_item() {
  local tasks
  tasks=$(get_tasks)
  sketchybar --set $NAME label="$tasks" \
             --set date icon.drawing=$drawing
}

get_tasks() {
  if which "icalBuddy" &>/dev/null; then
    drawing="off"
    input=$(/opt/homebrew/bin/icalBuddy -npn -nc -iep 'datetime,title,location' -po 'datetime,title,location' -ea -n -ps '|: |' -b '' eventsNow)
    currentTime=$(date '+%I:%M %p')

    if [ -n "$input" ]; then
      IFS='^' read events <<< "$input"
      theEvent="$events"
      echo "$theEvent"
      return
    else
      local nextEvent
      nextEvent=$(get_next_event)
      echo "$nextEvent"
    fi
  else
    echo "Please install icalBuddy → brew install ical-buddy."
  fi
}

get_next_event() {
  if which "icalBuddy" &>/dev/null; then
    drawing="off"
    input=$(/opt/homebrew/bin/icalBuddy -ec 'Found in Natural Language,CCSF' -npn -nc -iep 'datetime,title' -po 'datetime,title' -eed -ea -n -li 4 -ps '|: |' -b '' eventsToday)
    currentTime=$(date '+%I:%M %p')

    if [ -n "$input" ]; then
      IFS='^' read -ra events <<< "$input"
      for anEvent in "${events[@]}"; do
        IFS='^' read -ra eventItems <<< "$anEvent"
        eventTime=${eventItems[0]}
        if [ "$eventTime" '>' "$currentTime" ]; then
          theEvent="$anEvent"
          drawing="on"
          echo "next event" "$theEvent"
          return
        fi
      done
      #echo "No upcoming events today"
    else
      echo "No upcoming events today"
    fi
  else
    echo "Please install icalBuddy → brew install ical-buddy."
  fi
}

update() {
  render_item
}

popup() {
  local events
  events=$(get_events)
  sketchybar --set clock.next_event label="$events" \
             --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced")
  update
  ;;
"mouse.entered")
  popup on
  ;;
"mouse.exited" | "mouse.exited.global")
  popup off
  ;;
esac

# get_tasks() {
#   if which "icalBuddy" &>/dev/null; then
#     drawing="off"
#     input=$(/opt/homebrew/bin/icalBuddy -ec 'Found in Natural Language,CCSF' -npn -nc -iep 'datetime,title' -po 'datetime,title' -eed -ea -n -li 4 -ps '|: |' -b '' eventsToday)
#     currentTime=$(date '+%I:%M %p')

#     if [ -n "$input" ]; then
#       IFS='^' read -ra events <<< "$input"
#       for anEvent in "${events[@]}"; do
#         IFS='^' read -ra eventItems <<< "$anEvent"
#         eventTime=${eventItems[0]}
#         if [ "$eventTime" '>' "$currentTime" ]; then
#           theEvent="$anEvent"
#           drawing="on"
#           echo "$theEvent"
#           return
#         fi
#       done
#       echo "No upcoming events today"
#     else
#       echo "No events today"
#     fi
#   else
#     echo "Please install icalBuddy → brew install ical-buddy."
#   fi
# }
