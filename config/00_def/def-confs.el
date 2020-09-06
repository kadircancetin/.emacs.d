(setq-default user-full-name "Kadir Can Çetin")
(setq-default user-mail-address "kadircancetin@gmail.com")


;; Deffered activation minor modes
(run-with-idle-timer
 0.15 nil  ;; defer
 (lambda () (progn
         ;; (display-battery-mode 1)
         (savehist-mode 1)
         (blink-cursor-mode -1)
         ;; (display-time-mode 1)
         (delete-selection-mode 1)        ; writing when ther is selected, delete the selected part
         (show-paren-mode 1)              ; shows matching parentheses
         (winner-mode 1)                  ; provide undo, redo your window layout
         (global-subword-mode 1)          ; make camel-case usable with word shorcuts
         (save-place-mode 1)              ; save cursor position for next file opening, and restore it
         ;; (global-prettify-symbols-mode 1) ; lambda to cool lambda character
         ;; (global-auto-revert-mode nil)      ; auto revert
         (column-number-mode 1)
         (global-auto-composition-mode 1))))

(run-with-idle-timer
 1 nil
 (lambda () (progn
         (require 'hideshow)
         (add-hook 'prog-mode-hook 'hs-minor-mode))))


(require 'server)
(run-with-idle-timer 5 nil
                     (lambda()
                       (unless (server-running-p)
                         (server-start))
                       (require 'org-protocol)))


;; Hooks
(add-hook 'before-save-hook 'whitespace-cleanup)


;; Setting general default variables
(setq-default echo-keystrokes 0.1)

(setq-default show-paren-when-point-inside-paren t)

(setq-default ring-bell-function      'ignore    ; shutdown rings
              inhibit-startup-message  t         ; disable startup messages
              initial-scratch-message  nil       ; disable startup messages
              initial-major-mode      'text-mode ; initial buffer
              mark-ring-max            128       ; increatese mark-ring
              default-buffer-file-coding-system 'utf-8-unix
              kill-ring-max            256       ; increatese kill-ring history
              search-whitespace-regexp ".*?"     ; make isearch more fuzzy like
              ;; require-final-newline    t
              vc-follow-symlinks       t)

(setq-default winner-boring-buffers '("*Completions*" "*Compile-Log*" "*inferior-lisp*" "*Fuzzy Completions*" "*Apropos*" "*Help*" "*cvs*" "*Buffer List*" "*Ibuffer*" "*esh command on file*"))

(setq-default indent-tabs-mode nil          ; space instead of tabs
              tab-width 4                   ; 4 space for tab
              show-trailing-whitespace nil  ; showing empty whitespaces
              whitespace-newline -1
              whitespace-line -1
              whitespace-trailing -1)

;; (setq-default max-mini-window-height   10
;;               resize-mini-windows      t
;;               message-truncate-lines   t)  ; set and try to force mini buffer should be mini

(setq-default hs-isearch-open t)
;; (setq completion-styles '(basic flex))
;; (setq completion-styles '(basic partial-completion emacs22))


;; back up
(setq-default backup-by-copying t    ; Don't delink hardlinks
              delete-old-versions t  ; Clean up the backups
              version-control t      ; Use version numbers on backups,
              )

;; Performance improvements
(setq-default read-process-output-max (* 1024 1024)) ;; for lsp: https://github.com/hlissner/doom-emacs/pull/2590

;; persistant history
(setq-default history-length t)
(setq-default history-delete-duplicates t)
(setq-default savehist-additional-variables '(savehist-minibuffer-history-variables
                                              helm-M-x-input-history
                                              minibuffer-history
                                              file-name-history
                                              extended-command-history
                                              command-history))
(defalias 'yes-or-no-p 'y-or-n-p)   ; short yes no question when emacs ask

;; ;; SmoothScroll
(setq-default scroll-step 1
              scroll-margin 2
              scroll-conservatively 1000
              scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01
              auto-window-vscroll nil
              fast-but-imprecise-scrolling nil
              mouse-wheel-scroll-amount '(1 ((shift) . 1))
              mouse-wheel-progressive-speed nil)


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
(advice-add 'isearch-backward-regexp :after 'kadir/isearch-region)
(advice-add 'isearch-backward :after 'kadir/isearch-region)


(defun kadir/find-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/.emacs.d/config"))

(defun kadir/find-experimental-config ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/.emacs.d/experimental.el"))

(defun kadir/find-inbox ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (find-file "~/Dropbox/org-roam/20200503174932-inbox.org"))

(defun kadir/find-dashboard ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "Open config file. (probably this file)"
  (interactive) (switch-to-buffer "*dashboard*"))


(defun kadir/delete-file-and-buffer ()
  ;; based on https://gist.github.com/hyOzd/23b87e96d43bca0f0b52 which is based on
  ;; http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (when (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
          (delete-file filename)
          (message "Deleted file %s." filename)
          (kill-buffer))
      (message "Not a file visiting buffer!"))))

(defun kadir/find-scratch-buffer ()
  (interactive)
  (switch-to-buffer "*scratch*"))

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

(defun kadir/align-comments-region (beginning end)
  "Align comments in region."
  (interactive "*r")
  (align-regexp beginning end (concat "\\(\\s-*\\)"
                                      (regexp-quote comment-start))))



(defun kadir/bind (args)
  (mapcar
   (lambda (arg)
     (global-set-key (kbd (car arg)) (cdr arg)))
   args))

(keyboard-translate ?\C-? ?\C-h)
(keyboard-translate ?\C-h ?\C-?)

(kadir/bind
 '(;; editing
   ("C-w"             . spacemacs/backward-kill-word-or-region)
   ("/"               . kadir/comment-or-self-insert)

   ;; window-buffer
   ("M-o"             . other-window)
   ("M-u"             . winner-undo)
   ("C-x k"           . (lambda () (interactive) (kill-buffer (current-buffer))))
   ("M-ı"             . (lambda() (interactive) (indent-region (point-min) (point-max))))
   ("C-x 2"           . kadir/split-and-follow-horizontally)
   ("C-x 3"           . kadir/split-and-follow-vertically)
   ("M-<SPC>"         . kadir/last-buffer)

   ;; shortcuts
   ("C-x *"           . kadir/open-thunar)
   ("C-x -"           . kadir/open-terminator)

   ;; fonts
   ("C-+"             . text-scale-increase)
   ("C--"             . text-scale-decrease)
   ("C-c c"           . (lambda()(interactive)(org-capture nil "t")))))

(provide 'def-confs)
