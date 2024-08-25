(use-package dart-mode
  ;; Optional
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :init
  (setq flutter-sdk-path "/usr/bin/flutter")
  )

(use-package lsp-dart)

(add-hook 'dart-mode-hook 'lsp)
