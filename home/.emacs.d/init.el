(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'evil)
 (package-install 'evil))
(unless (package-installed-p 'color-theme-modern)
 (package-install 'color-theme-modern))
(unless (package-installed-p 'auctex)
 (package-install 'auctex))
(unless (package-installed-p 'key-chord)
 (package-install 'key-chord))

(require 'evil)
(evil-mode 1)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq TeX-auto-save t)
(setq TeX-parse-self t)

(require 'color-theme-modern)

(require 'key-chord)

(setq previewing nil)
(defun preview-toggle nil
  (if previewing
      (progn
	(preview-buffer)
	(setq previewing t))
      (progn
        (preview-clearout-buffer)
	(setq previewing nil))))

(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (desert)))
 '(custom-safe-themes
   (quote
    ("57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "09feeb867d1ca5c1a33050d857ad6a5d62ad888f4b9136ec42002d6cdf310235" "9dc64d345811d74b5cd0dac92e5717e1016573417b23811b2c37bb985da41da2" "a455366c5cdacebd8adaa99d50e37430b0170326e7640a688e9d9ad406e2edfd" "b4fd44f653c69fb95d3f34f071b223ae705bb691fb9abaf2ffca3351e92aa374" default)))
 '(initial-buffer-choice "~/.emacs")
 '(package-selected-packages (quote (key-chord auctex evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
