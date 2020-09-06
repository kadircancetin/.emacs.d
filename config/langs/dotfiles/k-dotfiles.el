(use-package yaml-mode)
(use-package docker-compose-mode :mode "docker-compose.*\.yml\\'")
(use-package dockerfile-mode :mode "Dockerfile[a-zA-Z.-]*\\'")
(use-package terraform-mode :mode ("\\.tf\\'" . terraform-mode))

(provide 'k-dotfiles)
