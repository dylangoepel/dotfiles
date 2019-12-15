pynvim=/usr/lib/python3.7/site-packages/pynvim/__init__.py
python=/usr/bin/python3

vim: /usr/bin/vim ~/.vimrc

/usr/bin/vim:
	$(install) gvim

~/.vimrc: vim/init.vim  ~/.vim/autoload/plug.vim $(python)
	cp vim/init.vim $@

# plug.vim
~/.vim/autoload/plug.vim: 
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
