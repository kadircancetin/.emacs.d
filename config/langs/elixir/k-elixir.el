(use-package elixir-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.elixir2\\'" . elixir-mode))

  ;; for lsp installation and add exec-path
  ;; git clone https://github.com/elixir-lsp/elixir-ls.git
  ;; cd elixir-ls (that you just cloned)
  ;; mix deps.get
  ;; mix elixir_ls.release
  (add-to-list 'exec-path "/home/kadir/elixir-ls/release/")

  :hook
  (elixir-mode . lsp-deferred))

(provide 'k-elixir)
