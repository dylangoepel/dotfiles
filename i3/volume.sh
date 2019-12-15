#!/bin/bash
set ${1:-get}
 
sinks=$(pacmd list-sinks | grep index | sed "s,.*index: ,,g")

for sink in $sinks
do
    if [[ $1 == "inc" ]]
    then
        pactl set-sink-volume $sink +5%
    elif [[ $1 == "dec" ]]
    then
        pactl set-sink-volume $sink -5%
    elif [[ $1 == "mute" ]]
    then
        pactl set-sink-mute $sink toggle
    elif [[ $1 == "get" ]]
    then
        pactl list sinks | tr -d "\t" | grep ^Volume | cut -d"/" -f 2 | tr -d " "
    fi
done
