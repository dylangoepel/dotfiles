#!/bin/bash

# this script installs required programs
buildAur() {
    repoUrl="$1"
    buildDir=$(mktemp -d)
    echo "[***] build $repoUrl"
    git clone "$repoUrl" "$buildDir"
    pushd "$buildDir"
    makepkg -si
    popd
    rm -rf "$buildDir"
}

buildMake() {
    repoUrl="$1"
    buildDir=$(mktemp -d)
    echo "[***] build $repoUrl"
    git clone "$repoUrl" "$buildDir"
    pushd "$buildDir"
    make
    sudo make install
    popd
    rm -rf "$buildDir"
}

yay -Qq >/dev/null || buildAur https://aur.archlinux.org/yay.git
lsrc >/dev/null || buildAur https://aur.archlinux.org/rcm.git

[ -d /usr/share/fonts/TTF/MonoLisa ] || sudo git clone https://github.com/koprab/monalisa-font.git /usr/share/fonts/TTF/MonoLisa

sudo pacman -Syyu
sudo pacman -S --noconfirm sddm sway picom firefox kitty pavucontrol zathura zathura-pdf-mupdf mpv thunderbird lsd fzf zsh neovim emacs gcc go python python-pip yt-dlp tmux entr light alsa-utils git make ghc xwallpaper nodejs pipewire pipewire-pulse texlive texlive-science texlive-humanities texlive-latexextra inkscape

cp -rf home ~/.dotfiles
rcup -v
