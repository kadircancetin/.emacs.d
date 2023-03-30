(require 'use-package)

;; https://www.bytedude.com/setting-up-rust-support-in-emacs/
;; rustup component add rust-src rustfmt clippy rls rust-analysis
;; rustup component add rust-analyzer
;; pacman -S rust-analyzer

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :hook (rustic-mode . lsp-deferred)
  :config
  (setq
   rustic-lsp-client 'lsp
   ;; rustic-lsp-client 'eglot
   rustic-format-on-save t)


  (defun my-rustic-save-and-run ()
    (interactive)
    (save-buffer)
    (rustic-cargo-run))

  (defun my-rustic-save-and-test ()
    (interactive)
    (save-buffer)
    (rustic-cargo-test))


  (define-key rustic-mode-map (kbd "C-c C-c") #'my-rustic-save-and-run)
  (define-key rustic-mode-map (kbd "C-c C-t") #'my-rustic-save-and-test)


  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  )


(provide 'k_rust)
