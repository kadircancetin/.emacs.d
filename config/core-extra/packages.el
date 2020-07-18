(use-package multiple-cursors)
(use-package mwim)
(use-package goto-chg)


(use-package undo-tree
  :init
  (setq undo-tree-auto-save-history t)
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
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("\\`\\*helpful.*?\\*\\'" :regexp t :align t :size 0.4)))
  (add-to-list 'shackle-rules '(help-mode :align t :size 0.4 :select t)))


(use-package helpful)


(use-package auto-highlight-symbol
  :defer t
  :config
  (setq ahs-case-fold-search nil
        ahs-default-range 'ahs-range-display
        ahs-idle-interval 0.2
        ahs-inhibit-face-list nil)
  (setq ahs-idle-timer
        (run-with-idle-timer ahs-idle-interval t
                             'ahs-idle-function)))


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

(use-package helm-swoop
  :init
  (setq helm-swoop-speed-or-color t
        helm-swoop-split-window-function 'display-buffer
        helm-swoop-min-overlay-length 0
        helm-swoop-use-fuzzy-match t)
  :bind (
         :map isearch-mode-map
         ("M-s" . helm-swoop-from-isearch)
         :map helm-swoop-map
         ("M-s" . helm-multi-swoop-all-from-helm-swoop)
         :map helm-swoop-edit-map
         ("C-c C-c" . helm-swoop--edit-complete)
         ("C-c C-k" . helm-swoop--edit-cancel))
  :config
  (set-face-attribute 'helm-swoop-target-line-face nil :background "black" :foreground nil
                      :inverse-video nil
                      ;; :extend t
                      )
  (set-face-attribute 'helm-swoop-target-word-face nil :inherit 'lazy-highlight :foreground nil))

(use-package ace-window
  :defer t
  :init
  (setq
   ;; aw-keys '(?a ?s ?n ?o ?p ?f ?p ?k ?l)
   aw-scope 'frame))


(use-package wrap-region
  :defer 1
  :config
  (wrap-region-add-wrapper "<>" "</>" "#" 'rjsx-mode)
  (wrap-region-add-wrapper "#+begin_src emacs-lisp\n  " "\n#+end_src" "*" 'org-mode)
  (wrap-region-add-wrapper "{% trans \"" "\"  %}" "*" 'web-mode)
  (wrap-region-add-wrapper "<p>" "</p>" "!" 'web-mode)
  (wrap-region-add-wrapper "=" "=" "=" 'org-mode)
  (wrap-region-global-mode t))


(use-package eglot
  ;; :config
  ;; (add-to-list 'eglot-server-programs '((js-mode) "typescript-language-server" "--stdio"))
  :bind
  (:map eglot-mode-map("C-c C-d" . 'eglot-help-at-point)))  ; TODO: change keybind


(use-package flycheck)
(use-package lsp-mode
  :config
  ;; (setq lsp-enable-snippet nil)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,


  ;; lsp-eldoc-render-all nil                                                      ???????
  ;; lsp-enable-indentation t
  (setq
   ;; lsp-log-io t
   ;; lsp-print-performance t
   lsp-enable-snippet nil

   lsp-enable-folding nil ;; hiç kullanmadığım için
   lsp-enable-semantic-highlighting nil   ;; bi işe yaradığını görmedim
   lsp-progress-via-spinner nil ;; gereksiz gibi
   lsp-auto-execute-action nil ;; anlamadım ama tehlikeli geldi :D

   lsp-eldoc-enable-hover nil ;; hover genelde yavaş çalışıyor TODO: pyls illa hover açıyor gibi
   lsp-enable-symbol-highlighting nil

   lsp-response-timeout 10 ;; TODO: is it true way?
   lsp-signature-auto-activate nil
   lsp-signature-render-documentation nil
   ;; lsp-signature-doc-lines 5

   ;; lsp-prefer-capf nil ;;                       TODO:
   ;; ?????????????


   ;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; get from doom emacs
   ;;;;;;;;;;;;;;;;;;;;;;;;;
   lsp-enable-links nil
   ;; Potentially slow
   lsp-enable-file-watchers nil
   lsp-enable-text-document-color nil
   lsp-enable-semantic-highlighting nil
   ;; Don't modify our code without our permission
   lsp-enable-indentation nil
   lsp-enable-on-type-formatting nil
   ;; capf is the preferred completion mechanism for lsp-mode now
   lsp-prefer-capf t

   )


  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (flymake-mode 0)
  (flycheck-mode 1)

  (use-package lsp-ui
    :init

    (setq lsp-ui-doc-enable t
          lsp-ui-doc-header t
          lsp-ui-doc-include-signature t
          lsp-ui-doc-position 'bottom
          lsp-ui-doc-alignment 'window
          lsp-ui-doc-border "white"
          lsp-ui-doc-max-width 100
          lsp-ui-doc-max-height 10
          lsp-ui-doc-use-childframe t
          lsp-ui-doc-use-webkit nil
          lsp-ui-doc-delay 0.2
          lsp-ui-doc-winum-ignore t)

    (setq lsp-ui-imenu-enable t
          lsp-ui-imenu-kind-position 'top
          lsp-ui-imenu-colors '("deep sky blue" "green3")
          lsp-ui-imenu-window-width 0
          lsp-ui-imenu--custom-mode-line-format nil)
    (setq lsp-ui-peek-enable t
          lsp-ui-peek-show-directory t
          lsp-ui-peek-peek-height 30
          lsp-ui-peek-list-width 50
          lsp-ui-peek-fontify 'always)
    (setq lsp-ui-flycheck-list-position 'bottom)

    (setq lsp-ui-sideline-enable t
          lsp-ui-sideline-ignore-duplicate t
          lsp-ui-sideline-show-symbol t
          lsp-ui-sideline-show-hover nil
          lsp-ui-sideline-show-diagnostics t
          lsp-ui-sideline-show-code-actions t
          lsp-ui-sideline-update-mode 'point
          lsp-ui-sideline-delay 0.2
          lsp-ui-sideline-diagnostic-max-lines 20
          lsp-ui-sideline-diagnostic-max-line-length 100
          lsp-ui-sideline-actions-kind-regex "quickfix.*\\|refactor.*")
    :config
    (require 'lsp-ui-sideline)
    (add-hook 'lsp-mode-hook 'lsp-ui-sideline-mode)
    (use-package helm-lsp)
    )
  )


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
  ;; NOTE: source codda değişiklik yaptım
  ;;(helm-make-source "ripgrep" 'helm-source-async ;; helm-grep-ag-class
  :init
  (setq helm-rg-default-directory 'git-root
        helm-rg--extra-args '("--max-columns" "200")
        helm-rg-input-min-search-chars 1))
(use-package deadgrep)


(use-package magit
  :defer t
  :commands (magit-status)
  :bind ((:map magit-status-mode-map
               (("C-x 4 C-m" . magit-diff-visit-file-other-window))))
  :config
  :init
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  (use-package magit-todos
    :init
    ;; (magit-todos-mode 1)
    ;; (magit-todos-branch-list-toggle)
    ))


(use-package sudo-edit
  :commands (sudo-edit))


(use-package activity-watch-mode
  :if (executable-find "aw-qt")
  :defer 5
  :config
  (setq activity-watch-pulse-time 5)

  (add-hook 'prog-mode-hook 'activity-watch-mode)
  (message "activity watch enabled"))

(use-package wakatime-mode
  :if (executable-find "wakatime")
  :defer 5
  :config
  (add-hook 'prog-mode-hook 'wakatime-mode)
  (message "waka activated"))
