bin: /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med

/bin/%: res/bin/%.sh
	sudo cp $< $@
	sudo chmod +x $@
