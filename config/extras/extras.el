(use-package dashboard
  :init
  (setq dashboard-banner-logo-title   nil
        dashboard-center-content      t
        ;; dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-startup-banner      'logo
        dashboard-set-navigator    t
        dashboard-set-init-info       t
        dashboard-set-footer          nil
        )
  ;; Format: "(icon title help action face prefix suffix)"
  (setq dashboard-navigator-buttons
        `(;; line1
          (
           (,nil
            "Agenda"
            "Agenda"
            (lambda (&rest _) (org-agenda)))
           )
          (("EMACS HELP" "" "?/h" (lambda (&rest _) (info "emacs")) nil "<" ">"))
          ))
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 10)
                          (registers . 5)))
  (dashboard-setup-startup-hook)
  )


(use-package shell-pop
  :defer 0.5
  :init
  (setq shell-pop-shell-type '("aweshell" "aweshell*" (lambda () (eshell)))
        shell-pop-window-size 40))


(use-package bm)
(use-package helm-bm)


(use-package dumb-jump
  :init
  (setq dumb-jump-prefer-searcher 'rg
        dumb-jump-force-searcher  'rg
        dumb-jump-selector 'helm))



(use-package anzu ; TODO: anzu mode ve isearch yarı fuzzy olunca eşleşmiyor
  :defer 1
  :config
  (global-anzu-mode 1))
(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr")
  :config
  ;; unmerged bug fixes
  ;; https://github.com/atykhonov/google-translate/issues/98
  (defun google-translate-json-suggestion (json)
    "Retrieve from JSON (which returns by the
`google-translate-request' function) suggestion. This function
does matter when translating misspelled word. So instead of
translation it is possible to get suggestion."
    (let ((info (aref json 7)))
      (if (and info (> (length info) 0))
          (aref info 1)
        nil)))
  )


(use-package which-key
  :defer 3
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.8))


;; (use-package benchmark-init :ensure t) ;; TODO: activate


;; NOTE: very long emacs shutdown time when it is activated
;; (use-package back-button
;;   :init
;;   (back-button-mode 1))


(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                 (match-string 1))))))

;; (define-key dired-mode-map (kbd "?") 'dired-get-size)

(use-package disk-usage)

(use-package pdf-tools
  ;; :load-path "/usr/share/emacs/site-lisp/pdf-tools/pdf-tools.el"
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

(use-package devdocs
  :init
  ;; disabled devdocs-alist because of sometimes I search from
  ;; framework but it search in the major mode
  (setq devdocs-alist nil))

(use-package buffer-flip
  :ensure t
  :bind  (("M-<SPC>" . buffer-flip)
          :map buffer-flip-map
          ( "M-<SPC>" .   buffer-flip-forward) 
          ( "M-S-<SPC>" . buffer-flip-backward) 
          ( "C-g" .     buffer-flip-abort)
          ( "M-g" .     buffer-flip-abort)
          )
  :config
  (setq buffer-flip-skip-patterns
        '("^\\*helm\\b"
          "^\\*swiper\\*$")))


(provide 'extras)
