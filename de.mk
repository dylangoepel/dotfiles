de: xorg i3 startx

xorg: /usr/bin/Xorg
/usr/bin/Xorg:
	$(install) xorg

startx: /usr/bin/startx ~/.xinitrc
/usr/bin/startx:
	$(install) xorg-xinit

~/.xinitrc: xorg/xinitrc
	cp xorg/xinitrc ~/.xinitrc

i3: /usr/bin/i3 ~/.config/i3/config
/usr/bin/i3:
	$(install) i3

~/.config/i3/config: i3/config
	mkdir -p ~/.config/i3/
	cp i3/config $@
