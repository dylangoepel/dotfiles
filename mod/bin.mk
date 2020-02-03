bin: /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med /bin/mm

/bin/%: res/bin/%.sh
	sudo cp $< $@
	sudo chmod +x $@

/bin/%: res/bin/%.py
	sudo cp $< $@
	sudo chmod +x $@
