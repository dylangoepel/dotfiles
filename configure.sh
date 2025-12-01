#!/bin/bash

sudo cp -rvf fonts/TTF fonts/OTF /usr/share/fonts
sudo cp -rvf etc /etc/ || return "$?"
cp -rf home ~/.dotfiles || return "$?"

sudo systemctl enable greetd || return "$?"
rcup -v || return "$?"
