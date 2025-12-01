#!/bin/bash

rm -rf build/iso build/packdb build/packages
mkdir -p build/iso build/packdb build/packages

# download arch repo packages
dbpath="$PWD/build/packdb/"

# download repo packages
cat packages.txt | while read p; do
    if grep -E "^$p$" build/iso/packages.x86_64 >/dev/null
    then
        echo "[*] not adding $p"
    else
        echo "[*] adding $p"
        echo "$p" >> build/iso/packages.x86_64
        # cd build/packages
        # sudo pacman -Syw --noconfirm --needed --cachedir "$PWD" --dbpath "$dbpath" "$p" < ../../packages.txt || exit "$?"
        # cd ../..
    fi
done 

# build aur packages
buildAur() {
    repoUrl="$1"
    buildDir=$(mktemp -d)
    echo "[***] build $repoUrl"
    git clone "$repoUrl" "$buildDir" || return "$?"
    pkgdir="$PWD/build/packages"
    opwd="$PWD"
    cd "$buildDir"
    makepkg -s PKGDEST="$pkgdir" || return "$?"
    cd "$opwd"
    rm -rf "$buildDir"
}

cat packages.aur.txt | while read p; do
    if grep -E "^$p$" build/iso/packages.x86_64 >/dev/null
    then
        echo "[*] not adding $p"
    else
        echo "[*] adding $p"
        echo "$p" >> build/iso/packages.x86_64
    fi
    buildAur "https://aur.archlinux.org/$p.git" || exit "$?"
done

# create package db
cd build/packages
repo-add ./custom.db.tar.zst ./*.pkg.tar.zst
cd ../..

rm -rf build/iso/airootfs/etc/repo.d
cp -rvf build/packages build/iso/airootfs/etc/repo.d || exit "$?"

sudo ln -s /usr/lib/systemd/system/greetd.service build/iso/airootfs/etc/systemd/system/multi-user.target.wants

cp -rvf home build/iso/airootfs/root/.dotfiles || exit "$?"
cp -rvf etc/* build/iso/airootfs/etc || exit "$?"
