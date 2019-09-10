install = sudo pacman -S --needed --noconfirm -q

all: vim de tmux bash

# bash
include bash.mk

# tmux
include tmux.mk

# vim
include vim.mk

# desktop environment
include de.mk
