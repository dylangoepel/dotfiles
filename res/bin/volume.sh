#!/bin/bash
set ${1:-get}
 
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
fi

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
