install = sudo pacman -S --needed --noconfirm -q

all: vim de tmux zsh extra st

# zsh
include zsh.mk

# tmux
include tmux.mk

# vim
include vim.mk

# desktop environment
include de.mk

# alacritty terminal
include st.mk

# other things
include extra.mk
