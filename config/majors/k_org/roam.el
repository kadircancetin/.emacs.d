;; org-roam
(defun kadir/roam-hook()
  (push 'company-org-roam company-backends))

(use-package org-roam
  :straight (:no-native-compile t)
  :commands (org-roam org-roam-mode-map org-roam-find-file)
  :init
  (setq org-roam-buffer-width 0.25)
  (setq org-roam-buffer-no-delete-other-windows t)
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  :hook
  (org-roam-mode . kadir/roam-hook)
  :custom
  (org-roam-directory "~/Dropbox/org-roam/")
  :config
  (require 'org-roam-protocol)
  (org-roam-mode 1))

(use-package company-org-roam
  :straight (:no-native-compile t))

(use-package org-roam-server
  :straight (:no-native-compile t))
