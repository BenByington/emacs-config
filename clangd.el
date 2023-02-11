
(setq gc-cons-threshold 200000000)
(setq read-process-output-max 10000000)

(require 'cc-mode)
(custom-set-variables '(c-noise-macro-names '("constexpr")))
(setq lsp-clients-clangd-executable "/home/UNIXHOME/bbyington/llvm-15/bin/clangd")

(require 'lsp-mode)
(setq lsp-enable-on-type-formatting nil)
(setq lsp-file-watch-threshold nil)
(dolist (dir '(
                 "[/\\\\]build$"
                 "[/\\\\]depcache$"
                 ))
    (push dir lsp-file-watch-ignored))

;;(use-package company-lsp :commands company-lsp)
(setq lsp-ui-doc-delay 1)
(lsp-treemacs-sync-mode 1)
(setq treemacs-wrap-around t)

;; The config to disableheaderline breadcrumbs is maybe in response to a bug?
;; I didn't enable it, and I'm not sure it's supposed to be enabled by default
(use-package lsp-mode
    :hook ((c++-mode . lsp)
           (lsp-mode . lsp-enable-which-key-integration)
           (lsp-mode . lsp-ui-mode))
    :config (setq lsp-headerline-breadcrumb-enable nil)
    :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(setq arg-replacements '("-G " . ""))
(setq arg-replacements (append '(("-x cu" . "-x cuda")) arg-replacements))

(setq arg-replacements (list (cons "-G " "")
                             (cons "-ccbin=gcc" "")
                             (cons "-Xcompiler" "")
                             (cons "-dc" "")
                             (cons "-x cu" "-x cuda --no-cuda-version-check -nocudalib")
                             (cons "-isystem=" "-I")
                             (cons "-t 0" "")
                             (cons "--expt-relaxed-constexpr" "")
                             (cons "--default-stream per-thread" "")
                             (cons "--generate-code=arch=.*?.code=\\[.*?,(.*?)\\]" "--cuda-gpu-arch=$1")
                             (cons "-forward-unknown-to-host-compiler" "")
                             (cons "--compiler-options=\\\\\\\".*?\\\\\\\"" "\\1")
                       )
)

;; Need to make cmake generate the compile commands json file.  Also nvcc commands
;; need some munging, to sidestep incompatabilities between cuda and nvcc flags
(defun generate-compile-commands-str()
  (setq ret "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; ")
  (dolist (val arg-replacements)
    (setq ret (concat ret "perl -pi -e 's/" (car val) "/" (cdr val) "/g if /command.*nvcc/ ' compile_commands.json; "))
  )
  (symbol-value 'ret)
)

(setq lsp-log-io nil)

;;(evil-set-initial-state 'ccls-tree-mode 'emacs)

(require 'yasnippet)
(add-hook 'c++-mode-hook 'yas-minor-mode)

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
(with-eval-after-load 'company
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection))
