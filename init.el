;; (use-package auto-package-update
;;   :config
;;   ;; Delete residual old versions
;;   (setq auto-package-update-delete-old-versions t)
;;   ;; Do not bother me when updates have taken place.
;;   (setq auto-package-update-hide-results t)
;;   ;; Update installed packages at startup if there is an update pending.
;;   (auto-package-update-maybe))

;; (use-package benchmark-init
;;   :ensure t
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))


(defun emacs_start__with_org()
  (require 'org)
  (org-babel-load-file
   (expand-file-name "README.org"
                     user-emacs-directory)))

(defun emacs_start__with_tangled()
  (progn
    ;; (defun my/tangle-dotfiles ()
    ;;   ;; source: https://emacs.stackexchange.com/questions/29214/org-based-init-method-slows-down-emacs-startup-dramaticlly-6-minute-startup-h
    ;;   "If the current file is this file, the code blocks are tangled"
    ;;   (when (equal (buffer-file-name) (expand-file-name "~/.emacs.d/README.org"))
    ;;     (org-babel-tangle nil "~/.emacs.d/README.el")
    ;;     ;; (byte-compile-file "~/.emacs.d/README.el")
    ;;     ))
    ;; (add-hook 'after-save-hook #'my/tangle-dotfiles)
    (load-file "~/.emacs.d/README.el")
    ))


(if (file-newer-than-file-p "~/.emacs.d/README.org" "~/.emacs.d/README.el")
    (emacs_start__with_org)
  (emacs_start__with_tangled))
