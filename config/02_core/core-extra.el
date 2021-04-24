(require 'use-package)

(use-package darkroom) ;; NOTE: do I realy need it
(use-package deadgrep)
(use-package multiple-cursors)
(use-package mwim)
(use-package goto-chg)
(use-package projectile)
(use-package ace-window)
(use-package su :init (su-mode 1))
(use-package ivy)

(use-package undo-tree
  :defer nil
  :config
  (global-undo-tree-mode))

(use-package expand-region
  :custom
  (expand-region-fast-keys-enabled   nil)
  (expand-region-subword-enabled     t))

(use-package shackle
  :defer nil
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("\\`\\*helpful.*?\\*\\'" :regexp t :align t :size 0.4)
          (help-mode :align t :size 0.4 :select t))))

(use-package wrap-region
  :defer nil
  :commands (wrap-region-add-wrapper)
  :config
  (wrap-region-add-wrapper "<>" "</>" "#" 'rjsx-mode)
  (wrap-region-add-wrapper "#+begin_src emacs-lisp\n  " "\n#+end_src" "*" 'org-mode)
  (wrap-region-add-wrapper "{% trans \"" "\"  %}" "*" 'web-mode)
  (wrap-region-add-wrapper "<p>" "</p>" "!" 'web-mode)
  (wrap-region-add-wrapper "=" "=" "=" 'org-mode))

(use-package yasnippet
  :custom
  (yas-indent-line nil)
  (yas-inhibit-overlay-modification-protection t)
  :bind*
  (;; ("C-j" . yas-expand)
   :map yas-minor-mode-map
   ("TAB" . nil)
   ("<tab>" . nil)
   :map yas-keymap
   ("TAB" . (lambda () (interactive) (company-abort) (yas-next-field)))
   ("<tab>" . (lambda () (interactive) (company-abort) (yas-next-field))))
  :config
  (yas-global-mode 1)
  (use-package yasnippet-snippets)
  ;; (require 'helm)
  ;; (use-package yasnippet-snippets)
  ;; (setq yas-keymap nil
  ;;       yas-minor-mode-map nil)
  ;; (defadvice yas-insert-snippet (before yas-activate activate)
  ;;   (yas-minor-mode 1))
  ;; (add-to-list 'helm-quit-hook
  ;;              (lambda()
  ;;                (remove-hook 'post-command-hook #'yas--post-command-handler t)
  ;;                (remove-hook 'auto-fill-mode-hook #'yas--auto-fill-wrapper)))
  )


(use-package magit
  :config
  (use-package magit-todos :hook (magit-mode . magit-todos-mode))
  (add-to-list 'git-commit-setup-hook 'git-commit-turn-on-flyspell)
  (add-hook 'magit-diff-mode-hook (lambda () (flyspell-mode 1)) 100))

(use-package forge
  :after magit
  :custom
  (forge-create-pullreq-prefix "STAGING -")
  :config
  (defadvice magit-pull-from-upstream (after forge-pull activate)
    (forge-pull))
  (defadvice magit-fetch-all (after forge-pull activate)
    (forge-pull)))


(use-package git-link)
(use-package vc-msg)



(use-package posframe)
(use-package screenshot.el
  :straight (screenshot.el :type git :host github :repo "tecosaur/screenshot")
  :commands (screenshot))



(use-package wakatime-mode
  :if (executable-find "wakatime")
  :defer 5
  :config
  (message "waka activated"))

(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr"))



(use-package god-mode
  :init
  (setq-default cursor-type 'bar)
  (god-mode-all)

  ;; enabling god mode
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  ;; styling
  ;; TODD: cursor type for terminal mode will could be good
  (defun my-god-mode-update-cursor ()
    (interactive)
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

  ;; some editing
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



;; (use-package typo-suggest
;;   :defer 4
;;   :init
;;   (setq typo-suggest-timeout 10))




(use-package winum
  :bind*
  ("s-1" . winum-select-window-1)
  ("s-2" . winum-select-window-2)
  ("s-3" . winum-select-window-3)
  ("s-4" . winum-select-window-4)
  ("s-5" . winum-select-window-5)
  ("s-6" . winum-select-window-6)
  ("s-7" . winum-select-window-7)
  ("s-8" . winum-select-window-8)
  ("s-9" . winum-select-window-9)
  :config
  (winum-mode))



(use-package string-inflection)



(provide 'core-extra)
