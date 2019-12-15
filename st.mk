st: /usr/local/bin/st
/usr/local/bin/st: st/config.def.h
	cd st && sudo make clean && make && sudo make install
