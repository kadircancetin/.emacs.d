(load-file (expand-file-name "config/majors/k_org/functions.el" user-emacs-directory))



(use-package org
  :straight (:type built-in)
  :init
  (kadir/beatiful-org-todo)
  ;; Other package hooks
  (add-hook 'org-mode-hook #'visual-line-mode)
  ;; (add-hook 'org-mode-hook (lambda() (toggle-truncate-lines 1)))
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

  :bind (:map org-mode-map
              ("M-." . org-open-at-point)
              ("M-," . org-mark-ring-goto)
              ("C-a" . mwim-beginning-of-code-or-line)
              ("C-c ," . org-priority-up)
              ;; ("C-c s" . kadir/org-sort-by-priority)
              ;; ("ö p d" . org-priority-down)
              )

  :config

  (setq-default org-src-tab-acts-natively   t               ; intent code blocks with its major modes
                org-src-window-setup        'current-window ; edit code on same window
                org-ellipsis                "  ..."         ;;"  ↴"
                org-src-fontify-natively    t
                org-startup-indented        t
                org-hide-emphasis-markers   t  ;; hide _xx_ or *xx*
                org-pretty-entities         t
                org-default-notes-file      "~/org/inbox.org"
                org-startup-folded          'content
                org-default-priority        ?C
                org-eldoc-breadcrumb-separator " → ")

  (setq-default org-catch-invisible-edits   'show-and-error
                org-cycle-separator-lines   2
                org-link-frame-setup        '((vm . vm-visit-folder-other-frame)
                                              (vm-imap . vm-visit-imap-folder-other-frame)
                                              (gnus . org-gnus-no-new-news)
                                              (file . find-file)   ;; just it changed
                                              (wl . wl-other-frame)))

  (setq org-bullets-bullet-list '("✿" "⁖" "⁖" "." "." "."))

  ;; (setq org-capture-templates
  ;;       '(("t" "Todo" entry (file "~/Dropbox/org-roam/20200503174932-inbox.org" )
  ;;          "* %?\nAdded: \%u\n\%a")
  ;;         ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
  ;;          "* %?\n  Entered on %U\n  %i\n  %a")
  ;;         ("p" "Protocol"
  ;;          entry (file+headline "inbox.org" "Inbox")
  ;;          "* %:description :RESEARCH:\n  #+BEGIN_QUOTE\n    %i\n\n     -- %:link %u\n  #+END_QUOTE\n\n%?")
  ;;         ("L" "Protocol Link"
  ;;          entry (file+headline "inbox.org" "Inbox")
  ;;          "* %? [[%:link][%:description]] \n  Captured On: %u")))
  )

(use-package org-fancy-priorities
  :custom
  (org-fancy-priorities-list '("[!!!]" "[!!]" "[!]"))
  (org-priority-faces '((?A . (:foreground "orangered2" :weight extrabold :height 1.3))  ; org-mode
                        (?B . (:foreground "orange" :weight extrabold :height 1.3))
                        (?C . (:foreground "Burlywood" :weight extrabold :height 1.3))))
  :hook
  (org-mode . org-fancy-priorities-mode))

;; (use-package org-plus-contrib)



(use-package org-bullets)


(use-package org-appear
  :straight (org-appear :type git :host github :repo "awth13/org-appear")
  :init
  (add-hook 'org-mode-hook 'org-appear-mode)
  (setq org-appear-autosubmarkers t
        org-appear-autolinks      t
        org-link-descriptive      t
        )
  )


;; (use-package org-kanban
;;   :init
;;   ;; (add-hook 'before-save-hook 'org-update-all-dblocks)
;;   (defun kadir/start-org-kanban-auto-refresh()
;;     (interactive)
;;     ;; adding to before save hook
;;     (add-hook 'before-save-hook (lambda()
;;                                   (when (derived-mode-p 'org-mode)
;;                                     (org-update-all-dblocks))))

;;     ;; and auto refresh when it is not saved
;;     (run-with-idle-timer
;;      2.5 t
;;      (lambda ()
;;        (when (buffer-modified-p)
;;          (org-update-all-dblocks)))))

;;   (add-hook 'org-mode-hook 'kadir/start-org-kanban-auto-refresh))



;; import-export

;; (use-package org-web-tools)
;; (use-package htmlize)
;; (use-package ox-reveal)
;; (require 'ox-reveal)



(load-file (expand-file-name "config/majors/k_org/roam.el" user-emacs-directory))


(provide 'k_org)
