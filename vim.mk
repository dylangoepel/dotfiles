vim: /usr/bin/nvim ~/.config/nvim/init.vim

/usr/bin/nvim:
	$(install) neovim

~/.config/nvim/init.vim: vim/init.vim  ~/.local/share/nvim/site/autoload/plug.vim /usr/bin/python3
	sudo pip3 install pynvim
	mkdir -p ~/.config/nvim
	cp vim/init.vim ~/.config/nvim/init.vim

# plug.vim
~/.local/share/nvim/site/autoload/plug.vim: 
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
