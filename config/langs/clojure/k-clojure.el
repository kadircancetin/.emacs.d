(require 'use-package)

(use-package clojure-mode)
(use-package cider
  :init
  (add-hook 'clojure-mode-hook #'cider-mode))

(provide 'k-clojure)
