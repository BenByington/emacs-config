
(setq gc-cons-threshold 50000000)

(require 'ccls)
(setq ccls-executable "/home/UNIXHOME/bbyington/ccls-install/bin/ccls")
(setq ccls-args (list "-v=1" "-log-file=stderr"))

(setq lsp-enable-on-type-formatting nil)
(setq lsp-file-watch-threshold nil)
(dolist (dir '(
                 "[/\\\\]build$"
                 "[/\\\\]depcache$"
                 ))
    (push dir lsp-file-watch-ignored))

(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(setq lsp-ui-doc-delay 1)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(setq arg-replacements '("-G " . ""))
(setq arg-replacements (append '(("-x cu" . "-x cuda")) arg-replacements))

(setq arg-replacements (list (cons "-G " "")
                             (cons "-x cu" "-x cuda")
                             (cons "-isystem=" "-I")
                             (cons "--expt-relaxed-constexpr" "")
                             (cons "--default-stream per-thread" "")
                             (cons "-gencode arch=.*?,code=" "--cuda-gpu-arch=")
                             (cons "--compiler-options=\\\\\\\".*?\\\\\\\"" "\\1")
                       )
)

;; Need to make cmake generate the compile commands json file.  Also nvcc commands
;; need some munging, to sidestep incompatabilities between cuda and nvcc flags
(defun generate-compile-commands-str()
  (setq ret "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; ")
  (dolist (val arg-replacements)
    (message "hello")
    (message (car val) (cdr val))
    (setq ret (concat ret "perl -pi -e 's/" (car val) "/" (cdr val) "/g if /command.*nvcc/ ' compile_commands.json; "))
  )
  (symbol-value 'ret)
)

(setq lsp-log-io t)

(evil-set-initial-state 'ccls-tree-mode 'emacs)

(require 'yasnippet)
(add-hook 'c++-mode-hook 'yas-minor-mode)

(defun dummy-func() (setq dummy t))
(global-unset-key [C-down-mouse-3])
(global-unset-key [C-down-mouse-1])
(global-unset-key [C-mouse-3])
(global-unset-key [C-mouse-1])
;;(define-key c++-mode-map [C-mouse-1] 'lsp-ui-peek-find-definitions)
;;(define-key c++-mode-map [C-mouse-3] 'lsp-ui-peek-find-references)
;;(define-key c++-mode-map [C-down-mouse-1] 'lsp-ui-peek-find-definitions)
;;(define-key c++-mode-map [C-down-mouse-3] 'lsp-ui-peek-find-references)
(define-key lsp-mode-map [C-mouse-1] 'lsp-ui-peek-find-definitions)
(define-key lsp-mode-map [C-mouse-3] 'lsp-ui-peek-find-references)
(define-key lsp-mode-map [C-down-mouse-1] nil)
(define-key lsp-mode-map [C-down-mouse-3] nil)
(define-key c++-mode-map (kbd "<M-left>") nil)
(define-key c++-mode-map (kbd "<M-right>") nil)
(define-key c++-mode-map (kbd "<M-left>") 'lsp-ui-peek-jump-backward)
(define-key c++-mode-map (kbd "<M-right>") 'lsp-ui-peek-jump-forward)
(define-key c++-mode-map (kbd "C-c m") 'ccls-member-hierarchy)
(define-key c++-mode-map (kbd "C-c h") 'ccls-call-hierarchy)
