;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup optimization
;; source: https://emacs.stackexchange.com/questions/34342/is-there-any-downside-to-setting-gc-cons-threshold-very-high-and-collecting-ga

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package benchmark-init
;;   :ensure t
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

(defvar config-org (expand-file-name "README.org" user-emacs-directory))
(defvar config-el (expand-file-name "README.el" user-emacs-directory))

(defun emacs_start__with_org()
  (require 'org)
  (org-babel-load-file (expand-file-name config-org user-emacs-directory)))

(defun emacs_start__with_tangled() (load-file config-el))


(if (file-exists-p config-el)
    (if (file-newer-than-file-p config-org config-el)
        (emacs_start__with_org)
      (emacs_start__with_tangled))
  (emacs_start__with_org))
