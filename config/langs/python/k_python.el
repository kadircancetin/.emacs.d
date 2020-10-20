(require 'use-package)

(use-package projectile  :commands (projectile-project-root))

;;
(setq-default python-indent-guess-indent-offset-verbose nil)
(setq-default python-shell-interpreter "ipython"
              python-shell-interpreter-args "-i")



(defun kadir/configure-python ()
  (add-hook 'after-save-hook 'kadir/python-remove-unused-imports)
  (kadir/python-lsp-start))

(defun kadir/enable-flycheck-python()
  (interactive)
  (message "try flycheck")
  (require 'flycheck)
  (setq lsp-diagnostic-package :none)
  (setq lsp-diagnostics-provider :none)
  (setq flycheck-disabled-checkers '(python-mypy python-pylint))
  (flycheck-select-checker 'python-flake8))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python
  :straight (:type built-in)
  :bind (:map python-mode-map
              ;; ("C-c C-n" . flymake-goto-next-error)
              ;; ("C-c C-p" . flymake-goto-prev-error)
              ("C-c C-d" . lsp-describe-thing-at-point))
  :hook
  ((python-mode . kadir/enable-flycheck-python)
   (python-mode . activate-venv-configure-python)
   (python-mode . kadir/configure-python)
   ))


(use-package pyvenv)
(use-package lsp-pyright
  :init
  (setq-default lsp-pyright-auto-import-completions nil
                lsp-pyright-disable-organize-imports t)
  :straight (:host github :repo "emacs-lsp/lsp-pyright"))

(defun kadir/python-lsp-start()
  (interactive)
  (require 'lsp-pyright)
  (lsp)
  (setq-default company-backends '(company-capf)))


(defun kadir/lsp-jump-maybe()
  (interactive)
  (if lsp-mode
      (lsp-find-definition)
    nil))


(defun activate-venv-configure-python ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)

  (let* (
         (pdir (projectile-project-root))
         (pfile (concat pdir ".venv"))
         (ploc nil)
         )


    (when (file-exists-p pfile)
      (setq ploc (with-temp-buffer
                   (insert-file-contents pfile)
                   (nth 0 (split-string (buffer-string)))))
      (message "PLOC %s" ploc)
      (setq lsp-pyright-venv-path ploc)
      (pyvenv-workon ploc))))



(defun kadir/python-remove-unused-imports()
  "Removes unused imports with autoflake."
  (interactive)

  (let ((file (shell-quote-argument (buffer-file-name))))

    (when (not (and (executable-find "autoflake") (executable-find "flake8")))
      (when (y-or-n-p
             (format "Can't find autoflake or flake8. Do you want to install on %s"
                     (executable-find "python")))
        (shell-command  "pip install autoflake flake8")))

    (let* ((process (start-process "find unused imports" nil
                                   "bash" "-c" (format "flake8 --select F401 %s | wc -l" (buffer-file-name))))
           (filter (lambda (process output)
                     (unless (string= output "0\n")
                       (when (y-or-n-p "There are unused imports. Do you want to remove them?")
                         (shell-command (format "autoflake --remove-all-unused-imports -i %s" (buffer-file-name)))
                         (revert-buffer t t t))))))
      (set-process-filter process filter))))



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
