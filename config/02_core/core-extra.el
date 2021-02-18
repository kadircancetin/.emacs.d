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
  :defer 0.2
  :config
  (global-undo-tree-mode))

(use-package expand-region
  :custom
  (expand-region-fast-keys-enabled   nil)
  (expand-region-subword-enabled     t))

(use-package shackle
  :defer 0.1
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("\\`\\*helpful.*?\\*\\'" :regexp t :align t :size 0.4)
          (help-mode :align t :size 0.4 :select t))))

(use-package wrap-region
  :defer 1
  :config
  (wrap-region-add-wrapper "<>" "</>" "#" 'rjsx-mode)
  (wrap-region-add-wrapper "#+begin_src emacs-lisp\n  " "\n#+end_src" "*" 'org-mode)
  (wrap-region-add-wrapper "{% trans \"" "\"  %}" "*" 'web-mode)
  (wrap-region-add-wrapper "<p>" "</p>" "!" 'web-mode)
  (wrap-region-add-wrapper "=" "=" "=" 'org-mode)
  (wrap-region-global-mode t))

(use-package yasnippet
  :defer 2
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
  :defer t
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



(use-package wakatime-mode
  :if (executable-find "wakatime")
  :defer 5
  :config
  (message "waka activated"))

(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr"))



(provide 'core-extra)
