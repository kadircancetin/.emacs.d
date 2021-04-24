(require 'use-package)


(use-package syntactic-close)
(global-set-key (kbd "M-m") 'syntactic-close)



(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.1
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)



(defun eldoc-mode(&rest args)
  ;; TODO: find who opens the eldoc on python and fix it. Not like that.
  (message "no eldoc"))

(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))




(load-file (expand-file-name "side-window.el" user-emacs-directory))
(global-set-key (kbd "M-ü") 'kadir/smart-push-pop)





(run-with-idle-timer
 1 nil
 (lambda ()
   (benchmark-init/deactivate)
   (benchmark-init/show-durations-tabulated)
   (benchmark-init/show-durations-tree)

   )

 )
