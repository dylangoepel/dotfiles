#!/bin/bash

# Simple 52/17 Productivity timer

function waitMinutes() {
    for min in $@
    do
        for sec in {0..59}
        do
            echo -ne "\033[K$min:$sec\r"
            sleep 1
        done
    done
}

while true
do
    echo Productivity session...
    waitMinutes {0..51}
    echo Take a break...
    waitMinutes {0..16}
done
