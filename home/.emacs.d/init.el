(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

; look
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode)
(load-theme 'desert 'NO-CONFIRM)
(enable-theme 'desert)

; LaTeX
(unless (package-installed-p 'auctex)
  (package-install 'auctex))

; Rust
(unless (package-installed-p 'rust-mode)
 (package-install 'rust-mode))
(require 'rust-mode)
