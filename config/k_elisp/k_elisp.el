(use-package elisp-slime-nav
  :commands (elisp-slime-nav-find-elisp-thing-at-point)
  :bind (:map emacs-lisp-mode-map
         ("M-." . elisp-slime-nav-find-elisp-thing-at-point)))

(provide 'k_elisp)
