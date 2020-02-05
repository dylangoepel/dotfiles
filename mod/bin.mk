bin: /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med /bin/mm fzf

fzf: /usr/bin/fzf
/usr/bin/fzf:
	$(install) fzf

/bin/%: res/bin/%.sh
	sudo cp $< $@
	sudo chmod +x $@

/bin/%: res/bin/%.py
	sudo cp $< $@
	sudo chmod +x $@
