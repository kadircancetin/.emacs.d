(setq emacs_start_from nil)             ; if nil from ORG, otherwise file
(setq emacs_start_from 'file)           ; if nil from ORG, otherwise file

;; (use-package benchmark-init
;;   :ensure t
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

(defun emacs_start__with_org()
  (require 'org)
  (org-babel-load-file
   (expand-file-name "README.org"
                     user-emacs-directory)))

(defun emacs_start__with_el()
  (progn
    ;; https://emacs.stackexchange.com/questions/29214/org-based-init-method-slows-down-emacs-startup-dramaticlly-6-minute-startup-h
    (defun my/tangle-dotfiles ()
      "If the current file is this file, the code blocks are tangled"
      (when (equal (buffer-file-name) (expand-file-name "~/.emacs.d/README.org"))
        (org-babel-tangle nil "~/.emacs.d/README.el")
        ;; (byte-compile-file "~/.emacs.d/README.el")
        ))
    (add-hook 'after-save-hook #'my/tangle-dotfiles)
    (load-file "~/.emacs.d/README.el")))

(if (eq emacs_start_from nil)
    (emacs_start__with_org)
  (emacs_start__with_el))
