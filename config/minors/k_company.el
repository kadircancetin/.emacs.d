(require 'use-package)

(use-package company
  :defer nil
  :init
  (setq-default company-idle-delay 0
                company-minimum-prefix-length 1

                company-tooltip-idle-delay 0
                company-tooltip-limit      7
                company-tooltip-minimum-width 35
                company-tooltip-margin     1
                company-tooltip-offset-display 'lines

                company-dabbrev-downcase   nil
                company-dabbrev-other-buffers nil
                company-dabbrev-ignore-case nil
                company-echo-delay 0                ; remove annoying blinking
                company-tooltip-align-annotations t

                company-require-match 'never

                company-auto-complete-chars nil)
  :bind ((:map company-active-map
               ([return] . nil)
               ("RET" . nil)
               ("TAB" . company-complete-selection)
               ("<tab>" . company-complete-selection)
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous))
         (:map company-mode-map ("C-." . helm-company))
         )
  :config
  (global-company-mode 1)

  ;; make company work on char deleteion
  (add-to-list 'company-begin-commands 'backward-delete-char-untabify)

  (progn
    ;; https://emacs.stackexchange.com/questions/17537/best-company-backends-lists
    (load-file (expand-file-name "company-try-hard.el" user-emacs-directory))))


(use-package helm-company)

(use-package company-statistics
  :hook (global-company-mode . company-statistics-mode))

(provide 'k_company)
