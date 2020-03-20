#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_brightness {
    light -G
}

function send_notification {
  icon="preferences-system-brightness-lock"
  brightness=$(get_brightness)
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  # Send the notification
  dunstify -a "Brightness" -i "$icon" -r 5555 -u normal "Updated to $brightness%"
}

case $1 in
  up)
    # increase the backlight by 5%
    light -A 5
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    light -U 5
    send_notification
    ;;
  high)
    # set brightness to a predefined high level
    light -S 60
    send_notification
    ;;
  low)
    # set brightness to a predefined low level
    light -S 5
    send_notification
    ;;
esac
