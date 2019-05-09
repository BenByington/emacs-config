
(require 'ccls)
(setq ccls-executable "/home/UNIXHOME/bbyington/ccls-install/bin/ccls")
(setq ccls-args (list "-v=2" "-log-file=stderr"))

(setq lsp-enable-on-type-formatting nil)

(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(setq arg-replacements '("-G " . ""))
(setq arg-replacements (append '(("-x cu" . "-x cuda")) arg-replacements))

(setq arg-replacements (list (cons "-G " "")
                             (cons "-x cu" "-x cuda")
                       )
)

;; Need to make cmake generate the compile commands json file.  Also nvcc commands
;; need some munging, to sidestep incompatabilities between cuda and nvcc flags
(defun generate-compile-commands-str()
  (setq ret "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; ")
  (dolist (val arg-replacements)
    (setq ret (concat ret "sed -i '/command.*nvcc/s/" (car val) "/" (cdr val) "/g' compile_commands.json; "))
  )
  (symbol-value 'ret)
)

(evil-set-initial-state 'ccls-tree-mode 'emacs)

(require 'yasnippet)
(add-hook 'c++-mode-hook 'yas-minor-mode)

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
