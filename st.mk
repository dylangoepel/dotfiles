st: /usr/local/bin/st
/usr/local/bin/st: st/config.def.h
	git clone https://git.suckless.org/st __st
	cp st/config.def.h __st/config.def.h
	cd __st && make && sudo make install
	rm -rf __st
