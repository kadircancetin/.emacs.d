(defun kadir/if_react_rjsx_mode ()
  "Activate rjsx if react file and if you in react mode"
  (save-excursion
    (goto-char (point-min))
    (if (and (search-forward-regexp "import.*react" nil t)
             (eq major-mode 'js-mode))
        (rjsx-mode))))

(use-package js
  :bind (:map js-mode-map
              ("M-." . lsp-ui-peek-find-definitions))
  :config
  (add-hook 'js-mode-hook #'lsp)
  (add-hook 'js-mode-hook #'kadir/if_react_rjsx_mode)
  )



(use-package js2-mode
  :init
  (setq js2-basic-offset 2
        js-indent-level 2))

(use-package typescript-mode
  :bind (:map typescript-mode-map ("M-." . lsp-ui-peek-find-definitions)))

(use-package rjsx-mode
  :bind (:map rjsx-mode-map
              ;; ("<" . nil)
              ;; ("C-d" . nil)
              ;; (">" . nil)
              ;; ("C-c C-n" . flycheck-next-error)
              ;; ("C-c C-p" . flycheck-previous-error)
              ("M-." . lsp-ui-peek-find-definitions))
  :config
  (add-hook 'rjsx-mode-hook #'lsp))

(use-package prettier-js
  ;; npm install -g prettier
  :init
  (setq prettier-js-args '("--trailing-comma" "none"
                           "--bracket-spacing" "true"
                           "--single-quote" "true"
                           ;; "--no-semi" "true"
                           "--jsx-single-quote" "true"
                           "--jsx-bracket-same-line" "true"
                           "--print-width" "90"))
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  ;; (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode 'prettier-js-mode))

(provide 'k_js)
