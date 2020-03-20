#!/bin/bash
set ${1:-get}

function get_volume {
  amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
  iconSound="audio-volume-high"
  iconMuted="audio-volume-muted"
  if is_mute ; then
    dunstify -i $iconMuted -r 2593 -u normal "mute"
  else
    volume=$(get_volume)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i $iconSound -r 2593 -u normal "    $bar"
  fi
}
 
sinks=$(pacmd list-sinks | grep index | sed "s,.*index: ,,g")

if [[ $1 == "cycle" ]]
then
    current=$(pactl list sink-inputs | grep "Sink:" | head -n 1 | tr -d "\t" | sed "s,Sink: ,,g")
    lastSink=$(echo $sinks | grep -Eo "[0-9]+ {0,1}$")

    new=$(( ($current + 1) % ($lastSink + 1) ))
    echo $current
    echo $new

    inputs=$(pactl list sink-inputs | grep "Sink Input #" | sed "s,Sink Input #,,g")

    for input in $inputs
    do
        pactl move-sink-input $input $new
    done
    dunstify ""
fi

for sink in $sinks
do
    if [[ $1 == "inc" ]]
    then
        # set the volume on (if it was muted)
        amixer set Master on > /dev/null
        # up the volume (+ 5%)
        amixer sset Master 5%+ > /dev/null
        send_notification
    elif [[ $1 == "dec" ]]
    then
        amixer set Master on > /dev/null
        amixer sset Master 5%- > /dev/null
        send_notification
    elif [[ $1 == "mute" ]]
    then
        amixer set Master 1+ toggle > /dev/null
        send_notification
    elif [[ $1 == "get" ]]
    then
        pactl list sinks | tr -d "\t" | grep ^Volume | cut -d"/" -f 2 | tr -d " "
    fi
done
