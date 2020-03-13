(setq posframe-arghandler #'my-posframe-arghandler)
(defun my-posframe-arghandler (buffer-or-name arg-name value)
  (let ((info '(:internal-border-width 1 :internal-border-color "white")))
    (or (plist-get info arg-name) value)))


(require 'eglot)
(require 'thingatpt)

(defvar eglot-posframe-buffer " *my-posframe-buffer*")

(defvar-local last-post-command-position 0
  "Holds the cursor position from the last run of post-command-hooks.")

(defvar-local waiting-run nil "")
(defvar-local is-activated nil "")
(defvar-local last-word "" "")
(defvar-local last-buffer "" "")

(defun kadir/quickhelp-position(&rest rest)
  (if (and (< (car (window-absolute-pixel-position)) 200)
           (< (cdr (window-absolute-pixel-position)) 200))
      '(5 . 16005)
    '(5 . 5)))

(defun eglot-help-at-point-postframe()
  "Request \"hover\" information for the thing at point."
  (interactive)
  (posframe-hide eglot-posframe-buffer)

  (eglot--dbind
      ((Hover) contents range)
      (jsonrpc-request (eglot--current-server-or-lose) :textDocument/hover
                       (eglot--TextDocumentPositionParams))

    (let ((err nil))
      (when (seq-empty-p contents)
        (posframe-hide eglot-posframe-buffer)
        (setq err t))

      (when (not err)
        (let ((blurb (eglot--hover-info contents range))
              (sym (thing-at-point 'symbol)))
          (with-current-buffer (get-buffer-create eglot-posframe-buffer)
            (erase-buffer)
            (insert blurb)))

        (when (posframe-workable-p)
          (get-buffer-create eglot-posframe-buffer)
          (posframe-show eglot-posframe-buffer
                         :poshandler 'kadir/quickhelp-position
                         ;; :position '(0 . 0)
                         :internal-border-color "white"
                         ))))))

(defun do-stuff-if-moved-post-command ()
  (when (eglot-managed-p)
    (unless (equal (thing-at-point 'word) last-word)
      (setq last-word (thing-at-point 'word))

      (run-with-idle-timer 0.4 nil (lambda()
                                     (condition-case nil (eglot-help-at-point-postframe)
                                       (error nil)))))))

(defun kadir/tmp()
  (interactive)

  (if is-activated
      (progn
        (posframe-hide eglot-posframe-buffer)
        (message "kapat")
        (remove-hook 'post-command-hook 'do-stuff-if-moved-post-command)
        (setq is-activated nil))
    (message "aç")
    (add-hook 'post-command-hook 'do-stuff-if-moved-post-command)
    (setq is-activated t)
    )
  )
(kadir/tmp)


(defun my-keyboard-quit-advice (fn &rest args)
  (posframe-hide eglot-posframe-buffer))

(advice-add 'keyboard-quit :around #'my-keyboard-quit-advice)

(provide 'k_eglot_posframe_help)
