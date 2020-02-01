bin: fzf /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med

fzf: /usr/bin/fzf
/usr/bin/fzf:
	$(install) fzf

/bin/%: res/bin/%.sh
	sudo cp $< $@
	sudo chmod +x $@
