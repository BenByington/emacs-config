
(require 'ccls)
(setq ccls-executable "/home/UNIXHOME/bbyington/ccls-install/bin/ccls")
(setq ccls-args (list "-v=2" "-log-file=stderr"))

(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(evil-set-initial-state 'ccls-tree-mode 'emacs)

(defun dummy-func() (setq dummy t))
(global-unset-key [C-down-mouse-3])
(global-unset-key [C-down-mouse-1])
(define-key c++-mode-map [C-mouse-1] 'lsp-ui-peek-find-definitions)
(define-key c++-mode-map [C-mouse-3] 'lsp-ui-peek-find-references)
(define-key c++-mode-map (kbd "<M-left>") nil)
(define-key c++-mode-map (kbd "<M-right>") nil)
(define-key c++-mode-map (kbd "<M-left>") 'lsp-ui-peek-jump-backward)
(define-key c++-mode-map (kbd "<M-right>") 'lsp-ui-peek-jump-forward)
(define-key c++-mode-map (kbd "C-c m") 'ccls-member-hierarchy)
(define-key c++-mode-map (kbd "C-c h") 'ccls-call-hierarchy)
