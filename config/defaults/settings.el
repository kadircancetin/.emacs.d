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
