(require 'dash)
(require 'company)

(defvar-local company-try-hard--last-index nil
  "The index of the last backend used by `company-try-hard'.")

;;;###autoload
;; company-complete
(defun company-try-hard ()
  "Offer completions from the first backend in `company-backends' that
offers candidates. If called again, use the next backend, and so on."
  (interactive)
  ;; If the last command wasn't `company-try-hard', reset the index so
  ;; we start at the first backend.
  (unless (eq last-command 'company-try-hard)
    (setq company-try-hard--last-index nil))
  ;; Close company if it's active, so `company-begin-backend' works.
  (company-abort)
  (catch 'break
    ;; Try every backend until we find one that returns some
    ;; candidates.
    (--map-indexed
     (catch 'continue
       ;; If we've tried this backend before, do nothing.
       (when (and (numberp company-try-hard--last-index)
                  (<= it-index company-try-hard--last-index))
         (throw 'continue nil))
       ;; Try this backend, ignoring a 'no completions here' error.
       (when (ignore-errors (company-begin-backend it))
         ;; We've found completions here, so remember this backend and
         ;; terminate for now.
         (message "company-try-harder: using %s" it)
         (setq company-try-hard--last-index it-index)
         (throw 'break nil)))
     company-backends)
    ;; If we haven't thrown 'break at this point, enable the user to
    ;; cycle through again.
    (setq company-try-hard--last-index nil)))

(global-set-key (kbd "C-z") #'company-try-hard)
(define-key company-active-map (kbd "C-z") #'company-try-hard)

(provide 'company-try-hard)
