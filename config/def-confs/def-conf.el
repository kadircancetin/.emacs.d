;; (use-package auto-package-update
;;   :if (not (daemonp))
;;   :custom
;;   (auto-package-update-interval 7) ;; in days
;;   (auto-package-update-prompt-before-update t)
;;   (auto-package-update-delete-old-versions t)
;;   (auto-package-update-hide-results t)
;;   :config
;;   (auto-package-update-maybe))


(savehist-mode 1)

(run-with-idle-timer
 0.15 nil  ;; defer
 (lambda ()
   (progn
     ;; (display-battery-mode 1)
     (blink-cursor-mode -1)

     (display-time-mode 1)
     (delete-selection-mode 1)      ; writing when ther is selected, delete the selected part
     (show-paren-mode 1)            ; shows matching parentheses
     (winner-mode 1)                ; provide undo, redo your window layout
     (global-subword-mode 1)        ; make camel-case usable with word shorcuts
     (save-place-mode 1)            ; save cursor position for next file opening, and restore it
     (global-page-break-lines-mode 1) ; ^L to visual line
     (global-prettify-symbols-mode 1) ; lambda to cool lambda character
     (global-auto-revert-mode 1)      ; auto revert
     (global-auto-composition-mode 1))))



(add-hook 'before-save-hook 'whitespace-cleanup)

(run-with-idle-timer
 0.20 nil
 (lambda () (progn
         (require 'hideshow)
         (add-hook 'prog-mode-hook 'hs-minor-mode))))

(run-with-idle-timer 1 nil
                     (lambda () (async-bytecomp-package-mode 1)))

(run-with-idle-timer 0.75 nil
                     (lambda()
                       (require 'server)
                       (unless (server-running-p)
                         (server-start))
                       (require 'org-protocol)))

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
  (interactive) (find-file "~/Dropbox/org-roam/20200503174932-inbox.org"))

(defun kadir/find-dashboard ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (switch-to-buffer "*dashboard*"))

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
                         (read-number "Set the current window width in [1~11]x8.33%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" w)
  (window-resize nil (- (truncate (* (/ w 12.0) (frame-width))) (window-total-width)) t))

;; Resizes the window height based on the input
(defun resize-window-height (h)
  ;; source: https://github.com/MatthewZMD/.emacs.d
  "Resizes the window height based on H."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window height in [1~11]x8.33%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" h)
  (window-resize nil (- (truncate (* (/ h 12.0) (frame-height))) (window-total-height)) nil))


(defun kadir/align-comments-region (beginning end)
  "Align comments in region."
  (interactive "*r")
  (align-regexp beginning end (concat "\\(\\s-*\\)"
                                      (regexp-quote comment-start))))

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
(setq user-full-name "Kadir Can Çetin")
(setq user-mail-address "kadircancetin@gmail.com")

;; default emacs settings

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; cleaning init.el (another file for custom-set-variables etc.)
;; (setq-default custom-file (concat user-emacs-directory "custom.el"))
;; (load-file  (concat user-emacs-directory "custom.el"))

(setq echo-keystrokes 0.1)

(setq auto-revert-interval 2
      auto-revert-check-vc-info t
      global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

(setq-default ring-bell-function      'ignore ; shutdown rings
              inhibit-startup-message  t      ; disable startup messages
              initial-scratch-message  nil    ; disable startup messages
              initial-major-mode      'text-mode ; initial buffer
              mark-ring-max            128    ; increatese mark-ring
              column-number-mode       t      ; show column number on modeline
              default-buffer-file-coding-system 'utf-8-unix
              kill-ring-max            256    ; increatese kill-ring history
              search-whitespace-regexp ".*?"  ; make isearch more fuzzy like
              ;; require-final-newline    t
              vc-follow-symlinks       t
              )

(setq winner-boring-buffers
      '("*Completions*"
        "*Compile-Log*"
        "*inferior-lisp*"
        "*Fuzzy Completions*"
        "*Apropos*"
        "*Help*"
        "*cvs*"
        "*Buffer List*"
        "*Ibuffer*"
        "*esh command on file*"))


;; short yes no question when emacs ask
(defalias 'yes-or-no-p 'y-or-n-p)


;; ;; SmoothScroll
;; ;; Vertical Scroll
(setq scroll-step 1)
(setq scroll-margin 2)
(setq scroll-conservatively 1000)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)
(setq fast-but-imprecise-scrolling nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
;; ;; Horizontal Scroll
(setq hscroll-step 3)
(setq hscroll-margin 3)
;; ;; -SmoothScroll


(setq-default indent-tabs-mode nil       ; space instead of tabs
              tab-width 4                ; 4 space for tab
              show-trailing-whitespace nil) ; showing empty whitespaces

(setq-default whitespace-newline -1 whitespace-line -1 whitespace-trailing -1)

(setq-default max-mini-window-height   1
              resize-mini-windows      nil
              message-truncate-lines   t)  ; set and try to force mini buffer should be mini


(setq hs-isearch-open t)

;; (setq completion-styles '(basic flex))
;; (setq completion-styles '(basic partial-completion emacs22))

;; back up

;; source: https://emacs.stackexchange.com/questions/33/put-all-backups-into-one-backup-folder
(let ((backup-dir "~/emacs/backups")
      (auto-saves-dir "~/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq-default backup-directory-alist `(("." . ,backup-dir))
                auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
                auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
                tramp-backup-directory-alist `((".*" . ,backup-dir))
                tramp-auto-save-directory auto-saves-dir))

(setq-default backup-by-copying t    ; Don't delink hardlinks
              delete-old-versions t  ; Clean up the backups
              version-control t      ; Use version numbers on backups,
              kept-new-versions 5    ; keep some new versions
              kept-old-versions 2)   ; and some old ones, too



;; persistant history

(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-additional-variables '(savehist-minibuffer-history-variables
                                      helm-M-x-input-history
                                      minibuffer-history
                                      file-name-history
                                      extended-command-history
                                      command-history))

(setq read-process-output-max (* 1024 1024))

(provide 'def-confs)
