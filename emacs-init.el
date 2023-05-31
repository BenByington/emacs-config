(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path (expand-file-name "~/emacs-config/dependencies/multi-compile"))

(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(load-file "~/emacs-config/util.el")
(load-file "~/emacs-config/windows.el")
(load-file "~/emacs-config/compile.el")
(load-file "~/emacs-config/clangd.el")
;;(load-file "~/emacs-config/ccls.el")
;;(load-file "~/emacs-config/rtags.el")
(load-file "~/emacs-config/files.el")
(load-file "~/emacs-config/project.el")
(load-file "~/emacs-config/formatting.el")

(setq create-lockfiles nil)

(setq backup-directory-alist '((".*" . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
)

;; Put this elsewhere?
(setq latex-run-command "pdflatex")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command '("pandoc" "--standalone" "-c /home/UNIXHOME/bbyington/emacs-config/styling.css")))


(use-package markdown-xwidget
  :after markdown-mode
  :straight (markdown-xwidget
             :type git
             :host github
             :repo "cfclrk/markdown-xwidget"
             :files (:defaults "resources"))
  :bind (:map markdown-mode-command-map
              ("x" . markdown-xwidget-preview-mode))
  :custom
  (markdown-xwidget-command "pandoc")
  (markdown-xwidget-github-theme "dark")
  (markdown-xwidget-mermaid-theme "default")
  (markdown-xwidget-code-block-theme "dark"))

(auto-save-visited-mode)
;; This would be nice to stop having save files in with the source, but
;; the current version doesn't work (tries to add files to directories
;; that don't exist)
;;(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/saves/" t)))

;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

(require 'go-mode)
(define-key go-mode-map (kbd "<M-left>") nil)
(define-key go-mode-map (kbd "<M-right>") nil)
(define-key go-mode-map (kbd "<M-left>") 'lsp-ui-peek-jump-backward)
(define-key go-mode-map (kbd "<M-right>") 'lsp-ui-peek-jump-forward)
