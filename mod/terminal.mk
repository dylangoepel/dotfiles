st: /usr/local/bin/st
/usr/local/bin/st: res/st/config.def.h
	cd res/st && sudo make clean && make && sudo make install
