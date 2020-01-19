#!/bin/sh

if [[ $(tmux list-sessions | grep -E "^bg: " | wc -l) -eq 0 ]]
then
    echo Creating new session...
    tmux new-session -s bg -d
fi

if [[ $ISMED -ne 1 ]]
then
    echo start st
    tmux new-window -t bg -e ISMED=1 med
    st tmux attach -t bg
    echo done.
else
    cd ~/doc
    file="$(find /mnt ~/media | sed -n "/\(mkv\|mp4\|mpeg\|webm\|m3u\|pls\)$/ {s,^.*/,,g; p}" | fzf)"
    filename="$(find /mnt ~/media -name "$file" | head -n 1)"
    tmux detach
    mpv "$filename"
fi

