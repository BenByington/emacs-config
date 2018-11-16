
;;(add-to-list 'load-path "~/.emacs.d/find-file-in-project")
;;(require 'find-file-in-project)
;;(global-set-key (kbd "C-S-o") 'find-file-in-project-by-selected)
(require 'find-file-in-repository)
(global-set-key (kbd "C-S-o") 'find-file-in-repository)

(require 'treemacs)
(global-set-key (kbd "C-S-t") 'treemacs)
;;(semantic-mode)

(require 'recentf)
(recentf-mode t)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'magit)
(global-set-key (kbd "C-S-<right>") 'magit-ediff-dwim) 
(global-set-key (kbd "C-S-L") 'magit-log-head) 
(global-set-key (kbd "C-S-D")
    (lambda ()(interactive)
        (setq current-prefix-arg '(4)) ; C-u
        (call-interactively 'magit-diff-working-tree)
    )
) 
;;(fset 'magit-log-select-pick-function 'magit-diff-range)
;;(defun my-exp ()(interactive)
;;       (magit-copy-section-value)
;;       (magit-diff-range (magit-pop-revision-stack))
;;)


