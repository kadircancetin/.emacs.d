;; org-roam
(defun kadir/roam-hook()
  (push 'company-org-roam company-backends)

  (setq jit-lock-defer-time nil
        jit-lock-context-time 0.5
        jit-lock-chunk-size 500
        jit-lock-stealth-time nil)
  )

(use-package org-roam
  :straight (:no-native-compile t)
  :init
  (setq org-roam-buffer-width 0.20)
  (setq org-roam-buffer-position 'right)
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  (setq org-roam-directory "~/Dropbox/org-roam")

  :hook
  (org-mode . org-roam-mode)
  (org-mode . kadir/force-roam-side-bar)
  (org-roam-mode . kadir/roam-hook)

  :config

  (defun kadir/roam-sidebar-buffer-p ()
    (and
     org-roam-mode
     (when (buffer-file-name) (s-contains? org-roam-directory (buffer-file-name)))
     (not org-capture-mode)))

  (defun kadir/force-roam-side-bar (&rest n)
    (interactive)
    (when (kadir/roam-sidebar-buffer-p)
      ;; (org-roam-buffer-deactivate)
      (org-roam-buffer-activate)))

  (defun org-roam-protocol-open-file (info)
    (when-let ((file (plist-get info :file)))
      (raise-frame)
      (other-window 2)
      (org-roam--find-file file))
    nil)

  (defun kadir/open-org-roam-server-on-eaf()
    (interactive)
    (require 'org-roam-protocol)
    (org-roam-server-mode 1)
    (kadir/load-eaf)
    (delete-other-windows)
    (kadir/split-and-follow-horizontally)
    (resize-window-height 4)
    (eaf-open-browser "http://localhost:8080")
    (other-window 1)
    (org-roam-buffer-activate))

  (add-hook 'org-roam-backlinks-mode-hook 'kadir/darken-background)
  (add-to-list 'window-buffer-change-functions 'kadir/force-roam-side-bar)

  )

(use-package company-org-roam
  :straight (:no-native-compile t))

(use-package org-roam-server
  :straight (:no-native-compile t))
