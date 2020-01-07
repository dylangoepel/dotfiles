bin: /usr/bin/volume

/usr/bin/volume: bin/volume.sh
	sudo cp bin/volume.sh /usr/bin/volume
	sudo chmod +x /usr/bin/volume
