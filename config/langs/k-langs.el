(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'prog-mode-hook #'wakatime-mode)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook #'k-colors-mode)
(add-hook 'prog-mode-hook #'kadir/activate-flycheck)

(defun kadir/activate-flycheck()
  (flymake-mode-off)
  (flycheck-mode 1))

(defun kadir/deactivate-flycheck()
  (flycheck-mode 0))


(provide 'k-langs)
