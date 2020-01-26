(use-package htmlize)
(use-package org-bullets)
(use-package org-web-tools)


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
                                       (wl . wl-other-frame))))


(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list '("⁖" "⁖" "." "."))



;; beautifying
(add-hook 'org-mode-hook (lambda ()
                           "Beautify Org Checkbox Symbol"
                           (push '("[ ]" .  "☐") prettify-symbols-alist)
                           (push '("[X]" . "☑" ) prettify-symbols-alist)
                           (push '("[-]" . "❍" ) prettify-symbols-alist)
                           (prettify-symbols-mode)))

(defface org-checkbox-done-text
  '((t (:foreground "#71696A" :strike-through t)))
  "Face for the text part of a checked org-mode checkbox.")

(font-lock-add-keywords
 'org-mode
 `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
    1 'org-checkbox-done-text prepend))
 'append)

(provide 'k_org)
