(defun eshell/clear ()
  "Clear the eshell buffer. Type clear on eshell"
  ;; source: https://emacs.stackexchange.com/questions/12503/how-to-clear-the-eshell
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun kadir/find-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file config-org))

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
    (beginning-of-buffer)
    (hs-hide-level 2)))

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
