;; org-roam
(use-package org-roam
  :straight ( :no-native-compile t :no-byte-compile t) ;; dont know why but native compile breaks the roam.
  :defer nil
  :commands (org-roam org-roam-mode-map org-roam-find-file)
  :init
  (setq org-roam-buffer-width 0.4)
  (setq org-roam-buffer-no-delete-other-windows t)
  :hook
  (org-mode . org-roam-mode)
  (org-roam-mode . kadir/roam-hook)
  :custom
  (org-roam-directory "~/Dropbox/org-roam/")
  :config
  (require 'org-roam-protocol))

(use-package company-org-roam
  :init
  (defun kadir/roam-hook()
    (push 'company-org-roam company-backends))
  )

(use-package org-roam-server
  :straight ( :no-native-compile t :no-byte-compile t))
