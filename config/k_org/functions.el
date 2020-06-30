(defun kadir/org-roam-disable-activate-roam (funct extra_arg_p &rest args)
  "It close roam backlink page, run function, open backlink page"
  (interactive "P")
  (pcase (org-roam-buffer--visibility)

    ('visible
     (delete-window (get-buffer-window org-roam-buffer))
     (if extra_arg_p (funcall funct args) (funcall funct))
     (pcase (org-roam-buffer--visibility)
       ((or 'exists 'none)
        (org-roam))))

    ((or 'exists 'none)
     (progn
       (if extra_arg_p (funcall funct args) (funcall funct))
       (org-roam-buffer--get-create)))))

(defun kadir/org-roam-dailies-today (&rest args)
  "override org-roam-dailies because of the new frame bug?? ı dont know is it bug or something"
  (interactive)
  (kadir/org-roam-disable-activate-roam 'org-roam-dailies-today nil args))

(defun kadir/org-roam-insert (&rest args)
  "override org-roam-dailies because of the new frame bug?? ı dont know is it bug or something"
  (interactive "P")
  (kadir/org-roam-disable-activate-roam 'org-roam-insert t args))

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
