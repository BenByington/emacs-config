(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(setq compilation-scroll-output 'first-error)

(setq ediff-window-setup-function #'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-merge-split-window-function 'split-window-horizontally)

(global-diff-hl-mode t)
