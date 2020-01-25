(use-package org
  :bind
  (:map org-mode-map
        ("M-." . elisp-slime-nav-find-elisp-thing-at-point))
  :config
  (define-key org-mode-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
  (setq org-src-tab-acts-natively t) ; intent code blocks with its major modes
  (setq org-src-window-setup 'current-window) ; edit code on same window
  (setq org-src-fontify-natively t)

  (setq org-agenda-files (apply 'append
                                (mapcar
                                 (lambda (directory)
                                   (directory-files-recursively
                                    directory org-agenda-file-regexp))
                                 '("~/org"))))  ;; recursively get org files


  (setq org-catch-invisible-edits    'show-and-error
        org-cycle-separator-lines    0
        org-agenda-start-day         "-0d"
        org-agenda-span              20
        org-agenda-start-on-weekday  nil
        org-link-frame-setup         '((vm . vm-visit-folder-other-frame)
                                       (vm-imap . vm-visit-imap-folder-other-frame)
                                       (gnus . org-gnus-no-new-news)
                                       (file . find-file)
                                       (wl . wl-other-frame)))

  (defun kadir/org-indent-activate-but-config ()
    "org-indent-mode activated if the current buffer is not README.org"
    (unless (equal (buffer-file-name) config-org)
      (org-indent-mode 1)))
  (add-hook 'org-mode-hook #'kadir/org-indent-activate-but-config))

(use-package htmlize)
(use-package org-bullets)

(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list '("⁖" "⁖" "." "."))


(use-package stripe-buffer
  :config
  (set-face-attribute 'stripe-highlight nil :background "#333335")

  :hook ((org-mode . turn-on-stripe-table-mode)
         (dired-mode-hook stripe-listify-buffer)))

(use-package org-web-tools
  :defer t)


(provide 'k_org)
