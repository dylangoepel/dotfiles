emacs: ~/.emacs.d/init.el /usr/bin/emacs

/usr/bin/emacs:
	$(install) emacs

~/.emacs.d/init.el: res/emacs/init.el
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
