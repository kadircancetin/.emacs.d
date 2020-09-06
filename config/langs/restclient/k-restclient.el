(defun kadir/restclient-send()
  (interactive)
  (restclient-http-send-current-stay-in-window)
  (sleep-for 0.2)
  (other-window 1)
  (json-mode-beautify)
  (other-window -1)
  (message "Attım geldim"))

(use-package restclient
  :commands (restclient-http-send-current restclient-http-send-current-stay-in-window)
  :init
  (add-to-list 'auto-mode-alist '("\\(\\.http\\'\\)" . restclient-mode))
  :config
  (setcdr (assoc "application/json" restclient-content-type-modes) 'json-mode)
  :bind ((:map restclient-mode-map
               ("C-c C-c" . 'kadir/restclient-send)
               ("C-c C-v" . 'restclient-http-send-current))))
(use-package company-restclient
  :commands (json-mode-beautify)
  :after (company restclient)
  :config (add-to-list 'company-backends 'company-restclient))


(provide 'k-restclient)
