(when (version< emacs-version "27")
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))


(let ((default-directory "~/.emacs.d/config/"))
  (normal-top-level-add-subdirs-to-load-path))

(defvar kadir/emacs-fast-open (member "-fo" command-line-args))
(setq command-line-args (delete "-fo" command-line-args))


(require 'def-confs)



(when (not kadir/emacs-fast-open)
  (run-with-idle-timer 1 nil (lambda () (async-bytecomp-package-mode 1)))

  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  (setq straight-check-for-modifications '(watch-files find-when-checking))
  (straight-use-package 'use-package)
  (setq straight-use-package-by-default t)

  
  (setq use-package-always-defer t
        use-package-expand-minimally t)
  
  (use-package no-littering)
  (require 'no-littering)

  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (if (file-exists-p custom-file)
      (load-file custom-file))
  (add-to-list 'yas-snippet-dirs
               (expand-file-name "snippets" user-emacs-directory))
  




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
  (require 'k_eglot_posframe_help)
  (eglot-posframe-activate)


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
  (put 'upcase-region 'disabled nil)
  )
