
(require 'package)

;; - =M-x straight-pull-all=: update all packages.
;; - =M-x straight-normalize-all=: restore all packages (remove local edits)
;; - =M-x straight-freeze-versions= and =M-x straight-thaw-versions= are like =pip
;; freeze requirements.txt= and =pip install -r requirements.txt=
;; - To tell straight.el that you want to use the version of Org shipped with
;; Emacs, rather than cloning the upstream repository:
;; (Note: ":tangle no")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-check-for-modifications '(watch-files find-when-checking))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)


(setq use-package-always-defer t
      use-package-expand-minimally t)

(use-package no-littering)
(require 'no-littering)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(if (file-exists-p custom-file)
    (load-file custom-file))
(add-to-list 'yas-snippet-dirs
             (expand-file-name "snippets" user-emacs-directory))


(use-package auto-package-update
  :if (not (daemonp))
  :custom
  (auto-package-update-interval 7) ;; in days
  (auto-package-update-prompt-before-update t)
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe))


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


(load-file (expand-file-name "config/defaults/settings.el" user-emacs-directory))


;; settings and packages which important and used for all the major modes
(load-file (expand-file-name "config/defaults/functions.el" user-emacs-directory))


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


(provide 'defaults)
