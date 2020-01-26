(use-package multiple-cursors)


(use-package shackle
  :defer 0.1
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)))
  (add-to-list 'shackle-rules '(help-mode :align t :size 0.4 :select t)))


(use-package undo-tree
  :defer 0.2
  :config
  (global-undo-tree-mode))


(use-package mwim)


(use-package expand-region
  :init
  (setq expand-region-fast-keys-enabled   nil
        expand-region-subword-enabled     t))


(use-package auto-highlight-symbol
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook 'auto-highlight-symbol-mode)
  (add-hook 'python-mode-hook 'auto-highlight-symbol-mode)
  :config
  (progn
    (set-face-attribute 'ahs-plugin-defalt-face nil
                        :underline t :weight 'bold :background nil :foreground nil)
    (set-face-attribute 'ahs-definition-face nil
                        :underline t :weight 'bold :background nil :foreground nil)
    (set-face-attribute 'ahs-face nil
                        :underline t :weight 'bold :background nil :foreground nil)
    (set-face-attribute 'ahs-plugin-whole-buffer-face nil
                        :underline t :weight 'bold :background nil :foreground nil)
    (setq ahs-case-fold-search nil
          ahs-default-range 'ahs-range-display
          ahs-idle-interval 0.2
          ahs-inhibit-face-list nil)
    (setq ahs-idle-timer
          (run-with-idle-timer ahs-idle-interval t
                               'ahs-idle-function))))


(use-package company
  :defer 0.8
  :bind ((:map company-active-map
               ([return] . nil)
               ("RET" . nil)
               ("TAB" . company-complete-selection)
               ("<tab>" . company-complete-selection)
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous))
         (:map company-mode-map ("C-." . helm-company)))
  :config
  (global-company-mode 1)
  (setq company-idle-delay         0.05
        company-dabbrev-downcase   0.05
        company-minimum-prefix-length 1
        ;; company-echo-delay 0                ; remove annoying blinking
        company-tooltip-align-annotations 't)
  (use-package helm-company))
(use-package company-quickhelp
  :after (company)
  :init
  (company-quickhelp-mode)
  (setq company-quickhelp-max-lines 20
        company-quickhelp-delay     nil)
  :bind (:map company-active-map ("M-h" . company-quickhelp-manual-begin)))


(use-package helm
  :defer 0.15
  :init
  (if kadir/helm-extras
      (progn
        (use-package helm-dash
          :commands helm-dash)
        (use-package helm-describe-modes)
        (use-package helm-descbinds
          :init
          (fset 'describe-bindings 'helm-descbinds))))

  ;; (require 'helm-config) ;; TODO: is it realy necessary
  (setq helm-boring-buffer-regexp-list (list
                                        (rx "` ")
                                        (rx "*helm")
                                        (rx "*lsp")
                                        (rx "*Eglot")
                                        (rx "*Echo Area")
                                        (rx "*Minibuf")))
  (setq  helm-ff-search-library-in-sexp        t
         helm-echo-input-in-header-line        t
         ;; helm-completion-style                  '(basic flex)
         helm-buffers-fuzzy-matching           t
         helm-candidate-number-limit           500
         helm-display-function                 'pop-to-buffer)
  :config
  (helm-mode 1)
  ;; i thing it load the default helm, shortcuts which I never use.
  (add-hook 'helm-minibuffer-set-up-hook
            'spacemacs//helm-hide-minibuffer-maybe))
(use-package projectile
  :defer 1
  :init
  (use-package helm-projectile
    :config
    (projectile-mode 1)))


(use-package ace-window
  :defer t
  :init
  (setq aw-keys '(?a ?s ?n ?o ?p ?f ?p ?k ?l)
        aw-scope 'frame))


(use-package wrap-region
  :defer 1
  :config
  (wrap-region-add-wrapper "<>" "</>" "#" 'rjsx-mode)
  (wrap-region-add-wrapper "#+begin_src emacs-lisp\n  " "\n#+end_src" "*" 'org-mode)
  (wrap-region-add-wrapper "=" "=" "=" 'org-mode)
  (wrap-region-global-mode t))


(use-package eglot
  :bind
  (:map eglot-mode-map("C-c DEL" . 'eglot-help-at-point))  ; TODO: change keybind
  )


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


(use-package yasnippet
  :defer 2
  :commands (yas-insert-snippet yas-insert-snippet)
  :config
  (use-package yasnippet-snippets   :defer nil)
  (yas-global-mode))


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


(use-package helm-ag
  :config (setq
           helm-ag-base-command
           "rg -S --no-heading --color=never --line-number --max-columns 200"))
(use-package helm-rg
  :init (setq helm-rg-default-directory 'git-root
              helm-rg--extra-args '("--max-columns" "200")
              helm-rg-input-min-search-chars 1))
(use-package deadgrep)


(use-package anzu ; TODO: anzu mode ve isearch yarı fuzzy olunca eşleşmiyor
  :defer 1
  :config
  (global-anzu-mode 1))
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


