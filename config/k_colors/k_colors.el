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
  (setq diff-hl-flydiff-delay 2)
  (diff-hl-flydiff-mode 1))

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

(use-package prism
  :straight (prism :type git :host github :repo "alphapapa/prism.el")
  :defer t
  :hook ((emacs-lisp-mode . prism-mode) ;; (json-mode . prism-mode)
         )
  :config
  ;; TODO call after theme load
  (prism-set-colors :num 16
    :desaturations (cl-loop for i from 0 below 16
                            collect (* i 1))
    :lightens (cl-loop for i from 0 below 16
                       collect (* i 1))
    :comments-fn
    (lambda (color)
      (prism-blend color
                   "#2d9574" 0.5))
    :strings-fn
    (lambda (color)
      (prism-blend color "#2d9574" 0))

    :colors (list
             "#bf6bc7"  ;; pembe
             "#4f97e7"  ;; blue
             "#c2c2c2"  ;; base
             "#b1951d"  ;; yellow
             ))
  )


(use-package rainbow-blocks)




(provide 'k_colors)
