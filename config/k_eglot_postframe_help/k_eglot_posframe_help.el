(require 'eglot)
(require 'thingatpt)
(require 'posframe)


(defvar eglot-posframe-buffer " *my-posframe-buffer*")
(defvar eglot-posframe--last-buffer nil "")
(defvar eglot-posframe--posframe nil "")
(defvar eglot-posframe--idle-timer 0.2 "")

 (defvar-local eglot-posframe--waiting-qoue-empty-p nil "")
(defvar-local eglot-posframe--active-p nil "")
(defvar-local eglot-posframe--last-word "" "")


(defun eglot-posframe--frame-position(&rest rest)
  (if (and (< (cdr (window-absolute-pixel-position)) 200))
      (let ((ret '(0 . 0)))
        (setcar ret (+ (car (window-absolute-pixel-position)) 0))
        (setcdr ret (* (cdr (window-absolute-pixel-position)) 2))
        ret)
    '(5 . 5)))

(defun eglot-posframe--postcommand-hook ()
  (when (and (eglot-managed-p)
             (not (equal (thing-at-point 'word) eglot-posframe--last-word))
             (not eglot-posframe--waiting-qoue-empty-p))
    (setq eglot-posframe--last-word (thing-at-point 'word)
          eglot-posframe--waiting-qoue-empty-p t)

    (run-with-idle-timer eglot-posframe--idle-timer nil (lambda()
                                                          (condition-case nil (eglot-posframe-help-at-point)
                                                            (error nil)))))
  ;;
  (unless (and (eq eglot-posframe--last-buffer (current-buffer))
               (not (eq (current-buffer) (get-buffer eglot-posframe-buffer))))
    (setq eglot-posframe--last-buffer (current-buffer))
    (eglot-posframe-close-help)))


(defun eglot-posframe-help-at-point()
  ""
  (interactive)

  (unless eglot-posframe--active-p
    (eglot--error ""))
  
  (setq eglot-posframe--waiting-qoue-empty-p nil)
  (posframe-hide eglot-posframe-buffer)

  (eglot--dbind
      ((Hover) contents range)
      (jsonrpc-request (eglot--current-server-or-lose) :textDocument/hover
                       (eglot--TextDocumentPositionParams))
    
    (when (seq-empty-p contents)
      (posframe-hide eglot-posframe-buffer)
      (eglot--error "No hover info here"))
    
    (let ((blurb (eglot--hover-info contents range))
          (sym (thing-at-point 'symbol)))
      (with-current-buffer (get-buffer-create eglot-posframe-buffer)
        (erase-buffer)
        (insert blurb)))

    (when (posframe-workable-p)
      (get-buffer-create eglot-posframe-buffer)
      (setq eglot-posframe--posframe
            (posframe-show eglot-posframe-buffer
                           :poshandler 'eglot-posframe--frame-position
                           :internal-border-color "white"
                           :internal-border-width 3
                           :height 20)))))

(defun eglot-posframe-activate()
  (interactive)
  (if eglot-posframe--active-p
      (progn
        (posframe-hide eglot-posframe-buffer)
        (message "kapat")
        (remove-hook 'post-command-hook 'eglot-posframe--postcommand-hook)
        (setq eglot-posframe--active-p nil))
    (message "aç")
    (add-hook 'post-command-hook 'eglot-posframe--postcommand-hook)
    (setq eglot-posframe--active-p t)))


(defun eglot-posframe-close-help (&rest args)
  (interactive)
  (posframe-hide eglot-posframe-buffer))


(advice-add 'keyboard-quit :before #'eglot-posframe-close-help)

(provide 'k_eglot_posframe_help)



