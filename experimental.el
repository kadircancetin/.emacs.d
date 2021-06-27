(require 'use-package)


(use-package syntactic-close)
(global-set-key (kbd "M-m") 'syntactic-close)



(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.1
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)



(defun eldoc-mode(&rest args)
  (message "no eldoc"))

(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))




(load-file (expand-file-name "side-window.el" user-emacs-directory))
(global-set-key (kbd "M-ü") 'kadir/smart-push-pop)




(use-package tree-sitter
  :defer t
  :straight
  (tree-sitter :host github
               :repo "ubolonton/emacs-tree-sitter"
               :files ("lisp/*.el")))

(use-package tree-sitter-langs
  :defer t
  :straight
  (tree-sitter-langs :host github
                     :repo "ubolonton/emacs-tree-sitter"
                     :files ("langs/*.el" "langs/queries")))

(add-hook 'python-mode-hook  (lambda () (require 'tree-sitter-langs) (tree-sitter-hl-mode)))
(add-hook 'python-mode-hook  (lambda () (rainbow-delimiters-mode-disable)))



(use-package gcmh
  :init
  (gcmh-mode)
  (setq garbage-collection-messages t)
  (setq gcmh-verbose t)
  (setq gcmh-idle-delay 2)
  ;; (add-hook  'post-gc-hook (lambda() (message "garbage collected")))
  )


(use-package which-key
  :defer 3
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.4))



