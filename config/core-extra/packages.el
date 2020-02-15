(use-package multiple-cursors)
(use-package mwim)
(use-package goto-chg)


(use-package undo-tree
  :defer 0.2
  :config
  (global-undo-tree-mode))


(use-package expand-region
  :init
  (setq expand-region-fast-keys-enabled   nil
        expand-region-subword-enabled     t))


(use-package shackle
  :defer 0.1
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)))
  (add-to-list 'shackle-rules '(help-mode :align t :size 0.4 :select t)))


(use-package auto-highlight-symbol
  :defer t
  :config
  (kadir/ahs-set-colors)
  (setq ahs-case-fold-search nil
        ahs-default-range 'ahs-range-display
        ahs-idle-interval 0.2
        ahs-inhibit-face-list nil)
  (setq ahs-idle-timer
        (run-with-idle-timer ahs-idle-interval t
                             'ahs-idle-function)))


(use-package company
  :init
  (setq-default company-dabbrev-downcase nil)
  (setq company-idle-delay         0.15
        company-dabbrev-downcase   nil
        company-minimum-prefix-length 1
        ;; company-echo-delay 0                ; remove annoying blinking
        company-tooltip-align-annotations 't)

  :defer 0.1
  :bind ((:map company-active-map
               ([return] . nil)
               ("RET" . nil)
               ("TAB" . company-complete-selection)
               ("<tab>" . company-complete-selection)
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous))
         (:map company-mode-map ("C-." . helm-company)))
  :config
  ;; (use-package company-tabnine :defer nil)
  (global-company-mode 1)

  (progn
    (setq company-backends nil)
    (add-to-list 'company-backends '(company-dabbrev))
    (add-to-list 'company-backends '(company-yasnippet
                                     ;; :with
                                     ;; company-dabbrev
                                     :separate
                                     ;; company-tabnine
                                     company-files))

    (add-to-list 'company-backends '(company-capf))
    (prin1 company-backends)
    )

  (load-file (expand-file-name "company-try-hard.el" user-emacs-directory))
  )

(use-package company-quickhelp
  :after (company)
  :init
  (company-quickhelp-mode)
  (setq company-quickhelp-max-lines 20
        company-quickhelp-delay     nil)
  :bind (:map company-active-map ("M-h"
                                  . company-quickhelp-manual-begin)))

(use-package helm-company)


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
  ;; :config
  ;; (add-to-list 'eglot-server-programs '((js-mode) "typescript-language-server" "--stdio"))
  :bind
  (:map eglot-mode-map("C-c DEL" . 'eglot-help-at-point)))  ; TODO: change keybind


(use-package lsp-mode
  :config
  (kadir/lsp-set-colors)
  (setq  lsp-enable-snippet nil
         lsp-prefer-flymake nil)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (use-package flycheck)
  (flymake-mode 0)
  (flycheck-mode 1)
  (use-package lsp-ui
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
    :config
    (push 'company-lsp company-backends)))


(use-package yasnippet
  :defer 2
  :commands (yas-insert-snippet yas-insert-snippet)
  :config
  (use-package yasnippet-snippets   :defer nil)
  (yas-global-mode))


(use-package helm-ag
  :config (setq
           helm-ag-base-command
           "rg -S --no-heading --color=never --line-number --max-columns 200"))
(use-package helm-rg
  :init (setq helm-rg-default-directory 'git-root
              helm-rg--extra-args '("--max-columns" "200")
              helm-rg-input-min-search-chars 1))
(use-package deadgrep)


(use-package magit
  :defer t
  :commands (magit-status)
  :bind ((:map magit-status-mode-map
               (("C-x 4 C-m" . magit-diff-visit-file-other-window))))
  :config
  (use-package magit-todos
    :defer nil
    :init
    (magit-todos-mode 1)
    (magit-todos-branch-list-toggle)))


(use-package sudo-edit
  :commands (sudo-edit))


(use-package wakatime-mode
  :if (executable-find "wakatime")
  :defer 5
  :config
  (add-hook 'prog-mode-hook 'wakatime-mode)
  (message "waka activated"))
