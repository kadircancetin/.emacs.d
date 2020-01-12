;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup optimization
;; source: https://emacs.stackexchange.com/questions/34342/is-there-any-downside-to-setting-gc-cons-threshold-very-high-and-collecting-ga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-prefer-newer noninteractive)
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold-original (* 1024 1024 20))
(setq gc-cons-threshold most-positive-fixnum)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(run-with-idle-timer
 3 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original)
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

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(fringe-mode '(5 . 0))                  ; my laptop screen is not full hd :(

(load-theme 'wombat t)
(set-face-attribute 'default nil
                    :family "Source Code Pro" :height 80 :weight 'normal)

;; (use-package benchmark-init :ensure t)
(if (file-exists-p "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc")
    ;; TODO: get the from file whithout the version.
    (progn
      ;;(load-file "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc")
      ;;(add-hook 'after-init-hook 'benchmark-init/deactivate)
      )
  (message "benchmark test is not installed, so not tested."))
