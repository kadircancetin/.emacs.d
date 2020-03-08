;; from doom-emacs early-init el. I don't know what it is and I don't
;; get any speed up whit that but they claim resizing frame is very
;; problem thing so I added that
(setq frame-inhibit-implied-resize t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup optimization
;; source: https://emacs.stackexchange.com/questions/34342/is-there-any-downside-to-setting-gc-cons-threshold-very-high-and-collecting-ga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-prefer-newer noninteractive)
(defvar gc-cons-threshold-orginal gc-cons-threshold)
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(run-with-idle-timer
 1.5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-orginal) ;; default
   (setq file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)
   (message "gc-cons-threshold and file-name-handler-alist restored")))
;; (add-hook 'post-gc-hook (lambda () (message "*GC active*") ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq package-enable-at-startup nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 4)                  ; my laptop screen is not full hd :(


;; FONT SETTINGS
(defvar kadir/default-font-size 70)

;; (set-face-attribute 'default nil :family "Source Code Pro" :height 80 :weight 'normal)
(set-face-attribute 'default nil :family "Source Code Pro" :height 75 :weight 'normal)
;;       (set-face-attribute 'default nil :family "fira code" :height 75 :weight 'normal)
;; (set-face-attribute 'default nil :family "fira code" :height 71 :weight 'normal)

;; (set-face-attribute 'default nil :family "Monoid" :height
;;                     kadir/default-font-size :weight 'normal)

;; (set-face-attribute 'fixed-pitch-serif nil :family "Source Code Pro"
;;                     :italic t) ; this is some minor bug on documentation

;; to finding the available string names
;; (prin1 (mapconcat'identity
;;         (sort (seq-filter (apply-partially #'s-matches?
;;                                            ".*mono.*"
;;                                            ) (font-family-list))
;;               #'string-lessp) "  \n  "))


(add-to-list 'default-frame-alist '(fullscreen . maximized))
(load-theme 'wombat t)


(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(set-face-attribute 'window-divider nil :foreground "#4C4262")
(window-divider-mode 1)



(when (file-exists-p
       "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc"
       )
  ;; TODO: get the from file whithout the version.
  (load-file
   "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc")
  (add-hook 'after-init-hook 'benchmark-init/deactivate))
