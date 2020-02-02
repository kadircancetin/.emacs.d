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


(provide 'k_treemacs)
