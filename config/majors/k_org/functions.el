(defun kadir/org-screenshot ()
  ;; fork from: https://delta.re/org-screenshot/
  "Take a screenshot into a time stamped unique-named file in the
    same directory as the org-buffer and insert a link to this file."
  (interactive)
  (when (eq major-mode 'org-mode)
    (suspend-frame)
    (org-display-inline-images)
    (setq filename
          (concat
           (make-temp-name
            (concat (file-name-nondirectory (buffer-file-name))
                    "_imgs/"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
    (unless (file-exists-p (file-name-directory filename))
      (make-directory (file-name-directory filename)))
                                        ; take screenshot
    (if (eq system-type 'darwin)
        (call-process "screencapture" nil nil nil "-i" filename))
    (if (eq system-type 'gnu/linux)
        (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
    (if (file-exists-p filename)
        (insert (concat "[[file:" filename "]]")))
    (org-remove-inline-images)
    ;; (org-display-inline-images)
    (other-frame 0)))


(defun kadir/beatiful-org-todo()
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
   'append))

(defun kadir/org-mode-hooks()
  ;; TODO: when change the kadir global think
  (global-hl-todo-mode 0)
  (global-diff-hl-mode 0)
  (diff-hl-flydiff-mode 0)
  (flycheck-mode 0))
