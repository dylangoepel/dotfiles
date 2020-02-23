install = sudo pacman -S --needed --noconfirm -q

all: vim de tmux shell extra term bin

# shell
include mod/shell.mk

# tmux
include mod/tmux.mk

# vim
include mod/vim.mk

# desktop environment
include mod/de.mk

# alacritty terminal
include mod/terminal.mk

# binaries and scripts
include mod/bin.mk

# other things
include mod/extra.mk
