tmux: /usr/bin/tmux ~/.tmux.conf

/usr/bin/tmux: 
	$(install) tmux

~/.tmux.conf: tmux/tmux.conf ~/.pimux.tmux
	cp tmux/tmux.conf $@

~/.pimux.tmux: tmux/pimux.tmux
	cp tmux/pimux.tmux $@
