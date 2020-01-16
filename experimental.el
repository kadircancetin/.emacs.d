(use-package org-web-tools)

;;;;;
;; Isearch things
;;;;;
(defun kadir/hide-fold-defs ()
  "Folds the all functions in python"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (hs-hide-level 2)))

(setq hs-isearch-open t)
;; (setq hs-allow-nesting t)
(global-set-key (kbd "M-t") #'hs-toggle-hiding)
(global-set-key (kbd "C-c M-t") #'kadir/hide-fold-defs)

;;;;;;;;
;; last buffers
;;;;;;;
(defun kadir/last-buffer ()
  "get last buffer which is not windowed"
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) nil)))

(global-set-key (kbd "M-<SPC>") #'kadir/last-buffer )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree macs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package treemacs
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-indentation                   1
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'right
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-hidden-files             t
          treemacs-sorting                       'alphabetic-asc
          treemacs-width                         25)

    (treemacs-resize-icons 14)
    (treemacs-follow-mode -1)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs))

  ;; (add-hook 'treemacs-mode-hook (lambda ()
  ;;                                 (setq buffer-face-mode-face `(:background "#211C1C"))
  ;;                                 (buffer-face-mode 1)))

  )

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit)
