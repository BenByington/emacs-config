(add-to-list 'default-frame-alist '(fullscreen . maximized))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)

(require 'evil)
(evil-mode 1)
(evil-select-search-module 'evil-search-module 'evil-search)

(tabbar-mode t)
(winner-mode t)
(electric-pair-mode t)

(require 'ivy)
(ivy-mode 1)
(setq ivy-display-style 'fancy)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(swiper-minibuffer-match-face-1 ((t :background "#dddddd")))
 '(swiper-minibuffer-match-face-2 ((t :background "#bbbbbb" :weight bold)))
 '(swiper-minibuffer-match-face-3 ((t :background "#bbbbff" :weight bold)))
 '(swiper-minibuffer-match-face-4 ((t :background "#ffbbff" :weight bold))))

