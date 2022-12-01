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

(use-package helm-mode-manager)

(use-package helm
  :defer 0.1
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
  (use-package all-the-icons
    :init
    (require 'all-the-icons))
  ;; (helm-mode 1)
  (add-hook 'helm-minibuffer-set-up-hook 'spacemacs//helm-hide-minibuffer-maybe)

  (defun kadir/helm--collect-matches (orig-fun src-list &rest args)
    (let ((matches
           (cl-loop for src in src-list
                    collect (helm-compute-matches src))))
      (unless (eq matches t) matches)))

  (advice-add 'helm--collect-matches :around #'kadir/helm--collect-matches))

(use-package helm-projectile
  :hook
  (projectile-mode . helm-projectile-on)
  :config
  (projectile-mode 1)
  :custom
  (helm-projectile-sources-list '(helm-source-projectile-buffers-list
                                  helm-source-projectile-recentf-list
                                  helm-source-projectile-files-list
                                  ;; helm-source-projectile-projects
                                  )))

(use-package helm-ag
  :config (setq
           helm-ag-base-command
           "rg -S --no-heading --color=never --line-number --max-columns 400"))

(use-package helm-rg
  :commands (helm-rg--get-thing-at-pt)
  :init
  (setq helm-rg-default-directory 'git-root
        helm-rg--extra-args '("--max-columns" "300"  "--no-ignore-dot")
        helm-rg-input-min-search-chars 1)

  (setq fk/rg-special-characters '("(" ")" "[" "{" "*"))

  (defun fk/convert-string-to-rg-compatible (str)
    "Escape special characters defined in `fk/rg-special-characters' of STR."
    (seq-reduce (lambda (str char) (s-replace char (concat "\\" char) str))
                fk/rg-special-characters
                str))

  (defun kadir/helm-rg-dwim (&optional query)
    (interactive)
    (let ((helm-rg-default-directory (or (projectile-project-root) default-directory)))

      (cl-letf (((symbol-function 'helm-rg--get-thing-at-pt) (lambda () query)))
        (call-interactively 'helm-rg))))

  (fset 'helm-rg--header-name
        (lambda (src-name)
          (format "%s @ %s"
                  (helm-rg--make-face
                   'helm-rg-directory-header-face
                   (s-replace
                    "argv: /usr/bin/rg --smart-case --color=ansi --colors=match:fg:red --colors=match:style:bold --max-columns 300"
                    ""
                    src-name) )

                  (helm-rg--make-face 'helm-rg-directory-header-face helm-rg--current-dir))))

  (defun kadir/helm-rg()
    (interactive)
    (kadir/helm-rg-dwim (helm-rg--get-thing-at-pt)))

  (defun kadir/helm-rg-normalize-x(func &rest args)
    (let ((search (car args)))
      (setf (elt args 0) (fk/convert-string-to-rg-compatible search))
      (apply func args)))
  (advice-add #'helm-rg--helm-pattern-to-ripgrep-regexp :around #'kadir/helm-rg-normalize-x)


  (defun kadir/helm-rg-dwim-with-glob (glob &optional query)
    (interactive)
    (let ((helm-rg-default-glob-string glob))
      (kadir/helm-rg-dwim query))))



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
