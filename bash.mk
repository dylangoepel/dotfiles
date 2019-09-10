bash: /bin/bash ~/.bashrc
/bin/bash:
	$(install) bash

~/.bashrc: bashrc
	cp bashrc ~/.bashrc
