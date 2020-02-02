(defun k/garp_collect()
  (interactive)
  (while 1
    (progn
      (message "try gc")
      (sleep-for 0.1)
      (setq gc-cons-threshold-original 200)
      (garbage-collect)
      (setq gc-cons-threshold-original (* 1024 1024 20)))))
