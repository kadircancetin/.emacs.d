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



(add-hook 'org-mode-hook (lambda ()
                           "Beautify Org Checkbox Symbol"
                           (push '("[ ]" .  "☐") prettify-symbols-alist)
                           (push '("[X]" . "☑" ) prettify-symbols-alist)
                           (push '("[-]" . "❍" ) prettify-symbols-alist)
                           (prettify-symbols-mode)))

(defface org-checkbox-done-text
  '((t (:foreground "#71696A" :strike-through t)))
  "Face for the text part of a checked org-mode checkbox.")

(font-lock-add-keywords
 'org-mode
 `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
    1 'org-checkbox-done-text prepend))
 'append)


(provide 'k_theme)
