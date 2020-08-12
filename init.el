(when (version< emacs-version "27")
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))


(defvar kadir/emacs-fast-open) ;; gets from early-init.el


(add-to-list 'load-path "~/.emacs.d/config/def-confs")
(require 'def-confs)


(when kadir/emacs-fast-open
  (add-to-list 'load-path "~/.emacs.d/config/fo-defs")
  (require 'fo-defs))


(when (not kadir/emacs-fast-open)
  (let ((default-directory "~/.emacs.d/config/"))
    (normal-top-level-add-subdirs-to-load-path))

  (require 'k-packaging)

  ;; appriance and UI
  (require 'k_theme)

  ;; additinaol core features (like lsp) and extra packages
  (require 'core-extra)
  (require 'extras)

  ;; extra big features
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

  ;; (require 'k_java)
  (require 'k_dired)
  ;; (require 'k_eglot_posframe_help)
  ;; (eglot-posframe-activate)


  ;; all global bindings
  (require 'binds)

  (load-file "~/dev-org-docs/dev-org-docs.el")

  (when (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
    (load-file (expand-file-name "experimental.el" user-emacs-directory))
    (message "EXPERIMENTAL EL LOADED"))

  ;; run garbage collectin by hand when
  ;; 1) every focus out of the emacs run
  ;; 2) every 10 minutes wait the 1 second idle time and run
  (add-hook 'after-focus-out-hook (lambda() (garbage-collect)))
  (run-with-timer nil (* 10 60) (lambda () (run-with-idle-timer 1 nil 'garbage-collect)))


  (put 'narrow-to-region 'disabled nil)
  (put 'upcase-region 'disabled nil))
