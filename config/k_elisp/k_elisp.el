(add-hook 'emacs-lisp-mode-hook 'auto-highlight-symbol-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook 'auto-fill-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)


(setq-default flycheck-emacs-lisp-load-path 'inherit)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(use-package highlight-quoted)
(use-package elisp-def)

(use-package elisp-slime-nav
  :commands (elisp-slime-nav-find-elisp-thing-at-point))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package elisp-demos
  :init
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))


(use-package elisp-mode
  :straight (:type built-in)
  :bind (
         :map emacs-lisp-mode-map
         ("M-."     .  (lambda ()
                         (interactive)
                         (call-interactively
                          (when (eq (condition-case nil (elisp-def) (error nil)) nil)
                            (message "drop to slime nav")
                            elisp-slime-nav-find-elisp-thing-at-point
                            ))))
         ("C-c M-." . elisp-slime-nav-find-elisp-thing-at-point)
         ("C-c DEL" . helpful-at-point)
         ("C-c C-d" . elisp-slime-nav-describe-elisp-thing-at-point)
         ("C-c C-n" . flycheck-next-error)
         ("C-c C-p" . flycheck-previous-error)))

  (provide 'k_elisp)
