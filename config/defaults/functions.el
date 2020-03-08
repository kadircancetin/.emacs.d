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

(advice-add 'isearch-forward-regexp :after 'kadir/isearch-region)
(advice-add 'isearch-forward :after 'kadir/isearch-region)


(defun kadir/delete-file-and-buffer ()
  ;; based on https://gist.github.com/hyOzd/23b87e96d43bca0f0b52 which
  ;; is based on http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (when (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
          (delete-file filename)
          (message "Deleted file %s." filename)
          (kill-buffer))
      (message "Not a file visiting buffer!"))))

(defun eshell/clear ()
  "Clear the eshell buffer. Type clear on eshell"
  ;; source: https://emacs.stackexchange.com/questions/12503/how-to-clear-the-eshell
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun kadir/find-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/.emacs.d/config"))

(defun kadir/find-experimental-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/.emacs.d/experimental.el"))

(defun kadir/open-scratch-buffer ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun kadir/find-inbox ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/org/inbox.org"))

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

(defun kadir/open-terminator()
  "This functions open the thunar file editor on the buffers
     directory. Working and testing only on the linux systems."
  (interactive)
  (start-process "*shellout*" nil "terminator"))


(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))

(defun kadir/split-and-follow-horizontally ()
  "Split window below and follow."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun kadir/split-and-follow-vertically ()
  "Split window below and follow."
  (interactive)
  (split-window-right)
  (other-window 1))

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
  "get last buffer which is not windowed"
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) nil)))

(defun kadir/hide-fold-defs ()
  "Folds the all functions in python"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (hs-hide-level 2)))

(defun resize-window-width (w)
  ;; source: https://github.com/MatthewZMD/.emacs.d
  "Resizes the window width based on W."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window width in [1~9]x10%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" w)
  (window-resize nil (- (truncate (* (/ w 10.0) (frame-width))) (window-total-width)) t))

;; Resizes the window height based on the input
(defun resize-window-height (h)
  ;; source: https://github.com/MatthewZMD/.emacs.d
  "Resizes the window height based on H."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window height in [1~9]x10%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" h)
  (window-resize nil (- (truncate (* (/ h 10.0) (frame-height))) (window-total-height)) nil))

;; (defun kadir/save-config-async()
;;   ""
;;   (interactive)
;;   (when (equal (buffer-file-name) config-org)
;;     (use-package async)
;;     (async-start
;;      (lambda ()
;;        (require 'org)
;;        ;; note: ~/emacsleri değikenden al
;;        (org-babel-tangle-file "~/.emacs.d/README.org" "~/.emacs.d/README.el"))
;;      (lambda(result)
;;        (message "tangled saved files to: %s" result)))))
;; (add-hook 'after-save-hook 'kadir/save-config-async)
