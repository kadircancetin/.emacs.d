;; (defun kadir/eshell-without-aweshell-normal()
;;   (use-package esh-autosuggest
;;     :hook (eshell-mode . esh-autosuggest-mode)
;;     :bind (:map esh-autosuggest-active-map
;;                 ("C-e" . company-complete-selection)
;;                 ("C-f" . esh-autosuggest-complete-word)
;;                 ))
;;   (use-package eshell-up)
;;   (use-package eshell-git-prompt
;;     :hook (eshell-mode . (lambda () (eshell-git-prompt-use-theme 'git-radar))))

;;   (use-package eshell-did-you-mean
;;     :config
;;     (eval-after-load 'eshell
;;       (eshell-did-you-mean-setup)))

;;   (use-package eshell-fixed-prompt)


;;   (use-package fish-completion
;;     :init
;;     (when (and (executable-find "fish")
;;                (require 'fish-completion nil t))
;;       (global-fish-completion-mode))))

(require 'use-package)

(use-package aweshell
  :defer 1
  :straight (:host github :repo "manateelazycat/aweshell")
  :config
  (setq-default aweshell-clear-buffer-key "C-M-l")

  (defun epe-git-p() nil) ;; disable git. it is very slow

  (defun epe-theme-pipeline ()
    "A eshell-prompt theme with full path, smiliar to oh-my-zsh theme."
    (setq eshell-prompt-regexp "^[^#\nλ]* λ[#]* ")
    (concat
     (if (epe-remote-p)
         (progn
           (concat
            (epe-colorize-with-face "┌─[" 'epe-pipeline-delimiter-face)
            (epe-colorize-with-face (epe-remote-user) 'epe-pipeline-user-face)
            (epe-colorize-with-face "@" 'epe-pipeline-delimiter-face)
            (epe-colorize-with-face (epe-remote-host) 'epe-pipeline-host-face))))

     (concat
      (epe-colorize-with-face (concat (eshell/pwd)) 'epe-dir-face))

     (when (and epe-show-python-info (bound-and-true-p venv-current-name))
       (epe-colorize-with-face (concat "(" venv-current-name ") ") 'epe-venv-face))

     (epe-colorize-with-face " λ" 'epe-symbol-face)
     (epe-colorize-with-face (if (= (user-uid) 0) "#" "") 'epe-sudo-symbol-face)
     " ")))

(provide 'k-eshell)
