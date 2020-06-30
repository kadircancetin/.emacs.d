;; you can get colors from: https://paletton.com/#uid=7370K0kmls6cSGiiavGqRoEtFj-
;; base color: #2d9574

(setq display-fill-column-indicator-character ?|)
(setq-default fill-column 99)
(set-face-attribute 'fill-column-indicator nil
                    :background nil
                    :foreground "#212026")
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)



(setq org-priority-faces '((?A . (:foreground "#DE4347" :weight 'bold :height 1.2))
                           (?B . (:foreground "#E09644" :height 1.1))
                           (?C . (:foreground "#2d9574" :height 1.0))))

(defun kadir/lsp-set-colors()
  (set-face-attribute 'highlight nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'lsp-face-highlight-read nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'lsp-face-highlight-write nil
                      :underline t :weight 'bold :background nil :foreground nil)
  (set-face-attribute 'lsp-face-highlight-textual nil
                      :underline t :weight 'bold :background nil :foreground nil)
  ;; (set-face-attribute 'rjsx-tag nil
  ;;                     :underline nil :weight 'normal :background nil :foreground nil)
  )



(if window-system
    (progn
      (disable-theme 'wombat)
      (global-hl-line-mode 1)        ; highlight your cusor line. don't lost.

      (use-package spacemacs-theme
        :init
        (setq-default spacemacs-theme-comment-italic t
                      spacemacs-theme-org-height nil)
        (load-theme 'spacemacs-dark t))

      ;; (use-package doom-themes
      ;;   :custom-face
      ;;   (cursor ((t (:background "BlanchedAlmond"))))
      ;;   :config
      ;;   ;; flashing mode-line on errors
      ;;   (doom-themes-visual-bell-config)
      ;;   ;; Corrects (and improves) org-mode's native fontification.
      ;;   (doom-themes-org-config)
      ;;   (load-theme 'doom-one t))
      )
  (progn
    (global-hl-line-mode -1)))


(use-package doom-modeline
  :defer 0.1
  :config
  (setq doom-modeline-bar-width         1
        doom-modeline-height            1
        doom-modeline-buffer-encoding   nil
        ;; doom-modeline-buffer-modification-icon t
        doom-modeline-vcs-max-length    20
        doom-modeline-icon              t
        ;; relative-to-project
        doom-modeline-buffer-file-name-style 'relative-from-project)

  (set-face-attribute 'mode-line nil :height kadir/default-font-size)
  (set-face-attribute 'mode-line-inactive nil :height kadir/default-font-size)
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
  :hook ((org-mode . turn-on-stripe-table-mode)))


;; (set-face-attribute 'avy-goto-char-timer-face  nil :background "blue" :foreground "white")
;; (set-face-attribute 'avy-lead-face  nil :background "yellow" :foreground "black")


(provide 'k_theme)
