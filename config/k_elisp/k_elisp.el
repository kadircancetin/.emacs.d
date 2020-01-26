(use-package elisp-slime-nav
  :commands (elisp-slime-nav-find-elisp-thing-at-point)
  :bind (:map emacs-lisp-mode-map
              ("M-." . elisp-slime-nav-find-elisp-thing-at-point)))

(use-package aggressive-indent
  :diminish
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(provide 'k_elisp)
