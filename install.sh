#!/bin/bash

# this script installs required programs

# install <package>
install() {
    echo [PKG] $1
    sudo pacman -Qq | grep $1 >/dev/null || sudo pacman -S --noconfirm $1
}

# aur <package>
aur() {
    echo [PKG] AUR: $1
    yay -Qq | grep $1 >/dev/null || yay -S --noconfirm $1
}

# fromgit <url> <dir name>
fromgit() {
    echo "[PKG] $1: $2"
    sudo pacman -Qq | grep $2 >/dev/null
    if test $? -ne 0
    then
        git clone $1 $2
        cd $2
        makepkg -si
        cd ..
        rm -rf $2
    fi
}

makeinstall() {
    make
    sudo make install
}

makegit() {
    echo "[PKG] $1: $2"
    if [ ! -d "$2" ]
    then
        git clone "$1" "$2"
        pushd "$2"
        makeinstall
    else
        pushd "$2"
        git pull | grep "up to date" || makeinstall
    fi
    popd
}

# updatedir <src> <dst>
clonedir() {
    set "$(echo $1 | sed "s,/$,,g")/" "$(echo $2 | sed "s,/$,,g")/"
    echo "[CNF] $(echo $1 | grep -E -o "[^/]+/$" | tr -d "/")"
    find "$1" -type f | sed "s,^$1,,g" | while read path
    do
        dst=$2$path
        src=$1$path
        if [[ $src -nt $dst ]]
        then
            echo "[+] $src"
            dstdir=$(dirname $dst)
            [[ -d "$dstdir" ]] || mkdir -p "$dstdir"
            if [[ $(stat -c "%U" "$dstdir") = $(whoami) ]]
            then
                cp $src $dst
            else
                sudo cp $src $dst
            fi
        fi
    done
}

mkdir -p ~/.git

# aur helper
fromgit https://aur.archlinux.org/yay.git yay

# system update
# yay -Syu --noconfirm

# fonts
install ttf-fira-mono
aur nerd-fonts-hermit

# login screen
install sddm

# window manager
makegit https://github.com/dylangoepel/dwm.git ~/.git/dwm
install sxhkd
install dunst
install picom

# desktop programs
install firefox
install alacritty
install dmenu
install pavucontrol
install zathura
install zathura-pdf-mupdf
install libreoffice
install thunderbird
install mpv

# terminal programs
install neovim
install gcc
install go
install python
install python-pip
install youtube-dl
install tmux
install entr
install light
install alsa-utils
install git
install make
install ghc

# latex
install texlive
install texlive-science
install texlive-humanities
install texlive-latexextra

# copy configuration files
clonedir $PWD/home ~
clonedir $PWD/etc /etc

# systemd
# sudo systemctl enable --now sddm.service
