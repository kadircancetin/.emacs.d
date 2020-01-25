(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr"))


(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.01))


(use-package magit
  :commands (magit-status)
  :bind ((:map magit-status-mode-map
               (("C-x 4 C-m" . magit-diff-visit-file-other-window))
               ))
  :config
  (use-package magit-todos
    :defer nil
    :init (magit-todos-mode 1)))


(use-package lsp-mode
  :config
  (setq  lsp-enable-snippet nil
         lsp-prefer-flymake nil)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (use-package flycheck
    )
  (flymake-mode 0)
  (flycheck-mode 1)
  (use-package lsp-ui
    :requires lsp-mode flycheck
    :init
    (setq lsp-ui-doc-enable t
          lsp-ui-doc-use-childframe t
          lsp-ui-doc-position 'top
          lsp-ui-doc-include-signature t
          lsp-ui-sideline-enable nil
          lsp-ui-flycheck-enable t
          lsp-ui-flycheck-list-position 'right
          lsp-ui-flycheck-live-reporting nil  ; daha az sıklıkla flycheck
          lsp-ui-peek-enable t
          lsp-ui-peek-list-width 60
          lsp-ui-peek-peek-height 25))
  (use-package company-lsp
    :requires company
    :config
    (push 'company-lsp company-backends)))


(use-package dashboard
  :init
  (setq dashboard-banner-logo-title   nil
        dashboard-center-content      t
        ;; dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-startup-banner      'logo
        dashboard-set-navigator    t
        dashboard-set-init-info       t
        dashboard-set-footer          nil
        )
  ;; Format: "(icon title help action face prefix suffix)"
  (setq dashboard-navigator-buttons
        `(;; line1
          (
           (,nil
            "Agenda"
            "Agenda"
            (lambda (&rest _) (org-agenda)))
           )
          (("EMACS HELP" "" "?/h" (lambda (&rest _) (info "emacs")) nil "<" ">"))
          ))
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 10)
                          (registers . 5)))
  (dashboard-setup-startup-hook)
  )


(use-package shell-pop
  :defer 0.5
  :init
  (setq shell-pop-shell-type '("aweshell" "aweshell*" (lambda () (eshell)))
        shell-pop-window-size 40))


(use-package bm)
(use-package helm-bm)


(use-package dumb-jump
  :init
  (setq dumb-jump-prefer-searcher 'rg
        dumb-jump-force-searcher  'rg
        dumb-jump-selector 'helm))


(use-package yasnippet
  :defer 2
  :commands (yas-insert-snippet yas-insert-snippet)
  :config
  (use-package yasnippet-snippets   :defer nil)
  (yas-global-mode))










