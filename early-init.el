(defvar kadir/default-font-size 93)



(setq gc-cons-threshold most-positive-fixnum)
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq gc-cons-percentage 0.1)
(run-with-idle-timer 3 nil (lambda () (setq file-name-handler-alist file-name-handler-alist-original)))



(setq jit-lock-defer-time 0.25
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)


(defun k/set-init-package-disabling ()
  ;;(setq-default comp-deferred-compilation t)
  (setq package-enable-at-startup nil)
  ;; (setq load-prefer-newer t)
  (setq load-prefer-newer noninteractive))

(k/set-init-package-disabling)


(defun k/set-init--window-devider ()
  (setq window-divider-default-places t
        window-divider-default-bottom-width 1
        window-divider-default-right-width 1)
  (window-divider-mode 1))

(defun k/set-init-ui()
  "Initialize UI. Mostly because of if theese settings in here, startup is faster"
  ;; (load-theme 'wombat t)
  (when fringe-mode
    (fringe-mode 6))
  (setq frame-inhibit-implied-resize t)              ;; doom says it increse speedup
  (setq frame-resize-pixelwise t)                    ;; for terminal
  (push '(menu-bar-lines . 0) default-frame-alist)   ;; (menu-bar-mode -1)
  (push '(tool-bar-lines . 0) default-frame-alist)   ;; (tool-bar-mode -1)
  (push '(vertical-scroll-bars) default-frame-alist) ;; (scroll-bar-mode -1)

  (k/set-init--window-devider)

  ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (add-to-list 'default-frame-alist '(height . 54))
  (add-to-list 'default-frame-alist '(width . 120))

  (set-face-attribute 'window-divider nil :foreground "#4C4262")

  ;; (set-face-attribute 'default nil :family "Fira Code" :height 80 :weight 'normal)


  ;; (mapcar #'prin1 (font-family-list))
  ;; see all font available on system
  ;; (font-family-list)
  ;; (set-face-attribute 'default nil :family "Latin Modern Mono" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "M+ 1m" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Fira Code" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Monoid Tight" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Monoid HalfTight" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Monoid" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Pragmata" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Inconsolata" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Hack" :height kadir/default-font-size :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Meslo LG M" :height kadir/default-font-size :weight 'normal)
  ;; standards
  ;; (set-face-attribute 'default nil :family "Source Code Pro" :height kadir/default-font-size :weight 'normal)
  (set-face-attribute 'default nil :family "Fira Code" :height kadir/default-font-size :weight 'normal)
  ;; low width mma
  ;; (set-face-attribute 'default nil :family "Sudo" :height (+ kadir/default-font-size 16) :weight 'normal)
  ;; (set-face-attribute 'default nil :family "Iosevka" :height (+ kadir/default-font-size 0) :weight 'normal)
  ;; https://aur.archlinux.org/packages/ttf-iosevka
  ;; https://aur.archlinux.org/packages/ttf-sudo
  ;; 1o08OIijlMmw
  (set-face-attribute 'fixed-pitch-serif nil :family "Source Code Pro" :italic t :weight 'bold))


(k/set-init-ui)

