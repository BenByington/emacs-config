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

