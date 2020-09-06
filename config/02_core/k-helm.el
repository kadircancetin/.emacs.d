(defun kadir/helm-do-ag-project-root-or-current-dir ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "If in a project call `helm-do-ag-project-root', else call
     `helm-do-ag' with current directory."
  (interactive)
  (if (projectile-project-p)
      (helm-do-ag-project-root)
    (helm-do-ag default-directory)))


(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))

(use-package helm
  :defer 0.15
  :init
  ;; (use-package helm-describe-modes)
  (setq-default helm-boring-buffer-regexp-list (list
                                                (rx "` ")
                                                (rx "*helm")
                                                (rx "*lsp")
                                                (rx "*Eglot")
                                                (rx "*Echo Area")
                                                (rx "*Minibuf")))
  (setq-default  helm-ff-search-library-in-sexp        nil
                 helm-echo-input-in-header-line        t
                 ;; helm-completion-style                  '(basic flex)
                 helm-buffers-fuzzy-matching           nil
                 helm-candidate-number-limit           100
                 helm-display-function                 'helm-default-display-buffer
                 )
  :config
  (helm-mode 1)
  (add-hook 'helm-minibuffer-set-up-hook 'spacemacs//helm-hide-minibuffer-maybe))

(use-package helm-projectile
  :config
  (projectile-mode 1))

(use-package helm-ag
  :config (setq
           helm-ag-base-command
           "rg -S --no-heading --color=never --line-number --max-columns 200"))
(use-package helm-rg
  :init
  (setq helm-rg-default-directory 'git-root
        helm-rg--extra-args '("--max-columns" "200")
        helm-rg-input-min-search-chars 1))


(use-package helm-swoop
  :init
  (setq helm-swoop-speed-or-color t
        helm-swoop-split-window-function 'display-buffer
        helm-swoop-min-overlay-length 0
        helm-swoop-use-fuzzy-match t)
  :bind (
         :map isearch-mode-map
         ("M-s" . helm-swoop-from-isearch)
         :map helm-swoop-map
         ("M-s" . helm-multi-swoop-all-from-helm-swoop)
         :map helm-swoop-edit-map
         ("C-c C-c" . helm-swoop--edit-complete)
         ("C-c C-k" . helm-swoop--edit-cancel))
  :config
  (set-face-attribute 'helm-swoop-target-line-face nil :background "black" :foreground nil
                      :inverse-video nil)
  (set-face-attribute 'helm-swoop-target-word-face nil :inherit 'lazy-highlight :foreground nil))

(provide 'k-helm)
