bin: /usr/bin/volume /usr/bin/productivity /bin/vim /usr/bin/dl

/usr/bin/volume: res/bin/volume.sh
	sudo cp res/bin/volume.sh /usr/bin/volume
	sudo chmod +x /usr/bin/volume

/usr/bin/productivity: res/bin/productivity.sh
	sudo cp res/bin/productivity.sh /usr/bin/productivity
	sudo chmod +x /usr/bin/productivity

/bin/vim: res/bin/vim
	sudo cp res/bin/vim /bin/vim
	sudo chmod +x /bin/vim

/usr/bin/dl: res/bin/dl 
	sudo cp res/bin/dl /usr/bin/dl
	sudo chmod +x /usr/bin/dl
