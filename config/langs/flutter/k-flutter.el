(use-package dart-mode
  :init
  (setq lsp-dart-flutter-sdk-dir "/opt/flutter/")
  ;; (setq lsp-dart-server-command
  ;;       (list "/opt/flutter/bin/cache/dart-sdk/bin/dart"
  ;;             "/opt/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot"
  ;;             "--lsp"))
  ;; (setq lsp-dart-sdk-dir "/opt/flutter/bin/cache/dart-sdk/")
  :hook (dart-mode . lsp)
  )


(use-package lsp-dart)
(use-package flutter
  :hook (dart-mode . (lambda ()
                       (interactive)
                       (add-hook 'after-save-hook 'flutter-run-or-hot-reload nil t))))

;; (use-package lsp-treemacs)
;; (use-package lsp-ui)
;; (use-package flycheck)
;; (use-package company)
;; (use-package hover)


(provide 'k-flutter)
