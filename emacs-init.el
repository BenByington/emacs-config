(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path (expand-file-name "~/emacs-config/dependencies/multi-compile"))

(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))

(load-file "~/emacs-config/util.el")
(load-file "~/emacs-config/windows.el")
(load-file "~/emacs-config/compile.el")
(load-file "~/emacs-config/ccls.el")
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
(auto-save-visited-mode)
;; This would be nice to stop having save files in with the source, but
;; the current version doesn't work (tries to add files to directories
;; that don't exist)
;;(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/saves/" t)))

