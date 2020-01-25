(use-package multiple-cursors)


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
         helm-M-x-always-save-history          t
         helm-M-x-input-history                t
         ;; helm-completion-style                 'helm-fuzzy
         helm-completion-style                  '(basic flex)
         helm-buffers-fuzzy-matching           t
         helm-candidate-number-limit           500
         helm-display-function                 'pop-to-buffer)
  :config
  (helm-mode 1)
  ;; i thing it load the default helm, shortcuts which I never use.
  (add-hook 'helm-minibuffer-set-up-hook
            'spacemacs//helm-hide-minibuffer-maybe))


(use-package shackle
  :defer 0.1
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)))
  (add-to-list 'shackle-rules '(help-mode :align t :size 0.4 :select t)))


(use-package projectile
  :defer 1
  :init
  (use-package helm-projectile
    :config
    (projectile-mode 1)))         ; son projeleri hatırlamada işe yaramazsa sil geç


(use-package helm-ag
  :config (setq
           helm-ag-base-command
           "rg -S --no-heading --color=never --line-number --max-columns 200"))
(use-package helm-rg
  :init (setq helm-rg-default-directory 'git-root
              helm-rg--extra-args '("--max-columns" "200")
              helm-rg-input-min-search-chars 1))

(use-package deadgrep)



(use-package undo-tree
  :defer 0.2
  :config
  (global-undo-tree-mode))


(use-package mwim)


(use-package expand-region
  :init
  (setq expand-region-fast-keys-enabled   nil
        expand-region-subword-enabled     t))


(use-package doom-modeline
  :defer 0.1
  :config
  (setq doom-modeline-bar-width       1
        doom-modeline-height            1
        doom-modeline-buffer-encoding   nil
        ;; doom-modeline-buffer-modification-icon t
        doom-modeline-vcs-max-length    20
        doom-modeline-icon              t
        ;; relative-to-project
        doom-modeline-buffer-file-name-style 'relative-from-project)
  (set-face-attribute 'mode-line nil :height 80)
  (set-face-attribute 'mode-line-inactive nil :height 80)
  (doom-modeline-mode 1))


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


(use-package anzu ; TODO: anzu mode ve isearch yarı fuzzy olunca eşleşmiyor
  :defer 1
  :config
  (global-anzu-mode 1))


(use-package eglot
  :bind
  (:map eglot-mode-map("C-c DEL" . 'eglot-help-at-point))  ; TODO: change keybind
  )


(use-package yasnippet
  :defer 2
  :commands (yas-insert-snippet yas-insert-snippet)
  :config
  (use-package yasnippet-snippets   :defer nil)
  (yas-global-mode))


(use-package auto-highlight-symbol
  :defer t
  :init
  (add-hook 'prog-mode-hook 'auto-highlight-symbol-mode)
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
