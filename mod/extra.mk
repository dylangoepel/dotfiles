extra: ytdl aria2 hack-ttf mpv qutebrowser

ytdl: /usr/bin/youtube-dl
/usr/bin/youtube-dl:
	$(install) youtube-dl

aria2: /usr/bin/aria2c
/usr/bin/aria2c:
	$(install) aria2

firefox: /usr/bin/firefox
/usr/bin/firefox:
	$(install) firefox

qutebrowser: /usr/bin/qutebrowser
/usr/bin/qutebrowser:
	$(install) qutebrowser

hack-ttf: /usr/share/fonts/TTF/Hack-Regular.ttf
/usr/share/fonts/TTF/Hack-Regular.ttf:
	$(install) ttf-hack

mpv: /usr/bin/mpv
/usr/bin/mpv:
	$(install) mpv
