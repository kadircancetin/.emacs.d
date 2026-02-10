(use-package lsp-mode
  :diminish "LSP"
  :ensure t
  :hook ((lsp-mode . lsp-diagnostics-mode)
         (lsp-mode . lsp-enable-which-key-integration)
         ((tsx-ts-mode
           typescript-ts-mode
           js-ts-mode) . lsp-deferred))
  :custom
  (lsp-keymap-prefix "C-c l")           ; Prefix for LSP actions
  (lsp-completion-provider :none)       ; Using Corfu as the provider
  (lsp-diagnostics-provider :flycheck)
  (lsp-session-file (locate-user-emacs-file ".lsp-session"))
  (lsp-log-io nil)                      ; IMPORTANT! Use only for debugging! Drastically affects performance
  (lsp-keep-workspace-alive nil)        ; Close LSP server if all project buffers are closed
  (lsp-idle-delay 0.5)                  ; Debounce timer for `after-change-function'
  ;; core
  (lsp-enable-xref t)                   ; Use xref to find references
  (lsp-auto-configure t)                ; Used to decide between current active servers
  (lsp-eldoc-enable-hover t)            ; Display signature information in the echo area
  (lsp-enable-dap-auto-configure t)     ; Debug support
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)              ; I disable folding since I use origami
  (lsp-enable-imenu t)
  (lsp-enable-indentation nil)          ; I use prettier
  (lsp-enable-links nil)                ; No need since we have `browse-url'
  (lsp-enable-on-type-formatting nil)   ; Prettier handles this
  (lsp-enable-suggest-server-download t) ; Useful prompt to download LSP providers
  (lsp-enable-symbol-highlighting t)     ; Shows usages of symbol at point in the current buffer
  (lsp-enable-text-document-color nil)   ; This is Treesitter's job

  (lsp-ui-sideline-show-hover nil)      ; Sideline used only for diagnostics
  (lsp-ui-sideline-diagnostic-max-lines 20) ; 20 lines since typescript errors can be quite big
  ;; completion
  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit t) ; Ex: auto-insert an import for a completion candidate
  (lsp-enable-snippet t)                         ; Important to provide full JSX completion
  (lsp-completion-show-kind t)                   ; Optional
  ;; headerline
  (lsp-headerline-breadcrumb-enable t)  ; Optional, I like the breadcrumbs
  (lsp-headerline-breadcrumb-enable-diagnostics nil) ; Don't make them red, too noisy
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  (lsp-headerline-breadcrumb-icons-enable nil)
  ;; modeline
  (lsp-modeline-code-actions-enable nil) ; Modeline should be relatively clean
  (lsp-modeline-diagnostics-enable nil)  ; Already supported through `flycheck'
  (lsp-modeline-workspace-status-enable nil) ; Modeline displays "LSP" when lsp-mode is enabled
  (lsp-signature-doc-lines 1)                ; Don't raise the echo area. It's distracting
  (lsp-ui-doc-use-childframe t)              ; Show docs for symbol at point
  (lsp-eldoc-render-all nil)            ; This would be very useful if it would respect `lsp-signature-doc-lines', currently it's distracting
  ;; lens
  (lsp-lens-enable nil)                 ; Optional, I don't need it
  ;; semantic
  (lsp-semantic-tokens-enable nil)      ; Related to highlighting, and we defer to treesitter

  :init
  (setq lsp-use-plists t))

(use-package lsp-ui
  :ensure t
  :commands
  (lsp-ui-doc-show
   lsp-ui-doc-glance)
  :bind (:map lsp-mode-map
              ("C-c C-d" . 'lsp-ui-doc-glance))
  :after (lsp-mode evil)
  :config (setq lsp-ui-doc-enable t
                evil-lookup-func #'lsp-ui-doc-glance ; Makes K in evil-mode toggle the doc for symbol at point
                lsp-ui-doc-show-with-cursor nil      ; Don't show doc when cursor is over symbol - too distracting
                lsp-ui-doc-include-signature t       ; Show signature
                lsp-ui-doc-position 'at-point))


;; (defun kadir/if_react_rjsx_mode ()
;;   "Activate rjsx if react file and if you in react mode"
;;   (save-excursion
;;     (goto-char (point-min))
;;     (if (and (search-forward-regexp "import.*react" nil t)
;;              (eq major-mode 'js-mode))
;;         (rjsx-mode))))

;; (use-package js
;;   :config
;;   (add-hook 'js-mode-hook #'lsp)
;;   (add-hook 'js-mode-hook #'kadir/lsp-ui-activate)
;;   ;; (add-hook 'js-mode-hook #'kadir/if_react_rjsx_mode)
;;   )


;; (use-package js2-mode
;;   :init
;;   (setq js2-basic-offset 2
;;         js-indent-level 2
;;         js2-strict-missing-semi-warning nil))

(use-package typescript-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.cts\\'" . typescript-mode))

  ;; (load-file (expand-file-name "config/langs/js/typescript_rjsx.el" user-emacs-directory))
  ;; (setq-default typescript-indent-level 2)

  (add-hook 'typescript-mode-hook #'lsp-deferred)

  ;; (kadir/lsp-ui-activate)
  ;; (lsp-ui-mode)

  :bind (:map typescript-mode-map
              ("M-." . xref-find-definitions)
              ("M-ı" . lsp-format-buffer)))



;; (use-package rjsx-mode
;;   :bind (:map rjsx-mode-map
;;               ;; ("<" . nil)
;;               ;; ("C-d" . nil)
;;               ;; (">" . nil)
;;               ;; ("C-c C-n" . flycheck-next-error)
;;               ;; ("C-c C-p" . flycheck-previous-error)
;;               ;; ("M-." . lsp-ui-peek-find-definitions)
;;               )
;;   :config
;;   (add-hook 'rjsx-mode-hook #'lsp))



;; (use-package prettier-js
;;   ;; npm install -g prettier
;;   :init
;;   (setq prettier-js-args '("--trailing-comma" "es5"
;;                            "--bracket-spacing" "true"
;;                            "--single-quote" "true"
;;                            ;; "--no-semi" "true"
;;                            "--jsx-single-quote" "false"
;;                            "--jsx-bracket-same-line" "true"
;;                            "--print-width" "120"))

;;   (add-hook 'js2-mode-hook 'prettier-js-mode)
;;   ;; (add-hook 'web-mode-hook 'prettier-js-mode)
;;   (add-hook 'rjsx-mode 'prettier-js-mode)
;;   (add-hook 'js2-mode-hook 'prettier-js-mode)
;;   ;; (add-hook 'web-mode-hook 'prettier-js-mode)
;;   )


(use-package json-mode)


;; (use-package vue-mode
;;   :mode (("\\.vue\\'" . vue-mode))
;;   :init
;;   (add-hook 'vue-mode-hook 'flycheck-mode)
;;   (setq mmm-submode-decoration-level 0)
;;   :config
;;   (add-hook 'vue-mode-hook #'lsp)
;;   (setq prettier-js-args '("--parser vue"))
;;   )



(provide 'k_js)
