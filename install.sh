#!/bin/bash

# this script installs required programs

# install <package>
install() {
    echo -n $1", "
    sudo pacman -Qq | grep $1 >/dev/null || sudo pacman -S --noconfirm $1
}

# aur <package>
aur() {
    echo -n $1", "
    yay -Qq | grep $1 >/dev/null || yay -S --noconfirm $1
}

# fromgit <url> <dir name>
fromgit() {
    echo -n $2", "
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
    echo -n $2", "
    if [ ! -d "$2" ]
    then
        git clone "$1" "$2"
        pushd "$2"
        makeinstall
        popd
    fi
}

# updatedir <src> <dst>
clonedir() {
    set "$(echo $1 | sed "s,/$,,g")/" "$(echo $2 | sed "s,/$,,g")/"
    echo $(echo $1 | grep -E -o "[^/]+/$" | tr -d "/")", "
    find "$1" -type f | sed "s,^$1,,g" | while read path
    do
        dst=$2$path
        src=$1$path
        if [[ $src -nt $dst ]]
        then
            echo -n "+, "
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
install ttf-linux-libertine
aur nerd-fonts-hermit
if [ ! -f /usr/share/fonts/TTF/Heebo-Black.ttf ]
then
    mkdir -p ~/Downloads
    pushd ~/Downloads
    if [ ! -f heebo.zip ]
    then
        curl https://dl.1001fonts.com/heebo.zip
    fi
    sudo unzip -d /usr/share/fonts/TTF heebo.zip
    popd
fi

mkdir -p ~/dev

# login screen
install sddm

# window manager
makegit https://github.com/dylangoepel/dwm.git ~/dev/dwm
makegit https://github.com/dylangoepel/dmenu.git ~/dev/dwm
makegit https://github.com/dylangoepel/btmenu.git ~/dev/btmenu
install sxhkd
install dunst
install picom

# desktop programs
aur brave-bin
install firefox
install alacritty
install pavucontrol
install zathura
install zathura-pdf-mupdf
install libreoffice
install thunderbird
install mpv

# terminal programs
install fzf
install zsh
install neovim
install emacs
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
install xwallpaper
install nodejs

# zsh theme
aur zsh-theme-powerlevel9k

# latex
install texlive
install texlive-science
install texlive-humanities
install texlive-latexextra

# copy configuration files
clonedir $PWD/home ~
clonedir $PWD/etc /etc

# spacemacs
if [[ ! -d ~/.emacs.d ]]
then
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

# systemd
# sudo systemctl enable --now sddm.service
