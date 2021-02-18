(require 'use-package)


(use-package go-mode
  :commands (go-mode)
  :init
  (add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))
  :hook
  (go-mode . kadir/go-mode-hook-lsp)
  :bind
  (:map go-mode-map
        ("C-c C-d" . lsp-ui-doc-show)
        )
  :config
  ;; (require 'bind-key)
  ;; (unbind-key "C-c C-d" org-mode-map)
  )

(defun kadir/go-mode-hook-lsp()
  (kadir/lsp-ui-activate)
  (lsp-deferred)
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  )


(defun kadir/go-mode-hook-eglot()
  (eglot-ensure)
  (with-eval-after-load 'flycheck
    (setq-default flycheck-disabled-checkers '(go-gofmt))))



(provide 'k-go)
