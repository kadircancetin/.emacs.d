(defun kadir/buffer-to-side(&optional side)
  (interactive)
  (unless side (setq side 'left))

  (let ((width-height-param nil)
        (lock-param nil)
        (window-params nil)
        (created-window nil))

    (if (or (eq side 'left) (eq side 'right))
        (progn
          (setq widh-height-param '(window-width . 0.14))
          (setq lock-param '(preserve-size . (t . nil))))
      (setq widh-height-param '(window-height . 0.2))
      (setq lock-param '(preserve-size . (nil . t))))

    (setq window-params '(window-parameters . ((no-other-window . t)
                                               (no-delete-other-windows . t))))


    (setq created-window (display-buffer-in-side-window
                          (get-buffer (current-buffer))
                          `((side . ,side)
                            (slot . ,(+ 1 (or (kadir/side-window-get-max-slot side) 0)))
                            ,widh-height-param
                            ,lock-param
                            ,window-params
                            )))
    (delete-window)
    (balance-windows)
    (select-window created-window)
    (toggle-truncate-lines 1))

  (kadir/side-window-lock))


(defun kadir/pop-side-window()
  (interactive)
  (let ((buf-name (window-buffer (selected-window))))
    (message (buffer-name buf-name))
    (delete-window)
    (other-window -1)
    (split-window)
    (other-window 1)
    (switch-to-buffer buf-name)))

(defun kadir/is-side-window(window)
  (let* ((window-state (window-state-get window))
         (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))
    (not (eq window-side nil))))

(defun kadir/smart-push-pop()
  (interactive)
  (if (kadir/is-side-window (selected-window))
      (kadir/pop-side-window)
    (kadir/push-side-window-stack)))

(defun kadir/side-window--count(side)
  (interactive)
  (let ((count 0))
    (dolist (w (window-list))
      (let* ((window-state (window-state-get w))
             (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))

        (when (eq window-side side)
          (setq count (+ 1 count)))))

    count))

(defun kadir/push-side-window-stack()
  (interactive)
  (let ((left-count (kadir/side-window--count 'left))
        (right-count (kadir/side-window--count 'right)))

    (if (not (and (> left-count 1) (< right-count 4)))
        (if (> left-count right-count)
            (kadir/buffer-to-side-right)
          (kadir/buffer-to-side-left))
      (kadir/buffer-to-side-right))))


(defun kadir/buffer-to-side-right()
  (interactive)
  (kadir/buffer-to-side 'right))

(defun kadir/buffer-to-side-left()
  (interactive)
  (kadir/buffer-to-side))

(defun kadir/buffer-to-side-bottom()
  (interactive)
  (kadir/buffer-to-side 'bottom))

(defun kadir/buffer-to-side-top()
  (interactive)
  (kadir/buffer-to-side 'top))


(defun kadir/side-window-lock()
  (interactive)

  (dolist (w (window-list))
    (let* ((window-state (window-state-get w))
           (window-side (cdr (assoc 'window-side (assoc 'parameters window-state)))))

      (when window-side
        (set-window-parameter w 'no-delete-other-windows  t)
        (set-window-parameter w 'no-other-window  t)

        (if (or (eq window-side 'left) (eq window-side 'right))
            (window-preserve-size w t t)
          (window-preserve-size w nil t))
        ))
    ))

(defun kadir/side-window-bigger()
  (interactive)

  (let ((before-selected-window (selected-window)))

    (dolist (w (window-list))
      (when (assoc 'window-side (assoc 'parameters (window-state-get w)))
        (select-window w)
        (enlarge-window-horizontally 1)))

    (kadir/side-window-lock)
    (select-window before-selected-window)))


(defun kadir/side-window-get-max-slot(side)
  (let ((slot-max nil)
        (tmp-window-state nil)
        (tmp-side nil)
        (tmp-slot nil))

    (dolist (w (window-list))
      (setq tmp-window-state (window-state-get w))

      (when (assoc 'window-side (assoc 'parameters tmp-window-state))
        (setq tmp-side (cdr (assoc 'window-side (assoc 'parameters tmp-window-state))))
        (setq tmp-slot (cdr (assoc 'window-slot (assoc 'parameters tmp-window-state))))

        (when (eq tmp-side side)
          (when (or (not slot-max) (< slot-max tmp-slot))
            (setq slot-max tmp-slot)))))
    slot-max
    ))
