(use-package yaml-mode)
(use-package docker-compose-mode :mode "docker-compose.*\.yml\\'")
(use-package dockerfile-mode :mode "Dockerfile[a-zA-Z.-]*\\'")
(use-package terraform-mode :mode ("\\.tf\\'" . terraform-mode))
;; (use-package gitignore-mode :mode "/\\.gitignore\\'")
(use-package groovy-mode)
(use-package jenkinsfile-mode)
;; (use-package ansible)

;; (use-package po-mode
;;   :load-path "/usr/local/Cellar/gettext/0.19.5.1/share/emacs/site-lisp/"
;;   :commands (po-mode)
;;   )


(provide 'k-dotfiles)
