(defvar kadir/python-auto-indent t
  "If non-nil python auto indentation on save.")

(if kadir/python-auto-indent
    (add-hook 'before-save-hook #'eglot-format-buffer)
  (remove-hook 'before-save-hook #'eglot-format-buffer nil)
  )


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
  (eglot-ensure)
  (setq eglot-ignored-server-capabilites '(:documentHighlightProvider
                                           :hoverProvider
                                           :signatureHelpProvider)))

(defun activate-venv-configure-python ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)
  (require 'projectile)
  (progn
    (let* ((pdir (projectile-project-root)) (pfile (concat pdir ".venv")))
      (if (file-exists-p pfile)
          (pyvenv-workon (with-temp-buffer
                           (insert-file-contents pfile)
                           (nth 0 (split-string (buffer-string))))))))
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



(provide 'k_python)
