(if (version< emacs-version "27")
    ;; early-init.el comes from emacs 27. so if your emacs older than,
    ;; we need to load it by regular way
    (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(defvar config-org (expand-file-name "README.org" user-emacs-directory))
(defvar config-el (expand-file-name "README.el" user-emacs-directory))

(defun emacs_start__with_org()
  (require 'org)
  (org-babel-load-file (expand-file-name config-org user-emacs-directory)))

(defun emacs_start__with_tangled() (load-file config-el))

(defvar kadir/helm-extras t
  "There is some minor packages which could be used with helm.")

(add-to-list 'load-path "~/.emacs.d/config/core")
(add-to-list 'load-path "~/.emacs.d/config/binds")
(require 'core)
(require 'binds)


(if (file-exists-p config-el)
    (if (file-newer-than-file-p config-org config-el)
        (emacs_start__with_org)
      (emacs_start__with_tangled))
  (emacs_start__with_org))

(if (file-exists-p (expand-file-name "experimental.el" user-emacs-directory))
    (progn
      (load-file (expand-file-name "experimental.el" user-emacs-directory))
      (message "EXPERIMENTAL EL LOADED")))
