install = sudo pacman -S --needed --noconfirm -q

all: vim de tmux

# tmux
include tmux.mk

# vim
include vim.mk

# desktop environment
include de.mk
