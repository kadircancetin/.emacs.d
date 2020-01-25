(if (version< emacs-version "27")
    ;; early-init.el comes from emacs 27. so if your emacs older than,
    ;; we need to load it by regular way
    (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(defvar kadir/helm-extras t
  "There is some minor packages which could be used with helm.")

(add-to-list 'load-path "~/.emacs.d/config/core")
(add-to-list 'load-path "~/.emacs.d/config/core-extra")
(add-to-list 'load-path "~/.emacs.d/config/binds")
(add-to-list 'load-path "~/.emacs.d/config/k_org")
(add-to-list 'load-path "~/.emacs.d/config/k_python")
(add-to-list 'load-path "~/.emacs.d/config/k_html")
(add-to-list 'load-path "~/.emacs.d/config/k_js")
(add-to-list 'load-path "~/.emacs.d/config/k_dotfiles")
(add-to-list 'load-path "~/.emacs.d/config/k_rest")
(add-to-list 'load-path "~/.emacs.d/config/k_theme")
(add-to-list 'load-path "~/.emacs.d/config/k_colors")


(require 'core)
(require 'core-extra)
(require 'binds)
(require 'k_html)
(require 'k_python)
(require 'k_js)
(require 'k_org)
(require 'k_dotfiles)
(require 'k_rest)
(require 'k_theme)
(require 'k_colors)

(if (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
    (progn
      ;;(load-file (expand-file-name "experimental.el" user-emacs-directory))
      (message "EXPERIMENTAL EL LOADED")))
