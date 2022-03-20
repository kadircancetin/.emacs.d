(require 'use-package)

(use-package clojure-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
  (add-hook 'clojure-mode-hook 'lsp)
  (add-hook 'clojurescript-mode-hook 'lsp)
  (add-hook 'clojurec-mode-hook 'lsp)
  (add-hook 'cider-mode-hook 'eldoc-mode)

  :config


  (use-package flycheck-clojure
    :config
    (flycheck-clojure-setup))

  (setq nrepl-popup-stacktraces nil)

  (use-package elein)

  (use-package cider
    :init
    (setq cider-repl-pop-to-buffer-on-connect t)
    (setq cider-prompt-for-symbol t)
    (setq cider-show-error-buffer t)
    (setq cider-auto-select-error-buffer t)
    (add-hook 'clojure-mode-hook #'cider-mode)
    :config
    (cider-add-to-alist 'cider-jack-in-dependencies
                        "org.clojure/core.async" "1.5.648")
    )





  )



(provide 'k-clojure)
