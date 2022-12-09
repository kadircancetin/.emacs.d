(defun kadir/find-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/.emacs.d/config"))

(defun kadir/find-experimental-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  (interactive) (find-file "~/.emacs.d/experimental.el"))

(defun kadir/find-messages ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open Message buffer"
  (interactive) (switch-to-buffer "*Messages*"))

(defun kadir/find-scratch-buffer ()
  (interactive)
  (switch-to-buffer "*scratch*"))


(defun kadir/move-to-top ()
  (interactive)
  (require 'mwim)
  (save-excursion
    (mwim-beginning-of-code)
    (kill-line)
    (goto-char (point-min))
    (yank)(insert "\n"))
  (mwim-beginning-of-line)
  (kill-line))


(defun kadir/delete-file-and-buffer ()
  ;; based on https://gist.github.com/hyOzd/23b87e96d43bca0f0b52 which is based on
  ;; http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (when (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
          (delete-file filename t)
          (message "Deleted file %s." filename)
          (kill-buffer))
      (message "Not a file visiting buffer!"))))

(defun kadir/comment-or-self-insert (&optional beg end)
  "If region active comment-or-uncomment work,
     otherwise (self-insert /)"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))))
  (if (region-active-p)
      (comment-or-uncomment-region beg end)
    (self-insert-command 1 ?/)))

(defun kadir/open-thunar()
  "This functions open the thunar file editor on the buffers
                 directory. Working and testing only on the linux systems."
  (interactive)
  (start-process "*shellout*" nil "thunar"))

(defun kadir/kill-buffer()
  (interactive) (kill-buffer (current-buffer)))

(defun kadir/split-and-follow-horizontally ()
  "Split window below and follow."
  (interactive)
  (split-window-below)
  (other-window 1)
  ;; (balance-windows)
  )

(defun kadir/split-and-follow-vertically ()
  "Split window below and follow."
  (interactive)
  (split-window-right)
  (other-window 1)
  ;; (balance-windows)
  )

(defun kadir/delete-window ()
  "Split window below and follow."
  (interactive)
  (delete-window)
  ;; (balance-windows)
  )

(defun spacemacs/backward-kill-word-or-region (&optional arg)
  "Calls `kill-region' when a region is active and
     `backward-kill-word' otherwise. ARG is passed to
     `backward-kill-word' if no region is active."
  (interactive "p")
  (if (region-active-p)
      ;; call interactively so kill-region handles rectangular selection
      ;; correctly (see https://github.com/syl20bnr/spacemacs/issues/3278)
      (call-interactively #'kill-region)
    (backward-kill-word arg)))

(defun kadir/last-buffer ()
  "Get last buffer. If it is windowed, jump it"
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) nil)))


(defun resize-window-width (w)
  ;; source: https://github.com/MatthewZMD/.emacs.d
  "Resizes the window width based on W."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window width in [1~11]x8.33%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" w)
  (window-resize nil (- (truncate (* (/ w 12.0) (frame-width))) (window-total-width)) t))

(defun resize-window-height (h)
  ;; source: https://github.com/MatthewZMD/.emacs.d
  "Resizes the window height based on H."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window height in [1~11]x8.33%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" h)
  (window-resize nil (- (truncate (* (/ h 12.0) (frame-height))) (window-total-height)) nil))



(defun kadir/adjust-font-size(x)
  (set-face-attribute 'default nil :height x)
  (set-face-attribute 'mode-line nil :height x)
  (set-face-attribute 'mode-line-inactive nil :height x)
  (message "New Size: %d" x))

(defun kadir/font-size-smaller()
  (interactive)
  (setq kadir/default-font-size (- kadir/default-font-size 3))
  (kadir/adjust-font-size kadir/default-font-size))

(defun kadir/font-size-bigger()
  (interactive)
  (setq kadir/default-font-size (+ kadir/default-font-size 10))
  (kadir/adjust-font-size kadir/default-font-size))



(defun kadir/bind (args)
  (mapcar
   (lambda (arg)
     (global-set-key (kbd (car arg)) (cdr arg)))
   args))



(defun kadir/isearch-region (&optional not-regexp no-recursive-edit)
  ;; cloned from: https://www.reddit.com/r/emacs/comments/b7yjje/isearch_region_search/
  "If a region is active, make this the isearch default search pattern."
  (interactive "P\np")
  (when (use-region-p)
    (let ((search (buffer-substring-no-properties
                   (region-beginning)
                   (region-end))))
      (setq deactivate-mark t)
      (isearch-yank-string search))))



(provide 'k-mini-funcs)
