(defvar kadir/emacs-fast-open (member "-fo" command-line-args))
(setq command-line-args (delete "-fo" command-line-args))

(defvar kadir/default-font-size 75)
(when kadir/emacs-fast-open (setq kadir/default-font-size 95))


(defun k/set-garbage-collection()
  "source: https://emacs.stackexchange.com/questions/34342/"
  (setq load-prefer-newer noninteractive)
  (defvar gc-cons-threshold-orginal (* 1024 1024 100))
  (setq gc-cons-percentage 0.8)
  (setq gc-cons-threshold most-positive-fixnum)

  (defvar file-name-handler-alist-original file-name-handler-alist)
  (setq file-name-handler-alist nil)
  (run-with-idle-timer
   3 nil
   (lambda ()
     (setq gc-cons-threshold gc-cons-threshold-orginal)
     (setq file-name-handler-alist file-name-handler-alist-original)
     (makunbound 'gc-cons-threshold-original)
     (makunbound 'file-name-handler-alist-original)
     (message "gc-cons-threshold and file-name-handler-alist restored"))))

(defun k/set-init-package-disabling ()
  (setq package-enable-at-startup nil)
  ;; (setq load-prefer-newer t)
  (setq load-prefer-newer noninteractive))

(defun k/set-init-ui()
  "Initialize UI. Mostly because of if theese settings in here, startup is faster"
  (load-theme 'wombat t)
  (fringe-mode 4)
  (window-divider-mode 1)

  (setq frame-inhibit-implied-resize t)              ;; doom says it increse speedup
  (setq frame-resize-pixelwise t)                    ;; for terminal
  (push '(menu-bar-lines . 0) default-frame-alist)   ;; (menu-bar-mode -1)
  (push '(tool-bar-lines . 0) default-frame-alist)   ;; (tool-bar-mode -1)
  (push '(vertical-scroll-bars) default-frame-alist) ;; (scroll-bar-mode -1)

  (when (not kadir/emacs-fast-open)
    (add-to-list 'default-frame-alist '(fullscreen . maximized)))

  (setq window-divider-default-places t
        window-divider-default-bottom-width 1
        window-divider-default-right-width 1)
  (set-face-attribute 'window-divider nil :foreground "#4C4262")

  (set-face-attribute 'default nil :family "Source Code Pro" :height kadir/default-font-size :weight 'normal)
  (set-face-attribute 'fixed-pitch-serif nil :family "Source Code Pro" :italic t :weight 'bold))



(k/set-garbage-collection)
(k/set-init-package-disabling)
(k/set-init-ui)
