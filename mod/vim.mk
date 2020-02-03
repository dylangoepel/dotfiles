pynvim=/usr/lib/python3.7/site-packages/pynvim/__init__.py
python=/usr/bin/python3

vim: /usr/bin/nvim ~/.config/nvim/init.vim

/usr/bin/nvim:
	$(install) neovim

~/.config/nvim/init.vim: res/vim/init.vim  $(python) ~/.local/share/nvim/site/autoload/plug.vim
	mkdir -p ~/.config/nvim
	cp res/vim/init.vim $@

# plug.vim
~/.local/share/nvim/site/autoload/plug.vim: 
	mkdir -p ~/.local/share/nvim/site/autoload
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ycm:
	sudo git clone https://github.com/rust-lang/rust /usr/local/rust/rustc-1.8.0
	cd ~/.vim/bundle/YouCompleteMe; python3 install.py --clang-completer --racer-completer
