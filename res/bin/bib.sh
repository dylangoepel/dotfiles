#!/bin/sh
if [[ $(tmux list-sessions | grep -E "^bg: " | wc -l) -eq 0 ]]
then
    echo Creating new session...
    tmux new-session -s bg -d
fi

if [[ $ISBIB -ne 1 ]]
then
    echo start st
    tmux new-window -t bg -e ISBIB=1 bib
    st tmux attach -t bg
    echo done.
else
    echo lading....
    cd ~/doc
    file="$(find /mnt ~/doc | sed -n "/.\(pdf\|epub\|xps\)$/ {s,^.*/,,g; p}" | fzf)"
    filename="$(find /mnt ~/doc -name "$file" | head -n 1)"
    tmux detach
    zathura "$filename"
fi
