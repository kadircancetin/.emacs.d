;;;; Customization

(setq easy-side-vertical-side-width 0.22)
(setq easy-side-horizontal-side-width 0.2)
(setq easy-side-no-other-window t)
(setq easy-side-no-delete-other-windows t)
(setq easy-side-side-window-background-color "#212026")

(defun easy-side--push-buffer-to (side)
  "Displays the current buffer in a side window on the given side,
creating the window if it doesn't exist, or
displaying the buffer in the next available slot if it
does. Argument `SIDE` can be defined with values `'left`,
`'right`, `'top` or `'bottom`.

The function sets the width and height of the side window based
on the values of `easy-side-vertical-side-width` and
`easy-side-horizontal-side-width` variables.

The function returns `nil`."
  (let ((width-height-param nil)
        (lock-param nil)
        (window-params nil)
        (created-window nil))

    (if (or (eq side 'left) (eq side 'right))
        (progn
          (setq width-height-param `(window-width . ,easy-side-vertical-side-width))
          (setq lock-param '(preserve-size . (t . nil))))
      (setq width-height-param `(window-height . ,easy-side-horizontal-side-width))
      (setq lock-param '(preserve-size . (nil . t))))

    (setq window-params `(window-parameters . ((no-other-window . ,easy-side-no-other-window)
                                               (no-delete-other-windows . ,easy-side-no-delete-other-windows))))

    (setq created-window (display-buffer-in-side-window
                          (get-buffer (current-buffer))
                          `((side . ,side)
                            (slot . ,(+ 1 (or (easy-side--max-slot-of-current-side-window side) 0)))
                            ,width-height-param
                            ,lock-param
                            ,window-params
                            )))

    (condition-case err (delete-window) (error nil))
    (balance-windows)
    (select-window created-window)
    (toggle-truncate-lines 1))

  (easy-side--lock-side-windows))

(defun easy-side--window--count-on (side)
  "Count the number of windows available on the specified SIDE.

   SIDE: The side where the window is located.

   Returns: The total number of windows on the specified SIDE."
  (let ((count 0))
    (walk-windows
     (lambda (w)
       (let* ((window-state (window-state-get w))
              (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))

         (when (eq window-side side)
           (setq count (+ 1 count))))))

    count))

(defun easy-side--side-window-p (window)
  (let* ((window-state (window-state-get window))
         (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))
    (not (eq window-side nil))))


(defun easy-side--lock-side-windows ()
  (walk-windows
   (lambda (w)
     (let* ((window-state (window-state-get w))
            (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))

       (when window-side
         (set-window-parameter w 'no-delete-other-windows  easy-side-no-delete-other-windows)
         (set-window-parameter w 'no-other-window easy-side-no-other-window)

         (if (or (eq window-side 'left) (eq window-side 'right))
             (window-preserve-size w t t)
           (window-preserve-size w nil t)))))))


(defun easy-side--max-slot-of-current-side-window (side)
  (let ((slot-max nil)
        (tmp-window-state nil)
        (tmp-side nil)
        (tmp-slot nil))

    (walk-windows
     (lambda (w)
       (setq tmp-window-state (window-state-get w))

       (when (assoc 'window-side (assoc 'parameters tmp-window-state))
         (setq tmp-side (cdr (assoc 'window-side (assoc 'parameters tmp-window-state))))
         (setq tmp-slot (cdr (assoc 'window-slot (assoc 'parameters tmp-window-state))))

         (when (eq tmp-side side)
           (when (or (not slot-max) (< slot-max tmp-slot))
             (setq slot-max tmp-slot))))))

    slot-max))



(defun easy-side-push-to-right-side ()
  (interactive)
  (easy-side--push-buffer-to 'right))

(defun easy-side-push-to-left-side ()
  (interactive)
  (easy-side--push-buffer-to 'left))

(defun easy-side-push-to-bottom ()
  (interactive)
  (easy-side--push-buffer-to 'bottom))

(defun easy-side-push-to-top ()
  (interactive)
  (easy-side--push-buffer-to 'top))


(defun easy-side-smart-push-pop ()
  (interactive)
  (if (easy-side--side-window-p (selected-window))
      (easy-side-pop)
    (easy-side-smart-push)))

(defun easy-side-pop ()
  (interactive)
  (when (easy-side--side-window-p (selected-window))
    (let ((buf-name (buffer-name (window-buffer (selected-window)))))
      (delete-window)
      (other-window -1)
      (split-window)
      (other-window 1)
      (switch-to-buffer buf-name)
      (easy-side--lock-side-windows))))

(defun easy-side-smart-push ()
  (interactive)
  (let ((window-count-on-left (easy-side--window--count-on 'left))
        (window-count-on-right (easy-side--window--count-on 'right)))

    (if (not (and (> window-count-on-left 1) (< window-count-on-right 4)))
        (if (> window-count-on-left window-count-on-right)
            (easy-side-push-to-right-side)
          (easy-side-push-to-left-side))
      (easy-side-push-to-right-side))))

(defun easy-side-other-window-for-side-windows (count &optional all-frames interactive)
  (interactive "p\ni\np")

  (walk-windows
   (lambda (window)
     (let ((current-no-other-window-parameter (window-parameter window 'no-other-window)))
       (set-window-parameter window 'no-other-window (not current-no-other-window-parameter)))))

  (other-window 1)

  (walk-windows
   (lambda (window)
     (let ((current-no-other-window-parameter (window-parameter window 'no-other-window)))
       (set-window-parameter window 'no-other-window (not current-no-other-window-parameter))))))



(global-set-key (kbd "M-ü") 'easy-side-smart-push-pop)
(global-set-key (kbd "M-O") 'easy-side-other-window-for-side-windows)




(use-package emojify
  :hook (after-init . global-emojify-mode))
