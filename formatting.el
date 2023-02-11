(setq c-basic-offset 4)
;; Not sure which of these two is correct.  I think the latter...
(setq default-indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)
(setq tab-width 8)
(setq tab-stop-list (number-sequence 4 120 4))

(defun cpp-indent-setup() 
    (c-set-offset 'innamespace [0])
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'brace-list-open 0)
    (c-set-offset 'brace-list-intro 4)
)
(add-hook 'c++-mode-hook 'cpp-indent-setup)

(defun my-show-white()
    (setq show-trailing-whitespace t))
(add-hook 'c++-mode-hook 'my-show-white)
(add-hook 'go-mode-hook 'my-show-white)

(require 'ws-butler)
(add-hook 'c++-mode-hook 'ws-butler-mode)
