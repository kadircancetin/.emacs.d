(defvar kadir/emacs-fast-open)
(defvar kadir/emacs-open-with-doom)

(setq comp-deferred-compilation nil)

(defun k/init-doom()
  (add-to-list 'load-path "~/.emacs.d_doom")
  (load "~/.emacs.d_doom/early-init.el")
  (load "~/.emacs.d_doom/init.el"))


(defun k/init-def-confs ()
  (when (version< emacs-version "27")
    (load-file (expand-file-name "early-init.el" user-emacs-directory)))

  ;; environmetal varibles
  (setq exec-path (append exec-path '("/home/kadir/go/bin")))

  (add-to-list 'load-path "~/.emacs.d/config/00_def/")
  (require 'def-confs))


(defun k/init-emacs-fo()
  (add-to-list 'load-path "~/.emacs.d/config/01_fo")
  (require 'fo-defs))


(defun k/init-emacs-full ()
  (let ((default-directory "~/.emacs.d/config/"))
    (normal-top-level-add-subdirs-to-load-path))

  (when t
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
      (require 'k-plantuml)
      (require 'k-elixir)
      (require 'k-restclient)
      (require 'k-clojure)
      (require 'k-go)
      (require 'k_html)
      (require 'k_python)
      (require 'k_clang)
      (require 'k_js)
      (require 'k_org)
      (require 'k_elisp)
      (require 'k_dired))

    (require 'binds)     ;; all global bindings

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; (when (file-exists-p "~/dev-org-docs/dev-org-docs.el")
    ;;   (add-to-list 'load-path "~/dev-org-docs/")
    ;;   (require 'dev-org-docs)
    ;;   (require 'dev-org-docs-available-docs)

    ;;   (global-set-key (kbd "C-c DEL") (lambda()(interactive) (dev-org-docs-search-at-point)))

    ;;   (setq dev-org-docs-major-mode-doc-alist
    ;;         '((python-mode . ("django~3.0" "django_rest_framework" "python~3.8"))
    ;;           (html-mode . ("html"))
    ;;           (web-mode . ("html" "css"))
    ;;           (css-mode . ("css"))
    ;;           (org-mode . ("django~3.0" "django_rest_framework" "python~3.8")))))

    (when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
      (load-file (expand-file-name "experimental.el" user-emacs-directory))
      (message "EXPERIMENTAL EL LOADED"))

    (put 'upcase-region 'disabled nil)
    (put 'narrow-to-region 'disabled nil)))


(if kadir/emacs-open-with-doom
    (k/init-doom)

  (progn
    (k/init-def-confs)
    (if kadir/emacs-fast-open
        (k/init-emacs-fo)
      (k/init-emacs-full))))
(put 'downcase-region 'disabled nil)


(defun kadir/mac-conf()
  "switch meta between Option and Command"
  (interactive)

  (use-package exec-path-from-shell)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize)

  (setq mac-option-modifier nil)
  (setq mac-command-modifier 'super)
  (setq ns-option-modifier 'meta
        ns-right-alternate-modifier 'super
        ns-right-option-modifier 'none)
  (setq ns-auto-hide-menu-bar t))


(if (eq system-type 'darwin)
    (kadir/mac-conf))



(global-so-long-mode 1)
