;; org-roam
(defun kadir/roam-hook()
  (push 'company-org-roam company-backends))

(use-package org-roam
  :straight (:no-native-compile t)
  :init
  (setq org-roam-buffer-width 0.20)
  (setq org-roam-buffer-position 'right)
  (setq org-roam-db-gc-threshold most-positive-fixnum)

  :hook
  (org-mode . org-roam-mode)
  (org-roam-mode . kadir/roam-hook)

  :custom
  (org-roam-directory "~/Dropbox/org-roam/")

  :config
  (require 'org-roam-protocol)
  (add-hook 'org-roam-backlinks-mode-hook 'kadir/darken-background)

  (add-to-list
   'window-buffer-change-functions
   '(lambda (n) (interactive)
      (when (or
             (derived-mode-p 'org-mode)
             (derived-mode-p 'minibuffer-inactive-mode) ;; for helm
             )
        (org-roam-buffer-deactivate)
        (org-roam-buffer-activate)))))

(use-package company-org-roam
  :straight (:no-native-compile t))

(use-package org-roam-server
  :straight (:no-native-compile t))
