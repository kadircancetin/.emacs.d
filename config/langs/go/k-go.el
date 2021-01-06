(require 'use-package)

;; most part of the code is stolen from doom-emacs.
;; export GOPATH=~/work/go
;; go get -u github.com/motemen/gore/cmd/gore
;; go get -u github.com/stamblerre/gocode
;; go get -u golang.org/x/tools/cmd/godoc
;; go get -u golang.org/x/tools/cmd/goimports
;; go get -u golang.org/x/tools/cmd/gorename
;; go get -u golang.org/x/tools/cmd/guru
;; go get -u github.com/cweill/gotests/...
;; go get -u github.com/fatih/gomodifytags

;; (use-package go-eldoc)
;; (use-package go-guru)

;; (use-package go-tag)
;; (use-package go-gen-test)
;; (use-package company-go)
;; (use-package gorepl-mode
;;   :commands gorepl-run-load-current-file)

;; (use-package company-go
;;   :after go-mode
;;   :config
;;   (setq company-backends 'company-go)
;;   (setq company-go-show-annotation t))

;; (use-package flycheck-golangci-lint
;;   :hook (go-mode . flycheck-golangci-lint-setup))

(defun kadir/go-mode-hook()
  "K."
  (eglot)
  (yas-minor-mode 1)
  (yas-minor-mode-on)
  )

(use-package go-mode
  :commands (go-mode)
  :init
  (add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))
  :hook
  (go-mode . kadir/go-mode-hook)
  :config
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))


(defun kadir/go-run()
  (interactive)
  (save-buffer)
  (with-current-buffer "Aweshell: ~/.emacs.d/config/langs/go/"
    (let ((inhibit-read-only t))
      (erase-buffer)
      (eshell-send-input))
    (eshell-return-to-prompt)
    (insert "go run variables.go")
    (eshell-send-input)))

;; (define-key go-mode-map (kbd "ğ") 'kadir/go-run)

(provide 'k-go)
