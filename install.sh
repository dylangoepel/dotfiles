#!/bin/bash

# this script installs required programs
buildAur() {
    repoUrl="$1"
    buildDir=$(mktemp -d)
    echo "[***] build $repoUrl"
    git clone "$repoUrl" "$buildDir" || return "$?"
    pushd "$buildDir"
    makepkg -si || return "$?"
    popd
    rm -rf "$buildDir"
}

buildMake() {
    repoUrl="$1"
    buildDir=$(mktemp -d)
    echo "[***] build $repoUrl"
    git clone "$repoUrl" "$buildDir" || return "$?"
    pushd "$buildDir"
    make || return "$?"
    sudo make install || return "$?"
    popd
    rm -rf "$buildDir"
}

sudo pacman -S --needed --noconfirm $(cat packages.txt | tr "\n" " ") || return "$?"

cat packages.aur.txt | while read p; do
    if pacman -Qq | grep -E "^$p$" >/dev/null
    then
        echo "$p is already installed."
    else
        buildAur "https://aur.archlinux.org/$p.git"
    fi
done
