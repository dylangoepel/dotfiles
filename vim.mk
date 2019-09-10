vim: nvim 

nvim: /usr/bin/nvim ~/.config/nvim/init.vim

/usr/bin/nvim:
	$(install) neovim

~/.config/nvim/init.vim: vim/init.vim ~/.config/nvim/colors/gruvbox.vim
	cp vim/init.vim ~/.config/nvim/init.vim

# the gruvbox color scheme
~/.config/nvim/colors/gruvbox.vim:
	mkdir -p ~/.config/nvim/colors
	mkdir -p ~/.config/nvim/autoload
	git clone https://github.com/morhetz/gruvbox/
	cp -r gruvbox/autoload/* ~/.config/nvim/autoload
	cp -r gruvbox/colors/* ~/.config/nvim/colors
	rm -rf gruvbox
