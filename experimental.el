;; (use-package nov
;;   :init
;;   (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;;   :bind (:map nov-mode-map
;;               ("n" . next-line)
;;               ("p" . previous-line)
;;               ("f" . forward-char)
;;               ("b" . backward-char)
;;               ("h" . nov-previous-document)
;;               ("l" . nov-next-document)
;;               ("c" . google-translate-at-point)
;;               ))


;; (use-package eaf
;;   :load-path "/usr/share/emacs/site-lisp/eaf"
;;   :defer 5
;;   :demand t

;;   :init
;;   ;; (setq browse-url-browser-function 'eaf-open-browser) ;; make eaf as a emacs deafult browser

;;   (defalias 'browse-web #'eaf-open-browser)

;;   :custom
;;   (eaf-find-alternate-file-in-dired t)

;;   :config
;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)

;;   ;; browser
;;   (eaf-setq eaf-browser-default-zoom "0.8")
;;   (eaf-bind-key other-window "M-o" eaf-browser-keybinding)
;;   (eaf-bind-key refresh_page "<f1>" eaf-browser-keybinding))



;; (global-set-key (kbd "C-q") 'avy-goto-char-timer)

