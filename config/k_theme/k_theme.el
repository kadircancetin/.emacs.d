(set-face-attribute 'highlight nil
                    :underline t :weight 'bold :background nil :foreground nil)
(if window-system
    (progn (use-package spacemacs-theme
             :init
             (setq spacemacs-theme-comment-italic t
                   spacemacs-theme-org-height nil)
             (disable-theme 'wombat)
             (global-hl-line-mode 1)        ; highlight your cusor line. don't lost.
             (load-theme 'spacemacs-dark t)))
  (progn
    (global-hl-line-mode -1)))



;;;;;;;;;;;;;;;;;;;

(use-package doom-modeline
  :defer 0.1
  :config
  (setq doom-modeline-bar-width       1
        doom-modeline-height            1
        doom-modeline-buffer-encoding   nil
        ;; doom-modeline-buffer-modification-icon t
        doom-modeline-vcs-max-length    20
        doom-modeline-icon              t
        ;; relative-to-project
        doom-modeline-buffer-file-name-style 'relative-from-project)
  (set-face-attribute 'mode-line nil :height 80)
  (set-face-attribute 'mode-line-inactive nil :height 80)
  (doom-modeline-mode 1))


(provide 'k_theme)
