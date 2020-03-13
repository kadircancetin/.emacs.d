(require 'eglot)
(require 'thingatpt)
(require 'posframe)


(defvar eglot-posframe-buffer " *my-posframe-buffer*")

(defvar-local eglot-posframe--waiting-qoue-empty-p nil "")
(defvar-local eglot-posframe--active-p nil "")
(defvar-local eglot-posframe--last-word "" "")


(defun eglot-posframe--frame-position(&rest rest)
  (if (and (< (car (window-absolute-pixel-position)) 200)
           (< (cdr (window-absolute-pixel-position)) 200))
      '(5 . 16005)
    '(5 . 5)))

(defun eglot-posframe--activate ()
  (when (and (eglot-managed-p)
             (not (equal (thing-at-point 'word) eglot-posframe--last-word))
             (not eglot-posframe--waiting-qoue-empty-p))
    (setq eglot-posframe--last-word (thing-at-point 'word))
    (setq eglot-posframe--waiting-qoue-empty-p t)
    (run-with-idle-timer 0.4 nil (lambda()
                                   (condition-case nil (eglot-posframe-help-at-point)
                                     (error nil))))))



(defun eglot-posframe-help-at-point()
  ""
  (interactive)
  (setq eglot-posframe--waiting-qoue-empty-p nil)
  (posframe-hide eglot-posframe-buffer)

  (eglot--dbind
      ((Hover) contents range)
      (jsonrpc-request (eglot--current-server-or-lose) :textDocument/hover
                       (eglot--TextDocumentPositionParams))
    
    (when (seq-empty-p contents) (posframe-hide eglot-posframe-buffer))

    
    (let ((blurb (eglot--hover-info contents range))
          (sym (thing-at-point 'symbol)))
      (with-current-buffer (get-buffer-create eglot-posframe-buffer)
        (erase-buffer)
        (insert blurb)))

    (when (posframe-workable-p)
      (get-buffer-create eglot-posframe-buffer)
      (posframe-show eglot-posframe-buffer
                     :poshandler 'eglot-posframe--frame-position
                     :internal-border-color "white"
                     :height 20))))

(defun eglot-posframe-activate()
  (interactive)
  (if eglot-posframe--active-p
      (progn
        (posframe-hide eglot-posframe-buffer)
        (message "kapat")
        (remove-hook 'post-command-hook 'eglot-posframe--activate)
        (setq eglot-posframe--active-p nil))
    (message "aç")
    (add-hook 'post-command-hook 'eglot-posframe--activate)
    (setq eglot-posframe--active-p t)))


(defun eglot-posframe-close-help (&rest args)
  (interactive)
  (posframe-hide eglot-posframe-buffer))




(advice-add 'keyboard-quit :before #'eglot-posframe-close-help)

(provide 'k_eglot_posframe_help)
