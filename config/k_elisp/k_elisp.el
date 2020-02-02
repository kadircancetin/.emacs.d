(add-hook 'emacs-lisp-mode-hook 'auto-highlight-symbol-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook 'auto-fill-mode)

(setq-default flycheck-emacs-lisp-load-path 'inherit)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))


(use-package elisp-slime-nav
  :commands (elisp-slime-nav-find-elisp-thing-at-point)
  :bind (:map emacs-lisp-mode-map
              ("M-." . elisp-slime-nav-find-elisp-thing-at-point)
              ("C-c C-n" . flycheck-next-error)
              ("C-c C-p" . flycheck-previous-error)))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(provide 'k_elisp)
