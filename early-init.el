(defvar kadir/emacs-fast-open (member "-fo" command-line-args))
(setq command-line-args (delete "-fo" command-line-args))

(defvar kadir/default-font-size 75)
(when kadir/emacs-fast-open (setq kadir/default-font-size 95))



(setq frame-inhibit-implied-resize t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; source: https://emacs.stackexchange.com/questions/34342/is-there-any-downside-to-setting-gc-cons-threshold-very-high-and-collecting-ga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
   (message "gc-cons-threshold and file-name-handler-alist restored")))

(setq package-enable-at-startup nil)


(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 4)
(setq frame-resize-pixelwise t)


(setq load-prefer-newer t)       ; somehow dangers but when createing package, I need this


(set-face-attribute 'default nil :family "Source Code Pro" :height kadir/default-font-size :weight 'normal)
(set-face-attribute 'fixed-pitch-serif nil :family "Source Code Pro" :italic t :weight 'bold)
;; (set-face-attribute 'default nil :family "fira code" :height 75 :weight 'normal)
;; (set-face-attribute 'default nil :family "Monoid" :height kadir/default-font-size :weight 'normal)


(when (not kadir/emacs-fast-open) (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(load-theme 'wombat t)


(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#4C4262")
(window-divider-mode 1)
