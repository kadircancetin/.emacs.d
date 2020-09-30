(require 'use-package)

(use-package format-all)

(use-package python-black
  :defer 0.5
  :custom (blacken-line-length 119))

(use-package py-isort)

(setq k (current-window-configuration))
(defun format-all--save-line-number (thunk)
  "Internal helper function to run THUNK and go back to the same line."

  (let ((old-line-number (line-number-at-pos))
        (old-column (current-column)))
    (funcall thunk)
    (goto-char (point-min))
    (forward-line (1- old-line-number))
    (let ((line-length (- (point-at-eol) (point-at-bol))))
      (goto-char (+ (point) (min old-column line-length)))

      ))

  )

(defun kadir/format-buffer ()
  (interactive)
  (cond
   ((eq major-mode 'web-mode) (indent-region (point-min) (point-max)))
   ((eq major-mode 'python-mode) (python-black)(py-isort-buffer))
   ((eq major-mode 'go-mode) (gofmt))
   ((eq major-mode 'sass-mode) (css-mode) (format-all-buffer)(sass-mode))

   (t (format-all-buffer))))


(define-minor-mode k-auto-format
  "Some cool color features for programing."
  :lighter "format"
  :global t
  (if k-auto-format
      (add-hook 'before-save-hook
                'kadir/format-buffer)
    (remove-hook 'before-save-hook
                 'kadir/format-buffer)))

(provide 'mode-mode)

(provide 'k-format)
