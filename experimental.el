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
  :defer 5
  :demand t

  :init
  ;; (setq browse-url-browser-function 'eaf-open-browser) ;; make eaf as a emacs deafult browser

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
(defvar kadir/web-develop-bufer-name "Esthetic Hair Turkey | Hair Transplant Clinic in Turkey" "")
(setq kadir/web-develop-bufer-name "Esthetic Hair Turkey | Hair Transplant Clinic in Turkey")

(defun eaf-reload-page (event)
  (with-selected-window (display-buffer kadir/web-develop-bufer-name)
    (eaf-proxy-refresh_page))
  (message "Event %S" event))

(cl-loop for element in (directory-files-recursively "~/eht/templates" "")
         do (file-notify-add-watch element '(change) 'eaf-reload-page))
(cl-loop for element in (directory-files-recursively "~/eht/assets/css" "")
         do (file-notify-add-watch element '(change) 'eaf-reload-page))

(file-notify-add-watch "~/eht/assets/bulma-0.7.2/mystyles.css" '(change) 'eaf-reload-page)
(file-notify-add-watch "~/eht/assets/bulma-0.7.2/mystyles.css" '(change) 'eaf-reload-page)



(defun other-window-if-not-eaf()
  "For the when I develop the web frontent, I just want to see
the web page, don't go to that buffer."
  (interactive)
  (other-window 1)
  (when (derived-mode-p 'eaf-mode)
    (other-window 1)))

(global-set-key (kbd "M-o") 'other-window-if-not-eaf)
(global-set-key (kbd "M-O") 'other-window)

(defun delete-window-and-split-with-browser()
  (interactive)
  (delete-other-windows)
  (display-buffer kadir/web-develop-bufer-name)
  (resize-window-width 9))

(global-set-key (kbd "C-x 1") 'delete-window-and-split-with-browser)


;; some functions that commented

;; (file-notify-add-watch "~/eht/templates/main.html" '(change) 'eaf-reload-page)
;; (defun add-file-notif(file)
;;   (file-notify-add-watch file '(change) 'eaf-reload-page))

;; (cl-loop for element in (directory-files-recursively "~/eht/assets" "")
;;          do (file-notify-add-watch element '(change) 'eaf-reload-page))

;; python interpreter

(setq-default python-shell-interpreter "ipython"
              python-shell-interpreter-args "-i")

;; org-roam
(use-package org-roam
  :init
  (require 'org-roam-protocol)
  (setq org-roam-buffer-width 0.5)

  (eval-after-load 'org-roam
    '(defun org-roam--find-file (file)
       "override method because sometimes find-file can't get the true window"
       (other-window 1)
       (message "kadir")
       (find-file file))
    )

  (defun kadir/org-roam-disable-activate-roam (funct extra_arg_p &rest args)
    "It close roam backlink page, run function, open backlink page"
    (interactive "P")
    (pcase (org-roam-buffer--visibility)

      ('visible
       (delete-window (get-buffer-window org-roam-buffer))
       (if extra_arg_p (funcall funct args) (funcall funct))
       (pcase (org-roam-buffer--visibility)
         ((or 'exists 'none)
          (org-roam))))

      ((or 'exists 'none)
       (progn
         (if extra_arg_p (funcall funct args) (funcall funct))
         (org-roam-buffer--get-create)))))

  (defun kadir/org-roam-dailies-today (&rest args)
    "override org-roam-dailies because of the new frame bug?? ı dont know is it bug or something"
    (interactive)
    (kadir/org-roam-disable-activate-roam 'org-roam-dailies-today nil args))

  (defun kadir/org-roam-insert (&rest args)
    "override org-roam-dailies because of the new frame bug?? ı dont know is it bug or something"
    (interactive "P")
    (kadir/org-roam-disable-activate-roam 'org-roam-insert t args))

  
  :hook 
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Dropbox/org-roam/")
  :bind (:map org-roam-mode-map
              (("ö r l" . org-roam)
               ("ö r f" . org-roam-find-file)
               ("ö r t" . kadir/org-roam-dailies-today)
               ("ö r g" . org-roam-show-graph))
              :map org-mode-map
              (("ö r i" . kadir/org-roam-insert))))

;; company org-roam
(let ((default-directory "~/.emacs.d/gits/"))
  (normal-top-level-add-subdirs-to-load-path))
(require 'company-org-roam)
(push 'company-org-roam company-backends)

;; deft for find somethings
(use-package deft
  :defer nil
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/org-roam/")
  (deft-use-filename-as-title nil))


(add-hook 'after-save-hook (lambda()
                             (interactive)
                             (when (equal (buffer-file-name) "/home/kadir/bitirme_tezi/sunum.org")
                               (org-reveal-export-to-html)
                               )))

(use-package ein
  :init
  (setq ein:output-area-inlined-images t))

;;;;;;;;;;;;;;;;;;;

(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode)
 '("\\.mlx" . matlab-mode)
 )
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))
(global-set-key (kbd "C-c k") 'web-mode-element-close)

;;;;;;;;;;;;;;,,;;;;;;;;;;;;;;

(add-to-list 'eglot-server-programs '((tex-mode context-mode texinfo-mode bibtex-mode)
                                      . ("digestif")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq doc-view-continuous t)


(use-package pdf-tools
  ;; :load-path "/usr/share/emacs/site-lisp/pdf-tools/pdf-tools.el"
  :defer nil
  ;; :demand t
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))


(use-package org-roam-server
  :ensure t)


(use-package buffer-flip
  :ensure t
  :bind  (("M-<SPC>" . buffer-flip)
          :map buffer-flip-map
          ( "M-<SPC>" .   buffer-flip-forward) 
          ( "M-S-<SPC>" . buffer-flip-backward) 
          ( "M-g" .     buffer-flip-abort))
  :config
  (setq buffer-flip-skip-patterns
        '("^\\*helm\\b"
          "^\\*swiper\\*$")))
