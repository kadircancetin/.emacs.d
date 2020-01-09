;; (use-package benchmark-init
;;   :ensure t
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar config-org (expand-file-name "README.org" user-emacs-directory))
(defvar config-el (expand-file-name "README.el" user-emacs-directory))

(defun emacs_start__with_org()
  (require 'org)
  (org-babel-load-file (expand-file-name config-org user-emacs-directory)))

(defun emacs_start__with_tangled() (load-file config-el))


(if (file-exists-p config-el)
    (if (file-newer-than-file-p config-org config-el)
        (emacs_start__with_org)
      (emacs_start__with_tangled))
  (emacs_start__with_org))
