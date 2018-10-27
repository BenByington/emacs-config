(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(setq compilation-scroll-output t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)

(require 'evil)
(evil-mode 1)
(evil-select-search-module 'evil-search-module 'evil-search)

(setq ediff-window-setup-function #'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-merge-split-window-function 'split-window-horizontally)

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

(add-to-list 'load-path "~/.emacs.d/find-file-in-project")
(require 'find-file-in-project)
(global-set-key (kbd "C-S-o") 'find-file-in-project-by-selected)

;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

(require 'rtags)
(require 'flycheck-rtags)
(require 'company)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "-c++14")))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "-c++14")))

(define-key c++-mode-map [C-down-mouse-1] 'rtags-find-symbol-at-point)
(define-key c++-mode-map [C-mouse-1] 'rtags-find-symbol-at-point)
(define-key c++-mode-map [C-down-mouse-3] 'rtags-find-references-at-point)
(define-key c++-mode-map [C-mouse-3] 'rtags-find-references-at-point)
(define-key c++-mode-map (kbd "<M-left>") nil)
(define-key c++-mode-map (kbd "<M-right>") nil)
(define-key c++-mode-map (kbd "<M-left>") 'rtags-location-stack-back)
(define-key c++-mode-map (kbd "<M-right>") 'rtags-location-stack-forward)
;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
;;(define-key prelude-mode-map (kbd "C-c r") nil)
;; install standard rtags keybindings. Do M-. on the symbol below to
;; jump to definition and see the keybindings.
(rtags-enable-standard-keybindings)
;; comment this out if you don't have or don't use helm
(setq rtags-use-helm t)
;; company completion setup
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)
(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
;; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'setup-flycheck-rtags)

(global-set-key (kbd "C-S-p") 'multi-compile-run)
(setq multi-compile-alist '(
    (c++-mode . (("ReleaseBuild" "make -j12" build-release-dir)
                 ("DebugBuild" "make -j12" build-debug-dir)
                 ("RunDebug" "make test" build-debug-dir)
                 ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." build-debug-dir))
)))

(require 'recentf)
(recentf-mode t)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(tabbar-mode t)
(winner-mode t)
(global-diff-hl-mode t)
(global-set-key (kbd "C-S-t") 'treemacs)

(electric-pair-mode t)
(setq c-basic-offset 4)
(setq default-indent-tabs-mode nil)
(setq tab-width 8)
(setq tab-stop-list (number-sequence 4 120 4))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (quelpa-use-package company-rtags diff-hl tabbar ibuffer-sidebar treemacs-evil treemacs 4clojure magit evil-magit 0blayout multi-compile flycheck-rtags find-file-in-repository evil dracula-theme counsel company)))
 '(safe-local-variable-values
   (quote
    ((debug-cmd . "make test")
     (build-debug-dir . "~/primary/Sequel/ppa/build/x86_64/Debug_gcc/")
     (build-release-dir . "~/primary/Sequel/ppa/build/x86_64/Release_gcc/")
     (build-debug-dir . "~/primary/Sequel/basecaller/build/x86_64_gcc/Debug/")
     (build-release-dir . "~/primary/Sequel/basecaller/build/x86_64_gcc/Release/")
     (Rdir . "~/primary/Sequel/basecaller/build/x86_64_gcc/Release/")))))
