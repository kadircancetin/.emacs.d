(when (version< emacs-version "27")
  ;; early-init.el comes from emacs 27. so if your emacs older than, we need to load it by
  ;; regular way
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(defvar kadir/helm-extras nil
  "There is some packages which could be used with helm but not necassary.")

(let ((default-directory "~/.emacs.d/config"))
  (normal-top-level-add-subdirs-to-load-path))

;; `defaults' configure the defaults settings of the emacs. Like
;; enabling winner-mode. And install and load the `use-pacage'.
(require 'defaults)
(require 'core-extra)
(require 'extras)

(require 'k_html)
(require 'k_python)
(require 'k_js)
(require 'k_org)
(require 'k_dotfiles)
(require 'k_rest)
(require 'k_colors)
(require 'k_elisp)
(require 'k_java)

(require 'k_theme)
(require 'binds)

(when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
  ;;(load-file (expand-file-name "experimental.el" user-emacs-directory))
  (message "EXPERIMENTAL EL LOADED"))
