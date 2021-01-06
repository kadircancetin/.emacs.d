(require 'use-package)


(use-package typo-suggest
  :defer 0.1
  :init
  (setq typo-suggest-timeout 10))


(use-package god-mode
  :init
  (setq-default cursor-type 'bar)
  (god-mode-all)

  ;; enableing god mode
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  ;; styling
  ;; TODO: cursort type for terminal mode will could be good
  (defun my-god-mode-update-cursor ()
    (interactive)
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

  ;; some editingtings
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'kadir/split-and-follow-horizontally)
  (global-set-key (kbd "C-x C-3") #'kadir/split-and-follow-vertically)
  (global-set-key (kbd "C-x C-0") #'kadir/delete-window)
  (global-set-key (kbd "C-c C-h") #'helpful-at-point)
  (global-set-key (kbd "C-x C-k") #'kadir/kill-buffer)

  ;; fixes
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "/") #'kadir/comment-or-self-insert)
  (define-key god-local-mode-map (kbd "d") #'delete-char)
  (define-key god-local-mode-map (kbd "y") #'yank)

  ;; extra binds
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
  (define-key god-local-mode-map (kbd "C-S-U") #'undo-tree-redo)
  (define-key god-local-mode-map (kbd "7") #'kadir/comment-or-self-insert))


(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (add-hook 'mmm-mode-hook
            (lambda ()
              (set-face-background 'mmm-default-submode-face nil))))


(use-package syntactic-close)
(global-set-key (kbd "M-m") 'syntactic-close)


(use-package anki-editor)

(use-package vc-msg)



(defun kadir/load-eaf()
  (if (file-exists-p "/usr/share/emacs/site-lisp/eaf/eaf.el")
      (progn
        (add-to-list 'load-path "/usr/share/emacs/site-lisp/eaf/")
        (require 'eaf))
    (message "eaf is not installed")))



(defun kadir/fast-python()
  (interactive)

  (setq font-lock-maximum-decoration 2)
  (revert-buffer)
  (k-colors-mode 0)
  (flycheck-mode 0)
  (auto-highlight-symbol-mode 1)
  (highlight-symbol-nav-mode 1)
  (setq font-lock-maximum-decoration t))

(defun kadir/normal-python()
  (interactive)
  (setq font-lock-maximum-decoration t)
  (revert-buffer)
  (k-colors-mode 1)
  (flycheck-mode 1))

(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.1
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)

(defun eldoc-mode(&rest args)
  ;; TODO: find who opens the eldoc on python and fix it. Not like that.
  (message "no eldoc"))

;; (defun tooltip-mode(&rest args)
;;   ;; TODO: find who opens the eldoc on python and fix it. Not like that.
;;   (message "no eldoc"))


(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))

;; TODO: (delq 'tooltip-hide pre-command-hook)


(use-package plantuml-mode
  :mode "\\.plantuml\\'"
  :init
  (setq plantuml-java-args (list "-Djava.awt.headless=true" "-jar") ;; somehow related to java-8 I think
        plantuml-jar-path (concat no-littering-etc-directory "plantuml.jar")
        plantuml-default-exec-mode 'jar
        plantuml-indent-level 4))

(use-package gitignore-mode
  :mode "/\\.gitignore\\'")

(use-package explain-pause-mode
  :straight (explain-pause-mode :type git :host github :repo "lastquestion/explain-pause-mode")
  :init
  (setq explain-pause-slow-too-long-ms 40
        explain-pause-top-auto-refresh-interval 1
        explain-pause-profile-slow-threshold 1
        explain-pause-profile-saved-profiles 10))


(global-auto-revert-mode 1)
