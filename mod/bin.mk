<<<<<<< HEAD
bin: /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med /bin/mm
=======
bin: fzf /bin/volume /bin/productivity /bin/vim /bin/dl /bin/bib /bin/med

fzf: /usr/bin/fzf
/usr/bin/fzf:
	$(install) fzf
>>>>>>> c2738160e1062831b60a93fe40f92d070592a757

/bin/%: res/bin/%.sh
	sudo cp $< $@
	sudo chmod +x $@

/bin/%: res/bin/%.py
	sudo cp $< $@
	sudo chmod +x $@
