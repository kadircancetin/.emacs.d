(defvar native-comp-deferred-compilation-deny-list nil)

(let ((default-directory (expand-file-name "config/" user-emacs-directory)))
  (normal-top-level-add-subdirs-to-load-path))

;; If in old-emacs runs early init el. It contains speed-up hacks and UI fixes.
(when (version< emacs-version "27") (load-file (expand-file-name "early-init.el" user-emacs-directory)))


(require 'k-packaging)         ; straight
(require 'k-mini-funcs)        ; raw functions for raw emacs
(require 'k-defaults)          ; emacs confs for raw emacs ( emacs level vars, global-modes, hooks)

(require 'k-helm)
(require 'core-extra)
(require 'k_company)


(when (require 'k-minors)
  (require 'k-colors-mode)
  (require 'k-format)
  (require 'k_theme)
  (require 'k-spell-fu)
  (k-colors-global-mode 1))

;;  ;; languages
(when (require 'k-langs)
  (require 'k-dotfiles)
  (require 'k-restclient)
  (require 'k_html)
  (require 'k_python)
  (require 'k_js)
  (require 'k_elisp)
  ;; (require 'k-scala)
  ;; (require 'k_nim)
  ;; (kadir-scala)
  ;; (require 'k_clang)
  ;; (require 'k-elixir)
  ;; (require 'k-plantuml)
  ;; (require 'k-clojure)
  (require 'k_rust)
  (require 'k-go)
  )

(require 'k-eshell)
(require 'k_org)
(require 'k_dired)
(require 'binds)


;; And lastly, experimental tryings

(when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
  (load-file (expand-file-name "experimental.el" user-emacs-directory)))
