(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr"))


(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.01))
