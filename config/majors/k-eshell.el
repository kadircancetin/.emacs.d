(require 'use-package)

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  :bind (:map esh-autosuggest-active-map
              ("C-e" . company-complete-selection)
              ("C-f" . esh-autosuggest-complete-word)
              ))

(use-package eshell-git-prompt
  :hook (eshell-mode . (lambda () (eshell-git-prompt-use-theme 'git-radar))))

(use-package eshell-did-you-mean
  :config
  (eval-after-load 'eshell
    (eshell-did-you-mean-setup)))

(use-package eshell-fixed-prompt)

(use-package eshell-up
  ;; TODO: alias and other staff
  )
(use-package fish-completion
  :init
  (when (and (executable-find "fish")
             (require 'fish-completion nil t))
    (global-fish-completion-mode)))


(provide 'k-eshell)
