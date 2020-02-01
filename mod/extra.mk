extra: ytdl aria2 hack-ttf mpv brave

ytdl: /usr/bin/youtube-dl
/usr/bin/youtube-dl:
	$(install) youtube-dl

aria2: /usr/bin/aria2c
/usr/bin/aria2c:
	$(install) aria2

firefox: /usr/bin/firefox
/usr/bin/firefox:
	$(install) firefox

brave: /usr/bin/brave yay
/usr/bin/brave:
	yay -S --noconfirm brave-bin

yay: /usr/bin/yay
/usr/bin/yay: /usr/bin/git
	git clone https://aur.archlinux.org/yay.git ~/yay
	cd ~/yay; sudo -v; makepkg -si --noconfirm
	rm -rf ~/yay


qutebrowser: /usr/bin/qutebrowser
/usr/bin/qutebrowser:
	$(install) qutebrowser

hack-ttf: /usr/share/fonts/TTF/Hack-Regular.ttf
/usr/share/fonts/TTF/Hack-Regular.ttf:
	$(install) ttf-hack

mpv: /usr/bin/mpv
/usr/bin/mpv:
	$(install) mpv
