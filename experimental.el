(require 'use-package)

;; (use-package selectrum)
;; (use-package selectrum-prescient-mode)
;; (use-package prescient)

;; (selectrum-mode +1)
;; (selectrum-prescient-mode +1)
;; (prescient-persist-mode +1)

;; (setq selectrum-num-candidates-displayed 20
;;       selectrum-fix-minibuffer-height t
;;       selectrum-count-style 'current/matches
;;       selectrum-show-indices nil
;;       )
;; (setq projectile-completion-system 'default)


(use-package typo-suggest
  :straight (typo-suggest
             :type git
             :host github
             :repo "kadircancetin/typo-suggest"
             :branch "develop"
             )
  :init
  (require 'typo-suggest)
  (setq typo-suggest-default-search-method 'datamuse))

(global-set-key (kbd "M-ü") 'typo-suggest-helm)


(require 'dash)

(defun kadir/activate-gode-mode-when (orig-fun &rest args)
  (god-local-mode 1))


(use-package god-mode
  :init
  (god-mode-all)
  ;; (setq god-exempt-major-modes nil) ;; enable for all mode but I don't know it is good or bad
  ;; (setq god-exempt-predicates nil)

  ;; enableing god mode
  (global-set-key (kbd "<escape>") #'god-local-mode)
  (global-set-key (kbd "<return>") #'god-local-mode)
  (global-set-key (kbd "ğ") #'god-local-mode)
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  (advice-add 'other-window :before 'kadir/activate-gode-mode-when)

  ;; styling
  ;; (setq modalka-cursor-type '(hbar . 2)) ;; (setq-default cursor-type '(bar . 1))
  (defun my-god-mode-update-cursor ()
    (interactive)
    (message "mka")
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

  ;; some editingtings
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'kadir/split-and-follow-horizontally)
  (global-set-key (kbd "C-x C-3") #'kadir/split-and-follow-vertically)
  (global-set-key (kbd "C-x C-0") #'delete-window)
  (global-set-key (kbd "C-c C-h") #'helpful-at-point)
  (global-set-key (kbd "C-x C-k") (lambda nil (interactive) (kill-buffer (current-buffer))))

  ;; fixes
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)


  (defun kadir/no-ctrl-on-godmode (orig-fun &rest args)
    (if god-local-mode
        (message "YOU ARE IN GOD-MODE IDIOT")
      (apply orig-fun args)))
  (let ((keys "abcçdefgğhıijklmnoöprsştuüvyz")
        (key nil)
        (tmp nil))
    (setq keys (--map (setq key (concat "C-" (char-to-string it))) (mapcar 'identity keys)))
    (dolist (key keys)
      (setq tmp (lookup-key (current-global-map) (kbd key)))
      (when tmp ; (advice-add tmp :around 'kadir/no-ctrl-on-godmode)
        )))

  ;; extra binds
  (define-key god-local-mode-map (kbd "z") #'repeat)
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
  (define-key god-local-mode-map (kbd "C-S-U") #'undo-tree-redo)
  ;; (require 'god-mode-isearch)
  ;; (define-key isearch-mode-map (kbd "<return>") #'god-mode-isearch-activate)
  ;; (define-key god-mode-isearch-map (kbd "<return>") #'god-mode-isearch-disable)


  )

;; (use-package paredit
;;   :init
;;   (add-hook 'emacs-lisp-mode-hook #'paredit-mode))

;;   (remove-hook 'emacs-lisp-mode-hook #'paredit-mode)


(use-package dired-sidebar)



(use-package ivy
  :config
  (ivy-mode t))

(use-package org-web-tools)
(use-package darkroom)



(use-package define-word)
