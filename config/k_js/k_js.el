(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))
  (setq js2-basic-offset 2
        js-indent-level 2))
(use-package typescript-mode
  :bind (:map typescript-mode-map ("M-." . lsp-ui-peek-find-definitions))
  )

(use-package rjsx-mode
  :init
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
  :bind (:map rjsx-mode-map
              ;; ("<" . nil)
              ;; ("C-d" . nil)
              ;; (">" . nil)
              ("C-c C-n" . flycheck-next-error)
              ("C-c C-p" . flycheck-previous-error)
              ("M-." . lsp-ui-peek-find-definitions))
  :config
  (add-hook 'rjsx-mode-hook #'lsp))


(provide 'k_js)
