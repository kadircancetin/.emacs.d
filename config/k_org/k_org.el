(load-file (expand-file-name "config/k_org/functions.el" user-emacs-directory))

(use-package htmlize)
(use-package org-bullets)
(use-package org-web-tools)


(use-package org-pomodoro)

(use-package org
  :bind
  (:map org-mode-map
        ("M-." . org-open-at-point)
        ("M-," . org-mark-ring-goto))
  :config
  (define-key org-mode-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
  (setq org-src-tab-acts-natively t) ; intent code blocks with its major modes
  (setq org-src-window-setup 'current-window) ; edit code on same window
  (setq org-ellipsis "  ↴" )
  (setq org-src-fontify-natively t)
  (setq org-startup-indented t)
  ;; (setq org-agenda-files (apply 'append
  ;;                               (mapcar
  ;;                                (lambda (directory)
  ;;                                  (directory-files-recursively
  ;;                                   directory org-agenda-file-regexp))
  ;;                                '("~/Dropbox/org-roam"))))  ;; recursively get org files

  (setq org-agenda-files '(
                           "~/Dropbox/org-roam/20200503174932-inbox.org"
                           "~/Dropbox/org-roam/20200720113959-hipo.org"
                           "~/Dropbox/org-roam/20200427011023-emacs_config.org"
                           "~/Dropbox/org-roam/20200420162944-org_mode.org"
                           "~/Dropbox/org-roam/20200509175158-estheticana.org"

                           ))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Dropbox/org-roam/20200503174932-inbox.org" "Inbox")
           "* TODO %?\n  Added: \%u\n  \%a")
          ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
           "* %?\n  Entered on %U\n  %i\n  %a")
          ("p" "Protocol"
           entry (file+headline "inbox.org" "Inbox")
           "* %:description :RESEARCH:\n  #+BEGIN_QUOTE\n    %i\n\n     -- %:link %u\n  #+END_QUOTE\n\n%?")
          ("L" "Protocol Link"
           entry (file+headline "inbox.org" "Inbox")
           "* %? [[%:link][%:description]] \n  Captured On: %u")
          ))

  (setq org-catch-invisible-edits    'show-and-error
        org-cycle-separator-lines    0
        ;; org-agenda-start-day         "-0d"
        ;; org-agenda-span              20
        ;; org-agenda-start-on-weekday  nil
        org-link-frame-setup         '((vm . vm-visit-folder-other-frame)
                                       (vm-imap . vm-visit-imap-folder-other-frame)
                                       (gnus . org-gnus-no-new-news)
                                       (file . find-file)
                                       (wl . wl-other-frame))))


(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list '("✿" "⁖" "." "." "." "."))


;;; Capture settings
(setq org-default-notes-file  "~/org/inbox.org")


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


(use-package ox-reveal)
;; (require 'ox-reveal)


(use-package deft
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/org-roam/")
  (deft-use-filename-as-title nil))

(load-file (expand-file-name "config/k_org/roam.el" user-emacs-directory))

(provide 'k_org)
