(require 'use-package)
;; pip install python-language-server[all]; pip uninstall autopep8 yapf; pip install pyls-isort pyls-black;
;; ((nil (eglot-workspace-configuration . ((pyls . ((configurationSources . ["flake8"])))))))


;; (
;;  (nil (eglot-workspace-configuration . ((pyls :configurationSources ["flake8"]
;;                                               :plugins (
;;                                                         :jedi_completion (:enabled nil)
;;                                                         :mccabe (:threshold 8)
;;                                                         )))))
;;  (nil (flycheck-flake8rc . ".flake8"))
;;  )



;; lazy load for linter
(setq-default python-indent-guess-indent-offset-verbose nil)
(setq-default python-shell-interpreter "ipython"
              python-shell-interpreter-args "-i")

(use-package projectile  :commands (projectile-project-root))


(defvar kadir/python-auto-indent t
  "If non-nil python auto indentation on save.")

(defvar kadir/python-lsp-eglot 'lsp-mode
  "If not `eglot' emacs use `lsp-mode' for language server.")

;; (if kadir/python-auto-indent
;;     (add-hook 'before-save-hook #'eglot-format-buffer)
;;   (remove-hook 'before-save-hook #'eglot-format-buffer nil))


(defun kadir/configure-python ()
  (if (eq kadir/python-lsp-eglot 'eglot)
      (kadir/python-eglot-start)
    (kadir/python-lsp-start)))

(defun kadir/enable-flycheck-poython()
  (interactive)
  (message "try flycheck")
  (require 'flycheck)
  (setq lsp-diagnostic-package :none)
  (setq flycheck-disabled-checkers '(python-mypy python-pylint))
  (flycheck-select-checker 'python-flake8))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python
  :straight (:type built-in)
  :bind (:map python-mode-map
              ;; ("C-c C-n" . flymake-goto-next-error)
              ;; ("C-c C-p" . flymake-goto-prev-error)
              ("C-c C-n" . flycheck-next-error)
              ("C-c C-p" . flycheck-previous-error)
              ("C-c C-d" . lsp-describe-thing-at-point))
  :hook
  ((python-mode . activate-venv-configure-python)
   (python-mode . kadir/configure-python)
   (python-mode . kadir/enable-flycheck-poython)))


(use-package pyvenv)
;; (use-package company-jedi)
;; (use-package jedi-core
;;   :init
;;   (setq-default jedi:complete-on-dot t
;;                 jedi:install-imenu t  ;; TODO: helm semantic or imenu
;;                 ))
(use-package lsp-pyright
  :init
  (setq-default lsp-pyright-auto-import-completions nil
                lsp-pyright-disable-organize-imports t
                )

  :straight (:host github :repo "emacs-lsp/lsp-pyright"))

(defun kadir/python-lsp-start()
  (require 'lsp-pyright)
  (lsp)
  (setq-default company-backends '(company-capf)))

(defun kadir/python-eglot-start()
  (interactive)
  ;; (require 'company-jedi)
  (eglot-ensure)
  (setq-default eglot-ignored-server-capabilites '(:documentHighlightProvider
                                                   :hoverProvider
                                                   ;; :signatureHelpProvider
                                                   ))


  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (interactive)
              (setq company-backends
                    '(;; company-bbdb
                      ;; company-semantic
                      ;; company-clang
                      ;; company-xcode
                      ;; company-cmake
                      company-capf ;; NOTE: remove the eglot defaults
                      ;; company-jedi    ;; NOTE: instead of eglot defaulats
                      company-files
                      (company-dabbrev-code company-gtags company-etags
                                            company-keywords)
                      ;; company-oddmuse
                      ;; company-tabnine
                      ;; company-yasnippet
                      company-dabbrev))
              (prin1 company-backends))))


(defun kadir/lsp-jump-maybe()
  (interactive)
  (if lsp-mode
      (lsp-find-definition)
    nil))

(use-package smart-jump
  :defer 1
  :init  (setq smart-jump-default-mode-list 'python-mode)
  :config
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'kadir/lsp-jump-maybe
                       :pop-fn 'xref-pop-marker-stack
                       :refs-fn 'xref-find-references
                       :should-jump nil
                       :heuristic 'error
                       :async nil
                       :order 1)
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'xref-find-definitions
                       :pop-fn 'xref-pop-marker-stack
                       :refs-fn 'xref-find-references
                       :should-jump t
                       :heuristic 'error
                       :async nil
                       :order 1)
  ;; (smart-jump-register :modes 'python-mode
  ;;                      :jump-fn 'jedi:goto-definition
  ;;                      :pop-fn 'jedi:goto-definition-pop-marker
  ;;                      :refs-fn 'xref-find-references
  ;;                      :should-jump nil
  ;;                      :heuristic 'error
  ;;                      :async nil
  ;;                      :order 3)
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'dumb-jump-go
                       :pop-fn 'xref-pop-marker-stack
                       :should-jump t
                       :heuristic 'point
                       :async nil
                       :order 4))

(use-package pony-mode)

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




(defun kadir/python--eglot-indent-toggle()
  (if kadir/python-auto-indent
      (progn
        (remove-hook 'before-save-hook #'eglot-format-buffer nil)
        (setq kadir/python-auto-indent nil)
        (message "Disabled: Eglot indent"))
    (setq kadir/python-auto-indent t)
    (add-hook 'before-save-hook #'eglot-format-buffer)
    (message "Enabled: Eglot indent"))
  )
(defun kadir/python--lsp-indent-toggle()
  (if kadir/python-auto-indent
      (progn
        (remove-hook 'before-save-hook #'lsp-format-buffer nil)
        (setq kadir/python-auto-indent nil)
        (message "Disabled: Lsp indent"))
    (setq kadir/python-auto-indent t)
    (add-hook 'before-save-hook #'lsp-format-buffer)
    (message "Enabled: Lsp indent"))
  )

(defun kadir/python-toggle-auto-format ()
  "Auto format while saveing from lsp mode is activate or deactivate."
  (interactive)
  (if (eq kadir/python-lsp-eglot 'eglot)
      (kadir/python--eglot-indent-toggle)
    (kadir/python--lsp-indent-toggle)))


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
