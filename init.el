(when (version< emacs-version "27")
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(setq comp-deferred-compilation nil)

(defvar kadir/emacs-fast-open)
(defvar kadir/emacs-open-with-doom)



(defun k/init-emacs-full ()

  (let ((default-directory "~/.emacs.d/config/"))
    (normal-top-level-add-subdirs-to-load-path))

  (require 'def-confs)
  (require 'k-packaging)
  (require 'k-helm)
  (require 'core-extra)
  (require 'k_company)
  (require 'k-eshell)

  (when (require 'k-minors)
    (require 'k-colors-mode)
    (require 'k-format)
    (require 'k_theme)
    (k-colors-global-mode 1))

  ;; languages
  (when (require 'k-langs)
    (require 'k-dotfiles)
    (require 'k-restclient)
    (require 'k_html)
    (require 'k_python)
    (require 'k_js)
    (require 'k_elisp)
    (require 'k-scala)
    ;; (kadir-scala)
    ;; (require 'k_clang)
    ;; (require 'k-elixir)
    ;; (require 'k-plantuml)
    ;; (require 'k-clojure)
    ;; (require 'k-go)
    )


  (require 'k_org)
  (require 'k_dired)

  ;; majors

  (require 'binds)     ;; all global bindings

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
    (load-file (expand-file-name "experimental.el" user-emacs-directory)))
  )


(k/init-emacs-full)


(setq exec-path (append exec-path '("/home/kadir/go/bin")))

(defun kadir/mac-conf()
  "switch meta between Option and Command"
  (interactive)
  (use-package exec-path-from-shell :init (exec-path-from-shell-initialize))
  (setq mac-option-modifier nil)
  (setq mac-command-modifier 'super)
  (setq ns-option-modifier 'meta
        ns-right-alternate-modifier 'super
        ns-right-option-modifier 'none)
  (setq ns-auto-hide-menu-bar t))

(if (eq system-type 'darwin)
    (kadir/mac-conf))



(use-package org :straight (:type built-in))
