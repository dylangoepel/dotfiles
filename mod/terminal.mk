term: st alacritty

st: /usr/local/bin/st
/usr/local/bin/st: res/st/config.h
	cd res/st && sudo make clean && make && sudo make install

alacritty: /usr/bin/alacritty ~/.config/alacritty/alacritty.yml
/usr/bin/alacritty:
	$(install) alacritty

~/.config/alacritty/alacritty.yml: res/alacritty/alacritty.yml
	mkdir -p ~/.config/alacritty
	cp res/alacritty/alacritty.yml $@
