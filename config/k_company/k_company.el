(use-package company
  :init
  (setq-default company-idle-delay 0.25
                company-tooltip-idle-delay 0.3
                company-tooltip-limit      7
                company-tooltip-minimum-width 35
                company-dabbrev-downcase   nil
                company-dabbrev-ignore-case nil
                company-tooltip-margin     1
                company-tooltip-offset-display 'lines
                company-minimum-prefix-length 1
                company-echo-delay 0                ; remove annoying blinking
                company-tooltip-align-annotations t

                company-require-match 'never
                ;; company-frontends '(company-pseudo-tooltip-frontend
                ;;                     company-echo-metadata-frontend)

                company-auto-complete-chars nil

                )
  
  :defer 0.1
  :bind ((:map company-active-map
               ([return] . nil)
               ("RET" . nil)
               ("TAB" . company-complete-selection)
               ("<tab>" . company-complete-selection)
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous))
         ;; (:map company-mode-map ("C-." . helm-company))
         )
  :config
  ;; (use-package company-tabnine :defer nil)
  (global-company-mode 1)
  (progn
    ;; genişletmek istediğimde şuarsı güzel kaynak:
    ;; https://emacs.stackexchange.com/questions/17537/best-company-backends-lists
    (setq company-backends
          '(company-capf
            company-files
            (company-dabbrev-code company-gtags company-etags
                                  company-keywords)
            company-dabbrev)))
  (load-file (expand-file-name "company-try-hard.el" user-emacs-directory)))

(use-package company-posframe
  :hook (company-mode . company-posframe-mode)
  :init
  (setq company-posframe-quickhelp-delay 0
        company-posframe-show-indicator nil
        company-posframe-show-metadata nil
        company-posframe-quickhelp-show-header nil
        company-posframe-quickhelp-x-offset 5
        ;; company-posframe-quickhelp-buffer "company-posframe-quickhelp-buffer.md"
        )
  (defun kadir/quickhelp-position(&rest rest)
    (if (and (< (car (window-absolute-pixel-position)) 200)
             (< (cdr (window-absolute-pixel-position)) 200))
        (company-posframe-quickhelp-right-poshandler rest)
      '(5 . 5)))

  (setq company-posframe-quickhelp-show-params
        (list :poshandler 'kadir/quickhelp-position
              :internal-border-width 2
              :timeout 60
              :internal-border-color "white"
              :no-properties nil))

  ;; (setq posframe-arghandler #'my-posframe-arghandler)
  ;; (defun my-posframe-arghandler (buffer-or-name arg-name value)
  ;;   (let ((info '(:internal-border-width 1 :internal-border-color "white")))
  ;;     (or (plist-get info arg-name) value)))

  :bind
  (:map company-posframe-active-map
        ("M-p" . 'company-posframe-quickhelp-scroll-down)
        ("M-n" . 'company-posframe-quickhelp-scroll-up)
        ("M-h" . 'company-posframe-quickhelp-toggle )
        ("C-." . 'helm-company)))

(use-package helm-company)

(use-package company-statistics
  :hook (company-mode . company-statistics-mode))

(provide 'k_company)
