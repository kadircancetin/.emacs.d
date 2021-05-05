(setq kadir/before-window nil)

(defun kadir/rest-client-stay-current()
  (interactive)
  (setq kadir/before-window (current-buffer))
  (restclient-http-send-current-stay-in-window))

(defun kadir/restclient-after-hook()
  (interactive)

  (let ((response-buf "*HTTP Response*"))
    (when (get-buffer response-buf)
      (pop-to-buffer response-buf)
      (condition-case nil
          (json-pretty-print-buffer)
        (error nil)))))

(defun kadir/select-before-window(&rest args)
  (interactive)
  (pop-to-buffer kadir/before-window))


(add-hook 'restclient-response-loaded-hook 'kadir/restclient-after-hook)
(advice-add 'restclient-http-handle-response :after 'kadir/select-before-window)

(use-package restclient
  :commands (restclient-http-send-current restclient-http-send-current-stay-in-window)
  :init
  (add-to-list 'auto-mode-alist '("\\(\\.http\\'\\)" . restclient-mode))
  :config
  (setcdr (assoc "application/json" restclient-content-type-modes) 'json-mode)
  :bind ((:map restclient-mode-map
               ("C-c C-c" . 'kadir/rest-client-stay-current)
               ("C-c C-v" . 'restclient-http-send-current))))
(use-package company-restclient
  :commands (json-mode-beautify)
  :after (company restclient)
  :config (add-to-list 'company-backends 'company-restclient))


(provide 'k-restclient)
