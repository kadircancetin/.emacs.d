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
     '(ahs-plugin-default-face       ((t (:underline t :weight bold :background nil :foreground nil))))
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
        ))
  (progn
    (global-hl-line-mode -1)))



(use-package mood-line
  ;; TODO: s-1 s-2
  ;; TODO: new created file
  ;; TODO: is line number mode activated?
  :init
  (mood-line-mode)
  (remove-hook 'flycheck-status-changed-functions #'mood-line--update-flycheck-segment)
  (remove-hook 'flycheck-mode-hook #'mood-line--update-flycheck-segment)

  :config
  (defun kadir/mood-line-segment-buffer-name()
    (require 's)

    (let ((is-file (buffer-file-name (current-buffer))))

      (if (not is-file)
          (propertize (format-mode-line "%b") 'face 'mood-line-buffer-name)

        (progn
          (let* ((p-root (projectile-project-root))
                 (full-path (buffer-file-name (current-buffer)))
                 (project-name (car (last (s-split "/" p-root 'omit-nulls))))
                 (relative-path (s-chop-prefix p-root  full-path))
                 (file-splitted (s-split "/" relative-path))
                 (file-name (concat (nth (- (length file-splitted) 1) file-splitted)))
                 (folder-name (s-chop-suffix file-name relative-path)))

            (concat
             (propertize folder-name 'face 'mood-line-status-neutral)
             (propertize file-name 'face 'mood-line-major-mode)
             " - "
             (propertize project-name 'face 'mood-line-status-info)
             " "))))))

  (defun kadir/mood-line-segment-modified ()
    "Displays a color-coded buffer modification/read-only indicator in the mode-line."
    (if (not (string-match-p "\\*.*\\*" (buffer-name)))
        (if (buffer-modified-p)
            (propertize " ** " 'face '(:weight bold :background "red" :foreground "black"))
          (if (and buffer-read-only (buffer-file-name))
              (propertize "■ " 'face 'mood-line-unimportant)
            "  "))
      "  "))


  (defun kadir-performance-mode-line()
    (interactive)

    (make-variable-buffer-local 'local-kadir-mode-line-calculated)
    (make-variable-buffer-local 'local-kadir-mode-line-format)

    (setq local-kadir-mode-line-calculated nil)
    (setq local-kadir-mode-line-format "calculaing...")

    (defun kadir/full-mood-line()
      (when (not local-kadir-mode-line-calculated)
        (setq local-kadir-mode-line-calculated t)
        (setq local-kadir-mode-line-format
              (mood-line--format
               ;; Left
               (format-mode-line
                '(" "
                  (:eval (kadir/mood-line-segment-modified))
                  (:eval (kadir/mood-line-segment-buffer-name))
                  (:eval (mood-line-segment-position))
                  (:eval (mood-line-segment-multiple-cursors))))

               ;; Right
               (format-mode-line
                '(;; (:eval (mood-line-segment-vc))
                  (:eval (mood-line-segment-major-mode))
                  " ")))))

      local-kadir-mode-line-format)
    (setq-default mode-line-format '((:eval (kadir/full-mood-line))))

    (defun kadir-force-update-mode-line()
      (setq local-kadir-mode-line-calculated nil)
      (force-mode-line-update))

    (defun kadir-soft-update-mode-line()
      (setq local-kadir-mode-line-calculated nil))


    (defun kadir-soft-update-mode-line-all-buffers()
      (dolist (buf (mapcar (lambda (wind) (window-buffer wind)) (window-list)))
        (with-current-buffer buf
          (kadir-soft-update-mode-line)))
      (force-mode-line-update t)  ;; force update all
      )


    ;; (kadir-force-update-mode-line)
    )


  (run-with-idle-timer 0.5 t 'kadir-soft-update-mode-line-all-buffers)

  (defun kadir-soft-update-mode-line-advice (func &rest args)
    (kadir-soft-update-mode-line)
    (apply func args))

  ;; TODO: not open on helm
  (add-hook 'change-major-mode-hook 'kadir-performance-mode-line)

  (add-hook 'after-save-hook 'kadir-force-update-mode-line)

  (advice-add #'undo-tree-undo :around #'kadir-soft-update-mode-line-advice)
  (advice-add #'backward-delete-char-untabify :around #'kadir-soft-update-mode-line-advice)
  (advice-add #'delete-char :around #'kadir-soft-update-mode-line-advice)
  (advice-add #'self-insert-command :around #'kadir-soft-update-mode-line-advice))



(use-package stripe-buffer
  :config
  :hook ((org-mode . turn-on-stripe-table-mode)))


(defun kadir/doom-light-theme()
  (interactive)
  (use-package doom-themes)
  (load-theme 'doom-one-light t)
  (kadir/fix-some-colors 'doom-one-light))

(defun kadir/spacemacs-light-theme()
  (interactive)
  (use-package doom-themes)
  (load-theme 'spacemacs-light t)
  (kadir/fix-some-colors 'spacemacs-light))

(defun kadir/solarized-light-theme()
  (interactive)
  (use-package doom-themes)
  (load-theme 'doom-solarized-light t)
  (kadir/fix-some-colors 'doom-solarized-light))


(defun kadir/doom-theme()
  (interactive)
  (use-package doom-themes)
  (load-theme 'doom-one t)
  (kadir/fix-some-colors 'doom-one))

(defun kadir/spacemacs-theme()
  (interactive)
  (load-theme 'spacemacs-dark t)
  (kadir/fix-some-colors 'spacemacs-dark))



(provide 'k_theme)
