(use-package web-mode
  :init
  (global-set-key (kbd "C-c k") 'web-mode-element-close) ;; TODO: make mode map
  (setq css-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-attr-indent-offset 2
        web-mode-engines-alist '(("django"    . "\\.html\\'")))
  (add-hook 'mhtml-mode 'web-mode)
  (add-hook 'web-mode-hook 'toggle-truncate-lines)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode)))

(use-package emmet-mode
  :init
  (setq emmet-move-cursor-between-quotes t)
  :bind
  (:map emmet-mode-keymap
        ([remap yas-expand] . emmet-expand-line)
        ("M-n"  . emmet-next-edit-point)
        ("M-p"  . emmet-prev-edit-point)
        ("C-c p" . emmet-preview-mode))
  :config
  (set-face-attribute 'emmet-preview-input nil :inherit nil :box t :weight 'bold)
  :hook
  ;;(rjsx-mode . (lambda () (setq emmet-expand-jsx-className? t)))
  (web-mode . emmet-mode))

(use-package helm-emmet
  :after helm emmet web-mode)

(use-package sass-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))

(provide 'k_html)
