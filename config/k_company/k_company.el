(require 'use-package)
(use-package company
  :init
  (setq-default company-idle-delay 0
                company-minimum-prefix-length 1

                company-tooltip-idle-delay nil
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
    ;; https://emacs.stackexchange.com/questions/17537/best-company-backends-lists
    (load-file (expand-file-name "company-try-hard.el" user-emacs-directory))))


(use-package helm-company)

;; (use-package company-statistics
;;   :hook (company-mode . company-statistics-mode))

(provide 'k_company)
