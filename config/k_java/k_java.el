(use-package lsp-java
  :bind (:map java-mode-map
              ("M-." . lsp-ui-peek-find-definitions)
              ("C-c C-n" . flycheck-next-error)
              ("C-c C-p" . flycheck-previous-error))
  :config (add-hook 'java-mode-hook 'lsp))

;; (use-package dap-mode
;;   :after lsp-mode
;;   :config
;;   (dap-mode t)
;;   (dap-ui-mode t))

;; (use-package dap-java :after (lsp-java))


(provide 'k_java)
