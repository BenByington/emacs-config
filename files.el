
;;(add-to-list 'load-path "~/.emacs.d/find-file-in-project")
;;(require 'find-file-in-project)
;;(global-set-key (kbd "C-S-o") 'find-file-in-project-by-selected)
(require 'find-file-in-repository)
(global-set-key (kbd "C-S-o") 'find-file-in-repository)

(global-set-key (kbd "C-S-t") 'treemacs)

(require 'recentf)
(recentf-mode t)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

