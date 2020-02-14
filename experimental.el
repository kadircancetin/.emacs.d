(use-package deft
  :defer nil
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/org/")
  (deft-use-filename-as-title t))


;; (defhydra hydra-zoom (global-map "<f2>")
;;   "zoom"
;;   ("g" text-scale-increase "in")
;;   ("l" text-scale-decrease "out"))


(global-set-key (kbd "C-c d d") 'deft)


(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  )

(use-package darkroom)
