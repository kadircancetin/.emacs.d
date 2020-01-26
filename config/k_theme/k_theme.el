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



(defun kadir/ahs-set-colors()
  (set-face-attribute 'ahs-plugin-defalt-face nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'ahs-definition-face nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'ahs-face nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'ahs-plugin-whole-buffer-face nil
                      :underline t :weight 'bold :background nil :foreground nil)
  )


(use-package stripe-buffer
  :config
  (set-face-attribute 'stripe-highlight nil :background "#333335")

  :hook ((org-mode . turn-on-stripe-table-mode)
         (dired-mode-hook stripe-listify-buffer)))

(provide 'k_theme)
