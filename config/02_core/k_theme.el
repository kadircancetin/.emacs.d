(require 'use-package)

;; you can get colors from: https://paletton.com/#uid=7370K0kmls6cSGiiavGqRoEtFj-
;; base color: #2d9574

(defun fk/disable-all-themes ()
  ;; source https://github.com/KaratasFurkan/.emacs.d#disable-all-themes
  "Disable all active themes."
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme))
  )


(defadvice load-theme (before disable-themes-first activate)
  (fk/disable-all-themes))

(advice-add 'load-theme
            :around
            (lambda (fn theme &optional no-confirm no-enable)
              (funcall fn theme t)))

(defun kadir/darken-background ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Darken the background of the buffer."
  (interactive)
  (face-remap-add-relative 'default :background "#212026"))



(defvar kadir/default-font-size)

(setq display-fill-column-indicator-character ?|)
(setq-default fill-column 99)
(set-face-attribute 'fill-column-indicator nil
                    :background nil
                    :foreground "#212026")



(setq-default org-priority-faces '((?A . (:foreground "#DE4347" :weight 'bold :height 1.2))
                                   (?B . (:foreground "#E09644" :height 1.1))
                                   (?C . (:foreground "#2d9574" :height 1.0))))


(defun kadir/fix-some-colors(theme)
  (let ((custom--inhibit-theme-enable nil))
    (custom-theme-set-faces
     theme
     ;; diff-hl
     '(diff-hl-insert ((t (:background "#29422d" :foreground "#67b11d"))))
     '(diff-hl-change ((t (:background "#2d4252" :foreground "#4f97d7"))))
     '(diff-hl-delete ((t (:background "#512e31" :foreground "#f2241f"))))
     '(flyspell-duplicate ((t (:underline (:style wave :color "Darkorange4")
                                          :background nil
                                          :foreground nil))))

     '(flyspell-incorrect ((t (:underline (:style wave :color "Darkorange4")
                                          :background nil :foreground nil))))


     ;; ahs
     '(ahs-plugin-defalt-face       ((t (:underline t :weight bold :background nil :foreground nil))))
     '(ahs-definition-face          ((t (:underline t :weight bold :background nil :foreground nil))))
     '(ahs-face                     ((t (:underline t :weight bold :background nil :foreground nil))))
     '(ahs-plugin-whole-buffer-face ((t (:underline t :weight bold :background nil
                                                    :foreground nil))))

     ;; lsp
     '(highlight nil      ((t (:underline t :weight bold :background nil :foreground nil))))
     '(lsp-face-highlight ((t (:underline t :weight bold :background nil :foreground nil))))
     '(lsp-face-highlight ((t (:underline t :weight bold :background nil :foreground nil))))
     '(lsp-face-highlight ((t (:underline t :weight bold :background nil :foreground nil))))

     ;; stripe-highlight
     '(stripe-highlight ((t (:background "#333335")))))))

(if window-system
    (progn
      (disable-theme 'wombat)
      (global-hl-line-mode 1)        ; highlight your cusor line. don't lost.

      (straight-use-package 'spacemacs-theme)
      (use-package spacemacs-theme
        :init
        (setq-default spacemacs-theme-comment-italic t
                      spacemacs-theme-org-height nil)
        (load-theme 'spacemacs-dark t)
        (kadir/fix-some-colors 'spacemacs-dark)
        )

      ;; (use-package doom-themes
      ;;   :init
      ;;   (doom-themes-visual-bell-config))
      )
  (progn
    (global-hl-line-mode -1)))


(use-package stripe-buffer
  :config
  :hook ((org-mode . turn-on-stripe-table-mode)))


(defun kadir/light-theme()
  (interactive)
  (load-theme 'doom-one-light t)
  (kadir/fix-some-colors 'doom-one-light))

(defun kadir/doom-theme()
  (interactive)
  (load-theme 'doom-one t)
  (kadir/fix-some-colors 'doom-one))

(defun kadir/spacemacs-theme()
  (interactive)
  (load-theme 'spacemacs-dark t)
  (kadir/fix-some-colors 'spacemacs-dark))

(provide 'k_theme)
