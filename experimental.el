(require 'use-package)

(use-package typo-suggest
  :defer 0.1
  :init
  (setq typo-suggest-timeout 10))


(use-package god-mode
  :init
  (setq-default cursor-type 'bar)
  (god-mode-all)
  ;; (setq god-exempt-major-modes nil) ;; enable for all mode but I don't know it is good or bad
  ;; (setq god-exempt-predicates nil)

  ;; enableing god mode
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  ;; styling
  ;; (setq modalka-cursor-type '(hbar . 2)) ;; (setq-default cursor-type '(bar . 1))
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

  ;; extra binds
  (define-key god-local-mode-map (kbd "z") #'repeat)
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
  (define-key god-local-mode-map (kbd "C-S-U") #'undo-tree-redo)
  (define-key god-local-mode-map (kbd "/") #'kadir/comment-or-self-insert)
  ;; (require 'god-mode-isearch)
  ;; (define-key isearch-mode-map (kbd "<return>") #'god-mode-isearch-activate)
  ;; (define-key god-mode-isearch-map (kbd "<return>") #'god-mode-isearch-disable)
  )




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

(defun kadir/adjust-font-size(x)
  (set-face-attribute 'default nil :height x)
  (set-face-attribute 'mode-line nil :height x)
  (set-face-attribute 'mode-line-inactive nil :height x)
  (message "YENI SIZE: %d" x))

(defun kadir/font-size-smaller()
  (interactive)
  (defvar kadir/default-font-size)
  (setq kadir/default-font-size (- kadir/default-font-size 10))
  (kadir/adjust-font-size kadir/default-font-size)
  )

(defun kadir/font-size-bigger()
  (interactive)
  (defvar kadir/default-font-size)
  (setq kadir/default-font-size (+ kadir/default-font-size 10))
  (kadir/adjust-font-size kadir/default-font-size))



(use-package company-tabnine
  :defer 20
  :config
  (require 'company-tabnine)

  (defun kadir/company-tabnine-disable()
    (interactive)
    (setq company-backends (remove 'company-tabnine company-backends)))

  (defun kadir/company-tabnine-enable()
    (interactive)
    (add-to-list 'company-backends 'company-tabnine))

  (setq company-tabnine--disable-next-transform nil)
  (defun my-company--transform-candidates (func &rest args)
    (if (not company-tabnine--disable-next-transform)
        (apply func args)
      (setq company-tabnine--disable-next-transform nil)
      (car args)))

  (defun my-company-tabnine (func &rest args)
    (when (eq (car args) 'candidates)
      (setq company-tabnine--disable-next-transform t))
    (apply func args))

  (advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
  (advice-add #'company-tabnine :around #'my-company-tabnine)

  )
