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


(defun get-last-modifed (file)
  ;; source: https://gist.github.com/jmdeldin/4942461
  "Returns the last modified date of a FILE."
  (interactive)
  (format-time-string "%Y-%m-%d %T"
                      (nth 5 (file-attributes file))))

(defun most-recent-p (file1 file2)
  ;; source: https://gist.github.com/jmdeldin/4942461
  "Returns t if FILE1 was modified more recently than FILE2."
  (string< (get-last-modifed file1) (get-last-modifed file2)))


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

(if (most-recent-p  "~/.emacs.d/README.org" "~/.emacs.d/README.el")
    (emacs_start__with_tangled)
  (emacs_start__with_org))
