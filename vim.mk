pynvim=/usr/lib/python3.7/site-packages/pynvim/__init__.py
python=/usr/bin/python3

kakoune: /usr/bin/kak ~/.config/kak/kakrc
vim: /usr/bin/vim ~/.vimrc

/usr/bin/vim:
	$(install) gvim

~/.vimrc: vim/init.vim  $(python) ~/.vim/bundle/Vundle.vim/autoload/vundle.vim
	cp vim/init.vim $@

# plug.vim
~/.vim/bundle/Vundle.vim/autoload/vundle.vim: 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ycm:
	sudo git clone https://github.com/rust-lang/rust /usr/local/rust/rustc-1.8.0
	cd ~/.vim/bundle/YouCompleteMe; python3 install.py --clang-completer --racer-completer

/usr/bin/kak:
	$(install) kakoune

~/.config/kak/kakrc: kakrc
	mkdir -p ~/.config/kak
	cp kakrc $@
