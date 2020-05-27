(when (version< emacs-version "27")
  ;; early-init.el comes from emacs 27. so if your emacs older than, we need to load it by
  ;; regular way
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(defvar kadir/helm-extras nil
  "There is some packages which could be used with helm but not necassary.")

(let ((default-directory "~/.emacs.d/config"))
  (normal-top-level-add-subdirs-to-load-path))

;; `defaults' configure the defaults settings of the emacs. Like
;; enabling winner-mode. And install and load the `use-package'.
(require 'defaults)

;; appriance and UI 
(require 'k_theme)


;; additinaol core features (like lsp) and extra packages

(require 'core-extra)
(require 'extras)

;; extra big features
(require 'k_treemacs)
(require 'k_company)

;; programing languages and major modes
(require 'k_html)
(require 'k_python)
(require 'k_clang)
(require 'k_js)
(require 'k_org)
(require 'k_dotfiles)
(require 'k_rest)
(require 'k_colors)
(require 'k_elisp)
(require 'k_java)
(require 'k_dired)
(require 'k_eglot_posframe_help)
(eglot-posframe-activate)


;; all global bindings
(require 'binds)

(when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
  (load-file (expand-file-name "experimental.el" user-emacs-directory))
  (message "EXPERIMENTAL EL LOADED"))
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
