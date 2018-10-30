(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path (expand-file-name "~/emacs-config-repo/dependencies/multi-compile"))

(load-file "~/emacs-config-repo/windows.el")
(load-file "~/emacs-config-repo/compile.el")
(load-file "~/emacs-config-repo/rtags.el")
(load-file "~/emacs-config-repo/files.el")
(load-file "~/emacs-config-repo/project.el")
(load-file "~/emacs-config-repo/formatting.el")

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
)
