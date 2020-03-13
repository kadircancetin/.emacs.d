(use-package cc-mode
  :init
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook 'auto-highlight-symbol-mode)
  :bind
  (:map c-mode-map
        ("C-c C-n" . flymake-goto-next-error)
        ("C-c C-p" . flymake-goto-prev-error)
        ("M-ı" . eglot-format-buffer))
  :config
  (setq-default eglot-ignored-server-capabilites '(:documentHighlightProvider
                                                   :hoverProvider
                                                   :signatureHelpProvider)))




(provide 'k_clang)
