(require 'use-package)

(use-package nim-mode
  :config
  :hook  (nim-mode . nimsuggest-mode)
  )

(provide 'k_nim)
