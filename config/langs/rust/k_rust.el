(require 'use-package)

;; https://www.bytedude.com/setting-up-rust-support-in-emacs/
;; rustup component add rust-src rustfmt clippy rls rust-analysis
;; rustup component add rust-analyzer
;; pacman -S rust-analyzer

(use-package rustic
  :config
  (setq
   rustic-lsp-client 'lsp
   rustic-format-on-save t
   )
  )


(provide 'k_rust)
