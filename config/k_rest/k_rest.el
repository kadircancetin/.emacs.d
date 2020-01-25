(use-package restclient
  :init
  (add-to-list 'auto-mode-alist '("\\(\\.http\\'\\)" . restclient-mode))
  :config
  (use-package company)                 ; TODO: ??
  (add-to-list 'company-backends 'company-restclient))

(use-package company-restclient
  :after (company restclient))

(provide 'k_rest)
