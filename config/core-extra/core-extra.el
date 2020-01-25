(load-file (expand-file-name "config/core-extra/packages.el" user-emacs-directory))

(if (and (executable-find "wakatime") (file-exists-p "~/.wakatime.cfg"))
    (use-package wakatime-mode
      :defer 5
      :config
      (add-hook 'prog-mode-hook 'wakatime-mode)
      (message "waka activated")))



(use-package quelpa)

(unless (package-installed-p 'so-long)
  (quelpa
   '(so-long :fetcher url
             :url "https://raw.githubusercontent.com/emacs-mirror/emacs/master/lisp/so-long.el"
             :upgrade nil))
  (package-install 'use-package))
(run-with-idle-timer
 2 nil
 (lambda()
   (progn
     (global-so-long-mode 1)
     (add-hook 'so-long-hook (lambda() (toggle-truncate-lines))))))



(defun eshell/clear ()
  "Clear the eshell buffer. Type clear on eshell"
  ;; source: https://emacs.stackexchange.com/questions/12503/how-to-clear-the-eshell
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(provide 'core-extra)
