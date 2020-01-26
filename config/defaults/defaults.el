
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; installing the use-package automatically if it is not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t
      use-package-always-defer t)

(use-package benchmark-init :ensure t :defer t) ;; TODO: delete or more logical things


(savehist-mode 1)

(run-with-idle-timer
 0.15 nil  ;; defer
 (lambda ()
   (progn
     (blink-cursor-mode -1)

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

(run-with-idle-timer ;; TODO: why whitespace is not required but hs reqire "reqiure"
 0.15 nil
 (lambda () (progn
         (require 'hideshow)
         (add-hook 'prog-mode-hook 'hs-minor-mode))))


(run-with-idle-timer 1 nil ;; TODO: ?
                     (lambda () (async-bytecomp-package-mode 1)))

(provide 'defaults)
