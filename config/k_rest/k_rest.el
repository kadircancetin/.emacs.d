(defun restclient-kadir()
  (interactive)
  (restclient-http-send-current-stay-in-window)
  (sleep-for 0.1)
  (other-window 1)
  (json-mode-beautify)
  (other-window -1)
  (message "Attım geldim"))


(use-package restclient
  :init
  (add-to-list 'auto-mode-alist '("\\(\\.http\\'\\)" . restclient-mode))
  (setq restclient-content-type-modes '(("text/xml" . xml-mode)
                                        ("text/plain" . text-mode)
                                        ("application/xml" . xml-mode)
                                        ("application/json" . json-mode)
                                        ("image/png" . image-mode)
                                        ("image/jpeg" . image-mode)
                                        ("image/jpg" . image-mode)
                                        ("image/gif" . image-mode)
                                        ("text/html" . html-mode)))
  :config
  (add-to-list 'company-backends 'company-restclient)
  :bind (
         (:map restclient-mode-map
               ("C-c C-c" . 'restclient-kadir)
               ("C-c C-v" . 'restclient-http-send-current))))

(use-package company-restclient
  :after (company restclient))

(provide 'k_rest)
