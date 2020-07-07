;; org-roam
(use-package org-roam
  :commands (org-roam org-roam-mode-map org-roam-find-file)
  :defer 1.1
  :init
  (setq org-roam-buffer-width 0.4)
  (setq org-roam-buffer-no-delete-other-windows t)

  (eval-after-load 'org-roam
    '(defun org-roam--find-file (file)
       "override method because sometimes find-file can't get the true window"
       (other-window 1)
       (message "kadir")
       (find-file file))
    )

  :hook 
  (org-mode . org-roam-mode)
  :custom
  (org-roam-directory "~/Dropbox/org-roam/")
  :config
  (require 'org-roam-protocol))

;; company org-roam
;; (let ((default-directory "~/.emacs.d/gits/"))
;;   (normal-top-level-add-subdirs-to-load-path))
;; (require 'company-org-roam)
;; (push 'casfmpany-org-roam company-backends)

(use-package org-roam-server
  :ensure t)
