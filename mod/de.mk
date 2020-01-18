de: xorg i3 startx nitrogen sddm compton

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
	localectl set-x11-keymap de

/usr/lib/sddm/sddm.conf.d/default.conf: res/xorg/sddm.conf
	sudo cp $< $@

/etc/systemd/system/display-manager.service:
	sudo systemctl enable sddm

compton: /usr/bin/compton
/usr/bin/compton:
	$(install) compton
