(use-package web-mode
  :init
  (setq css-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-attr-indent-offset 2
        web-mode-engines-alist '(("django"    . "\\.html\\'")))
  (add-hook 'mhtml-mode 'web-mode)
  (add-hook 'web-mode-hook 'toggle-truncate-lines)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode)))

(provide 'k_html)
