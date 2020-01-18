shell: zsh

zsh: /usr/bin/zsh ~/.zshrc /usr/bin/vifm

/usr/bin/vifm:
	$(install) vifm

/usr/bin/zsh:
	$(install) zsh

~/.zshrc: ~/.oh-my-zsh res/zshrc
	cp res/zshrc ~/.zshrc

res/install-zsh.sh:
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o res/install-zsh.sh
	chmod +x res/install-zsh.sh

~/.oh-my-zsh: res/install-zsh.sh
	res/install-zsh.sh --unattended
