(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/emacs-config-repo/find-file-in-project")

(load-file "~/emacs-config-repo/windows.el")
(load-file "~/emacs-config-repo/compile.el")
(load-file "~/emacs-config-repo/rtags.el")
(load-file "~/emacs-config-repo/files.el")
(load-file "~/emacs-config-repo/project.el")
(load-file "~/emacs-config-repo/formatting.el")
