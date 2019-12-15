zsh: /usr/bin/zsh ~/.zshrc
/usr/bin/zsh:
	$(install) zsh

~/.zshrc: ~/.oh-my-zsh zshrc
	cp zshrc ~/.zshrc

~/.oh-my-zsh: install.sh
	bash install.sh
	$(install) zsh-theme-powerlevel9k
