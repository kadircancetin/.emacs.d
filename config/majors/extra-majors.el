(require 'use-package)

(defun kadir/restclient-send()
  (interactive)
  (restclient-http-send-current-stay-in-window)
  (sleep-for 0.2)
  (other-window 1)
  (json-mode-beautify)
  (other-window -1)
  (message "Attım geldim"))


(use-package json-mode)
(use-package json-navigator
  :after json-mode)


(use-package company-restclient
  :commands (json-mode-beautify)
  :after (company restclient)
  :config (add-to-list 'company-backends 'company-restclient))

(use-package restclient
  :commands (restclient-http-send-current restclient-http-send-current-stay-in-window)
  :init
  (add-to-list 'auto-mode-alist '("\\(\\.http\\'\\)" . restclient-mode))
  :config
  (setcdr (assoc "application/json" restclient-content-type-modes) 'json-mode)
  :bind ((:map restclient-mode-map
               ("C-c C-c" . 'kadir/restclient-send)
               ("C-c C-v" . 'restclient-http-send-current))))


(use-package sass-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))


(use-package yaml-mode)
(use-package docker-compose-mode :mode "docker-compose.*\.yml\\'")
(use-package dockerfile-mode :mode "Dockerfile[a-zA-Z.-]*\\'")
(use-package terraform-mode :mode ("\\.tf\\'" . terraform-mode))


(use-package ein
  :init
  (setq-default ein:output-area-inlined-images t))


(use-package pdf-tools
  ;; :load-path "/usr/share/emacs/site-lisp/pdf-tools/pdf-tools.el"
  ;; :demand t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :commands pdf-tools-install
  :config
  (pdf-tools-install) ;; initialise
  (setq-default pdf-view-display-size 'fit-page)   ;; open pdfs scaled to fit page
  ;; automatically annotate highlights
  (setq-default pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))



(provide 'extra-majors)
