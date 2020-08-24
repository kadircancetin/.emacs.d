(defvar kadir/emacs-fast-open)
(defvar kadir/emacs-open-with-doom)


(defun k/init-doom()
  (add-to-list 'load-path "~/.emacs.d_doom")
  (load "~/.emacs.d_doom/early-init.el")
  (load "~/.emacs.d_doom/init.el"))


(defun k/init-def-confs ()
  (when (version< emacs-version "27")
    (load-file (expand-file-name "early-init.el" user-emacs-directory)))

  (add-to-list 'load-path "~/.emacs.d/config/def-confs")
  (require 'def-confs))


(defun k/init-emacs-fo()
  (add-to-list 'load-path "~/.emacs.d/config/fo-defs")
  (require 'fo-defs))

(defun k/init-emacs-full ()
  (let ((default-directory "~/.emacs.d/config/"))
    (normal-top-level-add-subdirs-to-load-path))

  (require 'k-packaging)
  (require 'extra-majors)
  (require 'core-extra)     ;; TODO

  (require 'k-colors-mode)  ;; NOTE: eğer bi satır üstte olursa eglot patlıyor. neden
  (require 'k-format)

  (require 'k_theme)
  (require 'extras)

  ;; extra big features
  (require 'k_company)

  ;; programing languages and major modes
  (require 'k-clojure)
  (require 'k_html)
  (require 'k_python)
  (require 'k_clang)
  (require 'k_js)
  (require 'k_org)

  (require 'k_elisp)

  ;; (require 'k_java)
  (require 'k_dired)
  ;; (require 'k_eglot_posframe_help)
  ;; (eglot-posframe-activate)

  ;; all global bindings
  (require 'binds)

  (load-file "~/dev-org-docs/dev-org-docs.el")
  (setq dev-org-docs-mode-docs
        '((python-mode . (django~3.0 django_rest_framework python~3.7))
          (clojure-mode . (clojure~1.10))
          ))

  (when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
    (load-file (expand-file-name "experimental.el" user-emacs-directory))
    (message "EXPERIMENTAL EL LOADED"))

  (put 'narrow-to-region 'disabled nil))


(if kadir/emacs-open-with-doom
    (k/init-doom)

  (progn
    (k/init-def-confs)
    (if kadir/emacs-fast-open
        (k/init-emacs-fo)
      (k/init-emacs-full))))
