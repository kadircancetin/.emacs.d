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


(use-package benchmark-init :ensure t)


;; NOTE: very long emacs shutdown time when it is activated
;; (use-package back-button
;;   :init
;;   (back-button-mode 1))



(provide 'extras)
