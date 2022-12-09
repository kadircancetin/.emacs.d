(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)



(setq-default user-full-name "Kadir Can Çetin")
(setq-default user-mail-address "kadircancetin@gmail.com")




;; I hate eldoc with no reason

(global-eldoc-mode 0)
(defun eldoc-mode(&rest args) (message "no eldoc"))



;; Activation minor modes (Deffered)

(run-with-idle-timer
 0.15 nil  ;; defer
 (lambda () (progn
         ;; (display-battery-mode 1)
         (savehist-mode 1)
         (global-so-long-mode 1)
         (blink-cursor-mode -1)
         ;; (display-time-mode 1)
         (delete-selection-mode 1)        ; writing when ther is selected, delete the selected part
         (show-paren-mode 1)              ; shows matching parentheses
         (winner-mode 1)                  ; provide undo, redo your window layout
         (global-subword-mode 1)          ; make camel-case usable with word shorcuts
         (save-place-mode 1)              ; save cursor position for next file opening, and restore it
         ;; (global-prettify-symbols-mode 1) ; lambda to cool lambda character
         (global-auto-revert-mode 1)
         ;; (column-number-mode 0)
         (global-auto-composition-mode 1))))

(run-with-idle-timer
 1 nil
 (lambda () (progn
         (require 'hideshow)
         (add-hook 'prog-mode-hook 'hs-minor-mode))))



(run-with-idle-timer 5 nil
                     (lambda()
                       (require 'server)
                       (unless (server-running-p)
                         (server-start))
                       (require 'org-protocol)))




;; Hooks

(add-hook 'before-save-hook 'whitespace-cleanup)



;; Setting general default variables

(setq-default
 echo-keystrokes 0.1
 show-paren-when-point-inside-paren t)

(setq-default ring-bell-function      'ignore    ; shutdown rings
              inhibit-startup-message  t         ; disable startup messages
              initial-scratch-message  nil       ; disable startup messages
              initial-major-mode      'fundamental-mode ; initial buffer
              ;; mark-ring-max            128       ; increatese mark-ring
              default-buffer-file-coding-system 'utf-8-unix
              ;; kill-ring-max            256       ; increatese kill-ring history
              search-whitespace-regexp ".*?"     ; make isearch more fuzzy like
              ;; require-final-newline    t
              vc-follow-symlinks       t)

(setq-default winner-boring-buffers
              '("*Completions*" "*Compile-Log*" "*inferior-lisp*" "*Fuzzy Completions*"
                "*Apropos*" "*Help*" "*cvs*" "*Buffer List*" "*Ibuffer*" "*esh command on file*"))

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
(setq-default scroll-conservatively 1000
              fast-but-imprecise-scrolling t
              mouse-wheel-scroll-amount '(1 ((shift) . 1))
              mouse-wheel-progressive-speed nil)



(advice-add 'isearch-forward-regexp :after 'kadir/isearch-region)
(advice-add 'isearch-forward :after 'kadir/isearch-region)
(advice-add 'isearch-backward-regexp :after 'kadir/isearch-region)
(advice-add 'isearch-backward :after 'kadir/isearch-region)



;; mac conf

(when (eq system-type 'darwin)
  (kadir/mac-conf)
  (use-package exec-path-from-shell :init (exec-path-from-shell-initialize))
  (setq mac-option-modifier nil)
  (setq mac-command-modifier 'super)
  (setq ns-option-modifier 'meta
        ns-right-alternate-modifier 'super
        ns-right-option-modifier 'none)
  (setq ns-auto-hide-menu-bar t))



(setq-default comp-deferred-compilation-black-list nil)



;; BINDINGS FOR DEFAULT FUNCTIONS AND CUSTOM FUNCTIONS

(keyboard-translate ?\C-? ?\C-h)
(keyboard-translate ?\C-h ?\C-?)
(kadir/bind
 '(;; editing
   ("C-w"             . spacemacs/backward-kill-word-or-region)
   ("/"               . kadir/comment-or-self-insert)

   ;; window-buffer
   ("M-o"             . other-window)
   ("M-u"
    . winner-undo)
   ("C-x k"           . kadir/kill-buffer)
   ("C-x 2"           . kadir/split-and-follow-horizontally)
   ("C-x 3"           . kadir/split-and-follow-vertically)
   ("C-x 0"           . kadir/delete-window)
   ("M-<SPC>"         . kadir/last-buffer)

   ;; shortcuts
   ("C-x *"           . kadir/open-thunar)
   ("C-x -"           . kadir/open-terminator)

   ;; fonts
   ("C-+"             . text-scale-increase)
   ("C--"             . text-scale-decrease)
   ("C-c c"           . (lambda()(interactive)(org-capture nil "t")))))




(provide 'k-defaults)
