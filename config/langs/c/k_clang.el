(use-package cc-mode
  :init
  ;; (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook #'lsp)
  :bind
  (:map c-mode-map
        ;; ("C-c C-n" . flymake-goto-next-error)
        ;; ("C-c C-p" . flymake-goto-prev-error)
        ;; ("M-ı" . eglot-format-buffer))
        ("M-ı" . lsp-format-buffer)
        ;; ("C-c C-n" . flycheck-next-error)
        ;; ("C-c C-p" . flycheck-previous-error)
        )
  :config
  ;; (setq-default eglot-ignored-server-capabilites '(:documentHighlightProvider
  ;;                                                  :hoverProvider
  ;;                                                  :signatureHelpProvider))
  ;; (add-hook 'before-save-hook 'lsp-format-buffer)
  )




(provide 'k_clang)
