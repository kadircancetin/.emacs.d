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
