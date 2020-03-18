(use-package deft
  :defer nil
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/org/")
  (deft-use-filename-as-title t))


;; (defhydra hydra-zoom (global-map "<f2>")
;;   "zoom"
;;   ("g" text-scale-increase "in")
;;   ("l" text-scale-decrease "out"))


(global-set-key (kbd "C-c d d") 'deft)


(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :bind (:map nov-mode-map
              ("n" . next-line)
              ("p" . previous-line)
              ("f" . forward-char)
              ("b" . backward-char)
              ("h" . nov-previous-document)
              ("l" . nov-next-document)
              ("c" . google-translate-at-point)
              )
  )

(use-package darkroom)

(use-package devdocs
  :init
  ;; disabled devdocs-alist because of sometimes I search from
  ;; framework but it search in the major mode
  (setq devdocs-alist nil))

(use-package eaf
  :load-path "/usr/share/emacs/site-lisp/eaf"
  :demand t

  :init
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-browser)

  :custom
  (eaf-find-alternate-file-in-dired t)

  :config
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)

  ;; browser
  (eaf-setq eaf-browser-default-zoom "0.8")
  (eaf-bind-key other-window "M-o" eaf-browser-keybinding)
  (eaf-bind-key refresh_page "<f1>" eaf-browser-keybinding))


(require 'filenotify)


;; örnek html kullanımı
(defvar kadir/web-develop-bufer-name "reload" "")
(setq kadir/web-develop-bufer-name "reload")
(defun eaf-reload-page (event)
  (with-selected-window (display-buffer kadir/web-develop-bufer-name)
    (eaf-proxy-refresh_page))
  (message "Event %S" event))

(cl-loop for element in (directory-files-recursively "~/eht/templates" "")
         do (file-notify-add-watch element '(change) 'eaf-reload-page))

(file-notify-add-watch "~/eht/assets/bulma-0.7.2/mystyles.css" '(change) 'eaf-reload-page)



(defun other-window-if-not-eaf()
  "For the when I develop the web frontent, I just want to see
the web page, don't go to that buffer."
  (interactive)
  (other-window 1)
  (when (derived-mode-p 'eaf-mode)
    (other-window 1)))

(global-set-key (kbd "M-o") 'other-window-if-not-eaf)


;; some functions that commented

;; (file-notify-add-watch "~/eht/templates/main.html" '(change) 'eaf-reload-page)
;; (defun add-file-notif(file)
;;   (file-notify-add-watch file '(change) 'eaf-reload-page))

;; (cl-loop for element in (directory-files-recursively "~/eht/assets" "")
;;          do (file-notify-add-watch element '(change) 'eaf-reload-page))
