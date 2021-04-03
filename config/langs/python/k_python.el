(require 'use-package)
(use-package projectile  :commands (projectile-project-root))



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


(use-package importmagic
  :ensure t
  :defer 4.5
  :init
  (defun kadir/import-magic-ac-kapat ()
    (interactive)
    (importmagic-mode 0)
    (importmagic-mode 1)
    (sleep-for 3)
    (importmagic-fix-symbol-at-point)
    (importmagic-mode 0)))



(defun kadir/enable-flycheck-flake8-python()
  (interactive)
  (require 'flycheck)
  (setq lsp-diagnostic-package :none)
  (setq lsp-diagnostics-provider :none)
  (setq flycheck-disabled-checkers '(python-mypy python-pylint))
  (flycheck-select-checker 'python-flake8))

(defun kadir/python-lsp-start()
  (interactive)
  (require 'lsp-pyright)
  (lsp)
  (setq-default company-backends '(company-capf)))


(defun kadir/activate-venv ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)

  (let* ((pdir (projectile-project-root))
         (pfile (concat pdir ".venv"))
         (ploc nil))
    (when (file-exists-p pfile)
      (setq ploc (with-temp-buffer
                   (insert-file-contents pfile)
                   (nth 0 (split-string (buffer-string)))))
      (setq lsp-pyright-venv-path ploc)
      (pyvenv-workon ploc))))


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




(defun fk/django-get-module ()
  ;; origin: https://github.com/KaratasFurkan/.emacs.d/
  "pony-get-module originally."
  (let* ((root (projectile-project-root))
         (path (file-name-sans-extension (or buffer-file-name (expand-file-name default-directory)))))
    (when (string-match (projectile-project-root) path)
      (let ((path-to-class (substring path (match-end 0))))
        (mapconcat 'identity (split-string path-to-class "/") ".")))))

(defun kadir/python-copy-import()
  (interactive)

  (require 'which-func)
  (require 's)

  (let* ((which-result (which-function))
         (dot-count (s-count-matches "\\." which-result))
         (class-or-function nil))

    (if (> dot-count 0)
        (setq class-or-function (car (seq-subseq (split-string which-result "\\.") 0 2)))
      (setq class-or-function which-result))

    (kill-new (concat "from " (fk/django-get-module) " import " class-or-function))))







(provide 'k_python)
