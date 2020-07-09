;; (use-package highlight-numbers
;;   :hook (prog-mode . highlight-numbers-mode))

;; NOTE: highlight-operators kebap case'i bozuyor
;; (use-package highlight-operators
;;   :hook (prog-mode . highlight-operators-mode))

(use-package highlight-symbol
  :defer t   ;; TODO: bind key
  )
(use-package rainbow-delimiters
  :defer 1
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
(use-package hl-todo
  :defer 1
  :config
  (global-hl-todo-mode))
(use-package diff-hl
  :defer 1
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 0))

(use-package color-identifiers-mode
  :defer 1
  :config
  ;; NOTE: move theese to modules
  (add-hook 'python-mode-hook #'global-color-identifiers-mode))

(use-package beacon
  :defer 1
  :config
  (beacon-mode 1)
  (setq beacon-color "#2FB90E"))

(use-package volatile-highlights
  :defer 3
  :config
  (volatile-highlights-mode 1)
  (vhl/define-extension 'undo-tree 'undo-tree-yank 'undo-tree-move)
  (vhl/install-extension 'undo-tree))


(provide 'k_colors)
