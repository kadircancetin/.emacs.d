;; pip install python-language-server[all]; pip uninstall autopep8 yapf; pip install pyls-isort pyls-black;

;; TODO: flycheck otomatik aktif oluyor
;; lazy load for linter
(setq python-indent-guess-indent-offset-verbose nil)

(use-package projectile  :commands (projectile-project-root))


(defvar kadir/python-auto-indent t
  "If non-nil python auto indentation on save.")

(defvar kadir/python-lsp-eglot 'eglot
  "If not `eglot' emacs use `lsp-mode' for language server.")

(if kadir/python-auto-indent
    (add-hook 'before-save-hook #'eglot-format-buffer)
  (remove-hook 'before-save-hook #'eglot-format-buffer nil))


(use-package python
  :init
  (use-package pyvenv)
  (add-hook 'python-mode-hook 'auto-highlight-symbol-mode)
  (add-hook 'python-mode-hook 'activate-venv-configure-python)
  :bind (:map python-mode-map
              ("C-c C-n" . flymake-goto-next-error)
              ("C-c C-p" . flymake-goto-prev-error)
              ("M-ı" . eglot-format-buffer)
                                        ;  M-ı used for indet all
                                        ;  the buffer. But in
                                        ;  python I use language
                                        ;  server for that.
              ("M-." . xref-find-definitions)))

(defun kadir/configure-python ()
  (if (eq kadir/python-lsp-eglot 'eglot)
      (progn
        (eglot-ensure)
        (setq-default eglot-ignored-server-capabilites '(:documentHighlightProvider
                                                         :hoverProvider
                                                         :signatureHelpProvider))

        (add-hook 'eglot-managed-mode-hook
                  (lambda ()
                    (interactive)
                    (message "mk")
                    (setq company-backends
                          '(;; company-bbdb
                            ;; company-semantic
                            ;; company-clang
                            ;; company-xcode
                            ;; company-cmake
                            company-capf
                            company-files
                            (company-dabbrev-code company-gtags company-etags
                                                  company-keywords)
                            ;; company-oddmuse
                            ;; company-tabnine
                            ;; company-yasnippet
                            company-dabbrev))
                    (prin1 company-backends)
                    )))

    (lsp)
    (remove-hook 'python-mode-hook #'auto-highlight-symbol-mode)))

(defun activate-venv-configure-python ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)
  (let* ((pdir (projectile-project-root)) (pfile (concat pdir ".venv")))
    (if (file-exists-p pfile)
        (pyvenv-workon (with-temp-buffer
                         (insert-file-contents pfile)
                         (nth 0 (split-string (buffer-string)))))))
  (kadir/configure-python))


(defun kadir/python-toggle-auto-format ()
  "Auto format while saveing from lsp mode is activate or deactivate."
  (interactive)
  (if kadir/python-auto-indent
      (progn
        (remove-hook 'before-save-hook #'eglot-format-buffer nil)
        (setq kadir/python-auto-indent nil)
        (message "Disabled: Eglot indent")
        )
    (setq kadir/python-auto-indent t)
    (add-hook 'before-save-hook #'eglot-format-buffer)
    (message "Enabled: Eglot indent")))


(defun kadir/django/find-models()
  (interactive)
  (let ((helm-rg-default-glob-string "models.py"))
    (helm-rg "class model " )))

(defun kadir/django/find-urls()
  (interactive)
  ;; (find-file (concat (projectile-project-root)
  ;;                    (nth (-(length (split-string
  ;;                                    (projectile-project-root) "/"))
  ;;                           2)
  ;;                         (split-string (projectile-project-root) "/"))
  ;;                    "/urls.py"
  ;;                    ))
  (let ((helm-rg-default-glob-string "urls.py"))
    (helm-rg "" )))

(defun kadir/django/find-settings()
  (interactive)
  (let ((helm-rg-default-glob-string "settings.py"))
    (helm-rg "")))


(provide 'k_python)
