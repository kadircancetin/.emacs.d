(use-package ob-restclient
  ;; link: https://github.com/alf/ob-restclient.el
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  '((restclient . t)))
  )


(use-package aweshell
  :defer 1
  :load-path "~/.emacs.d/site-lisp/aweshell"
  :init
  (require 'aweshell))

(use-package eaf
  :defer 1
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
  :init
  (require 'eaf)
  (setq eaf-var-list
        '((eaf-camera-save-path          . "~/Downloads")
          (eaf-browser-enable-plugin     . "true")
          (eaf-browser-enable-javascript . "true")
          (eaf-browser-remember-history  . "true")
          (eaf-browser-default-zoom      . "0.8")
          (eaf-browser-blank-page-url    . "https://www.google.com")
          ))
  :config
  (defun eaf_open_current_buffer ()
    (interactive)
    (eaf-open (buffer-file-name))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package dired-subtree
  :after dired
  :defer nil
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

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
