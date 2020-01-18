tmux: /usr/bin/tmux ~/.tmux.conf

/usr/bin/tmux: 
	$(install) tmux

~/.tmux.conf: res/tmux/tmux.conf ~/.pimux.tmux
	cp res/tmux/tmux.conf $@

~/.pimux.tmux: res/tmux/pimux.tmux
	cp res/tmux/pimux.tmux $@
