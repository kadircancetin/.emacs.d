;; org-roam
(defun kadir/roam-hook()
  (push 'company-org-roam company-backends))

(use-package org-roam
  :straight (:no-native-compile t)
  :init
  (setq org-roam-buffer-width 0.20)
  (setq org-roam-buffer-position 'right)
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  (setq org-roam-directory "~/Dropbox/org-roam/")

  :hook
  (org-mode . org-roam-mode)
  (org-roam-mode . kadir/roam-hook)

  :config
  (org-roam-buffer-activate)

  (add-hook 'org-roam-backlinks-mode-hook 'kadir/darken-background)

  (add-to-list
   'window-buffer-change-functions
   '(lambda (n) (interactive)
      (when (and
             org-roam-mode
             (or (derived-mode-p 'minibuffer-inactive-mode) ;; for helm
                 (derived-mode-p 'org-mode))
             (not org-capture-mode))
        (org-roam-buffer-deactivate)
        (org-roam-buffer-activate))))

  (defun org-roam-protocol-open-file (info)
    (when-let ((file (plist-get info :file)))
      (message "other xD")
      (raise-frame)
      (other-window 2)
      (org-roam--find-file file))
    nil)

  (require 'org-roam-protocol)
  (defun kadir/open-org-roam-server-on-eaf()
    (interactive)
    (org-roam-server-mode 1)
    (kadir/load-eaf)
    (delete-other-windows)
    (kadir/split-and-follow-horizontally)
    (resize-window-height 4)
    (eaf-open-browser "http://localhost:8080")
    (other-window 1)
    (org-roam-buffer-activate)
    ))

(use-package company-org-roam
  :straight (:no-native-compile t))

(use-package org-roam-server
  :straight (:no-native-compile t))
