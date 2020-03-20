de: xorg i3 startx nitrogen sddm picom sxhkd bspwm amixer

xorg: /usr/bin/Xorg
/usr/bin/Xorg:
	$(install) xorg

startx: /usr/bin/startx ~/.xinitrc
/usr/bin/startx:
	$(install) xorg-xinit

~/.xinitrc: res/xorg/xinitrc
	cp res/xorg/xinitrc ~/.xinitrc

i3: /usr/bin/i3 ~/.config/i3/config
/usr/bin/i3:
	$(install) i3

~/.config/i3/config: res/i3/config
	mkdir -p ~/.config/i3/
	cp res/i3/config $@

nitrogen: /usr/bin/nitrogen
/usr/bin/nitrogen:
	$(install) nitrogen

sddm: /usr/bin/sddm /usr/lib/sddm/sddm.conf.d/default.conf /etc/systemd/system/display-manager.service
/usr/bin/sddm:
	$(install) sddm
	sudo localectl set-x11-keymap de

/usr/lib/sddm/sddm.conf.d/default.conf: res/xorg/sddm.conf
	sudo cp $< $@

/etc/systemd/system/display-manager.service:
	sudo systemctl enable sddm

picom: /usr/bin/picom
/usr/bin/picom:
	$(install) picom

sxhkd: /usr/bin/sxhkd ~/.config/sxhkd/sxhkdrc
/usr/bin/sxhkd: 
	$(install) sxhkd
~/.config/sxhkd/sxhkdrc: res/sxhkd/sxhkdrc
	mkdir -p ~/.config/sxhkd/
	cp res/sxhkd/sxhkdrc $@

bspwm: /usr/bin/bspwm ~/.config/bspwm/bspwmrc dunst
/usr/bin/bspwm:
	$(install) bspwm

~/.config/bspwm/bspwmrc: res/bspwm/bspwmrc
	mkdir -p ~/.config/bspwm/
	cp res/bspwm/bspwmrc ~/.config/bspwm/bspwmrc
	chmod +x ~/.config/bspwm/bspwmrc 

dunst: /usr/bin/dunst ~/.config/dunst/dunstrc
/usr/bin/dunst:
	$(install) dunst

~/.config/dunst/dunstrc: res/bspwm/dunstrc
	mkdir -p ~/.config/dunst
	cp res/bspwm/dunstrc ~/.config/dunst/dunstrc

amixer: /usr/bin/amixer
/usr/bin/amixer:
	$(install) alsa-utils
