(require 'use-package)
(use-package projectile  :commands (projectile-project-root))



(add-hook 'python-mode-hook  (lambda () (require 'tree-sitter-langs) (tree-sitter-hl-mode)))
(add-hook 'python-mode-hook  (lambda () (rainbow-delimiters-mode-disable)))




(setq-default python-indent-guess-indent-offset-verbose nil)
(setq-default python-shell-interpreter "ipython"
              python-shell-interpreter-args "-i")


(use-package python
  :straight (:type built-in)
  :bind (:map python-mode-map
              ("C-c C-d" . lsp-describe-thing-at-point)
              ("C-c C-f" . kadir/import-magic-ac-kapat))
  :hook
  ((python-mode . kadir/python-hook)))



(defun kadir/python-hook()
  (kadir/activate-venv)
  ;;;;;;;;;;;;;;;;;;;;;;;;;

  (kadir/python-lsp-start)

  ;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; (require 'company-tabnine)
  ;; (setq company-backends '(company-tabnine))

  ;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; (use-package lsp-jedi)
  ;; (lsp)
  ;; (setq lsp-jedi-python-library-directories nil)
  ;; (require 'lsp-jedi)
  ;; (add-to-list 'lsp-disabled-clients 'pyls)
  ;; (add-to-list 'lsp-enabled-clients 'jedi)


  ;;;;;;;;;;;;;;;;;;;;;;;;;
  (kadir/enable-flycheck-flake8-python)
  (add-hook 'after-save-hook 'kadir/python-remove-unused-imports))


(use-package pyvenv)
(use-package lsp-pyright
  :init
  (setq-default lsp-pyright-auto-import-completions nil
                lsp-pyright-disable-organize-imports t)

  (setq lsp-pyright-stub-path "/home/kadir/stubs/typings/")
  :straight (:host github :repo "emacs-lsp/lsp-pyright"))


;; (use-package importmagic
;;   :init
;;   (defun kadir/import-magic-ac-kapat ()
;;     (interactive)
;;     (importmagic-mode 0)
;;     (importmagic-mode 1)
;;     (sleep-for 3)
;;     (importmagic-fix-symbol-at-point)
;;     (importmagic-mode 0)))



(defun kadir/enable-flycheck-flake8-python()
  (interactive)
  (require 'flycheck)
  (setq lsp-diagnostic-package :none) ;; lsp kapa
  (setq lsp-diagnostics-provider :none) ;; lsp kapa
  (setq flycheck-disabled-checkers '(python-mypy python-pylint))
  (flycheck-select-checker 'python-flake8)

  ;; (setq flycheck-checkers '( python-flake8 python-pycompile))

  ;; (flycheck-add-next-checker 'lsp 'python-flake8) ;; lsp ac
  )

(defun kadir/python-lsp-start()
  (interactive)
  (require 'lsp-pyright)
  (lsp-deferred))


(defun kadir/activate-venv ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)
  (require 'pyvenv)
  (require 'lsp)
  (let* ((pdir (projectile-project-root))
         (pfile (concat pdir ".venv"))
         (ploc nil))
    (when (file-exists-p pfile)
      (setq ploc (with-temp-buffer
                   (insert-file-contents pfile)
                   (nth 0 (split-string (buffer-string)))))

      (pyvenv-workon ploc)
      (setq lsp-pyright-venv-path (concat (pyvenv-workon-home) "/" ploc "/")))))


(setq kadir/python-auto-remove-unused nil)
(defun kadir/python-remove-unused-imports()
  "Removes unused imports with autoflake."
  (interactive)
  (when kadir/python-auto-remove-unused
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
        (set-process-filter process filter)))))

(defun kadir/directly-python-remove-unused-import()
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
    (helm-rg "^class model " )))

(defun kadir/django/find-views()
  (interactive)
  (let ((helm-rg-default-glob-string "views.py"))
    (helm-rg "^class " )))


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



(defun fk/django-get-module (devider)
  ;; origin: https://github.com/KaratasFurkan/.emacs.d/
  "pony-get-module originally."
  (let* ((root (projectile-project-root))
         (path (file-name-sans-extension (or buffer-file-name (expand-file-name default-directory)))))
    (when (string-match (projectile-project-root) path)
      (let ((path-to-class (substring path (match-end 0))))
        (mapconcat 'identity (split-string path-to-class "/") devider)))))

(defun kadir/class-or-function()
  (require 'which-func)
  (require 's)

  (let* ((which-result (which-function))
         (dot-count (s-count-matches "\\." which-result))
         (class-or-function nil))

    (if (> dot-count 0)
        (setq class-or-function (car (seq-subseq (split-string which-result "\\.") 0 2)))
      (setq class-or-function which-result))

    class-or-function))

(defun kadir/python-copy-import()
  (interactive)
  (require 'which-func)
  (mwim-beginning-of-code)
  (kill-new (concat "from " (fk/django-get-module ".") " import " (kadir/class-or-function))))

(defun kadir/python-copy-pytest()
  (interactive)
  (require 'which-func)
  (mwim-beginning-of-code)
  (kill-new (concat "pytest " (fk/django-get-module "/") ".py::" (s-replace "." "::" (which-function)) " -s")))

(defun kadir/python-copy-mock()
  (interactive)
  (require 'which-func)
  (mwim-beginning-of-code)
  (kill-new (concat (fk/django-get-module ".") "." (which-function))))



(defun kadir/python-class-search ()
  (interactive)
  (kadir/helm-rg-dwim-with-glob "*.py" "^class "))




(defun kadir/fast-python()
  (interactive)

  (setq font-lock-maximum-decoration 2)
  (revert-buffer)
  (k-colors-mode 0)
  (flycheck-mode 0)
  (wucuo-mode 0)
  (auto-highlight-symbol-mode 1)
  (highlight-symbol-nav-mode 1)
  (setq font-lock-maximum-decoration t))

(defun kadir/normal-python()
  (interactive)
  (setq font-lock-maximum-decoration t)
  (revert-buffer)
  (k-colors-mode 1)
  (wucuo-mode 1)
  (flycheck-mode 1))




(provide 'k_python)
