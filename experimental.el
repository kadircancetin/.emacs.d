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

;; (use-package selectrum)
;; (use-package selectrum-prescient-mode)
;; (use-package prescient)

;; (selectrum-mode +1)
;; (selectrum-prescient-mode +1)
;; (prescient-persist-mode +1)

;; (setq selectrum-num-candidates-displayed 20
;;       selectrum-fix-minibuffer-height t
;;       selectrum-count-style 'current/matches
;;       selectrum-show-indices nil
;;       )
;; (setq projectile-completion-system 'default)


;; (defun recentf-open-files+ ()
;;   "Use `completing-read' to open a recent file."
;;   (interactive)
;;   (let ((files (mapcar 'abbreviate-file-name recentf-list)))
;;     (find-file (completing-read "Find recent file: " files nil t))))


;;; İDEA: https://www.reddit.com/r/emacs/comments/hqxm5v/weekly_tipstricketc_thread/fy0xduj?utm_source=share&utm_medium=web2x



;; ((defun typo-suggest--hippie-expand (old)
;;    (unless old
;;      (he-init-string (beginning-of-thing 'word) (end-of-thing 'word))
;;      (setq he-expand-list (typo-suggest--results he-search-string)))
;;    (if (null he-expand-list)
;;        (progn
;;          (when old (he-reset-string))
;;          ())
;;      (he-substitute-string (car he-expand-list) t)
;;      (setq he-tried-table (cons (car he-expand-list) (cdr he-tried-table)))
;;      (setq he-expand-list (cdr he-expand-list))
;;      t))
;;  )
;; (setq hippie-expand-try-functions-list '(typo-suggest--hippie-expand))
;; (global-set-key (kbd "C-ü") 'typo-suggest-company)




(use-package typo-suggest
  :straight (typo-suggest
             :type git
             :host github
             :repo "kadircancetin/typo-suggest"
             :branch "develop"
             )
  :init
  (require 'typo-suggest)
  (setq typo-suggest-default-search-method 'datamuse))

;; (setq company-backends '(typo-suggest-company))

;; (setq company-backends '(;;typo-suggest-company
;;                          company-restclient
;;                          company-capf company-files
;;                          (company-dabbrev-code company-gtags company-etags company-keywords)
;;                          company-dabbrev
;;                          typo-suggest-company))

(global-set-key (kbd "M-ü") 'typo-suggest-helm)
(global-set-key (kbd "C-c 3") 'hippie-expand)


;; (setq ispell-program-name "aspell")
;; (setq ispell-complete-word-dict "/home/kadir/Desktop/files/SINGLE.TXT")

;; (require 'ispell)

;; (start-process
;;  "k"
;;  nil
;;  "sleep"
;;  "1")



;; (helm :sources
;;       (helm-build-async-source "Helm Word"
;;         :candidates-process
;;         (lambda ()
;;           (let ((default-directory "/home/kadir/Desktop/files"))
;;             (start-process "kadir"
;;                            nil
;;                            "rg"
;;                            (proc-input helm-input)
;;                            "--ignore-case"
;;                            "--no-heading"
;;                            "--no-filename"
;;                            "--no-line-number"
;;                            "--block-buffered"
;;                            ;;"--no-config"
;;                            )))
;;         :action '(("Insert" . insert)))
;;       :buffer "*helm test*"
;;       :input "kad")


;; (defun proc-input(input)
;;   (let ((k nil))
;;     (setq k (s-join ".*" (mapcar
;;                           (lambda (char)
;;                             (when (/= char ? )
;;                               (char-to-string  char))
;;                             )
;;                           input)))
;;     k))


;; (helm :sources
;;       (helm-build-async-source "Helm Word"
;;         :candidates-process
;;         (lambda ()
;;           (let ((default-directory "/home/kadir/Desktop/files"))
;;             (start-process "kadir"
;;                            nil
;;                            "bash"
;;                            "-c"
;;                            (format "%s" "echo mk | ispell -a"))))
;;         :action '(("Insert" . insert)))
;;       :buffer "*helm test*"
;;       :input "kad")

;; (use-package god-mode)
;; (god-mode)

;; (global-set-key (kbd "C-ü") #'god-mode-all)
;; (global-set-key (kbd "ü") #'god-mode-all)
;; (setq god-mode-enable-function-key-translation nil)

;; (defun my-god-mode-update-cursor ()
;;   (setq cursor-type (if (or god-local-mode buffer-read-only)
;;                         'box
;;                       'bar)))

;; (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
;; (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

(use-package modalka
  :init
  ;; (modalka-global-mode 1)

  (add-to-list 'modalka-excluded-modes '('magit-status-mode
                                         'helm-mode))


  (global-set-key (kbd "<return>") #'modalka-global-mode)
  (setq modalka-cursor-type '(hbar . 2)) ;; (setq-default cursor-type '(bar . 1))

  (advice-add 'self-insert-command
              :before
              (lambda (&rest r)
                (when (and (bound-and-true-p modalka-global-mode)
                           (cdr r))
                  (error "MODALKA MODALKA MODALKA MODALKA MODALKA MODALKA MODALKA"))))
  (progn
    ;; general
    (modalka-define-kbd "g" "C-g")

    ;; kill - yank
    (modalka-define-kbd "Y" "M-y")
    (modalka-define-kbd "w" "M-w")
    (modalka-define-kbd "k" "C-k")
    (modalka-define-kbd "y" "C-y")
    ;; (modalka-define-kbd "SPC" "C-SPC")

    ;; goto source - pop
    (modalka-define-kbd "." "M-.")
    (modalka-define-kbd "," "M-,")

    ;; editing
    (modalka-define-kbd "m" "C-m")
    (modalka-define-kbd "d" "C-d")
    (modalka-define-kbd "o" "C-o")
    (modalka-define-kbd "h" "<DEL>")
    (modalka-define-kbd "u" "C-_")
    (modalka-define-kbd "U" "M-_")

    ;; movement
    (modalka-define-kbd "a" "C-a")
    (modalka-define-kbd "b" "C-b")
    (modalka-define-kbd "e" "C-e")
    (modalka-define-kbd "f" "C-f")
    (modalka-define-kbd "n" "C-n")
    (modalka-define-kbd "p" "C-p")

    ;; viewving
    (modalka-define-kbd "l" "C-l")
    (modalka-define-kbd "v" "C-v")
    (modalka-define-kbd "V" "M-v")

    ;; file
    (modalka-define-kbd "xs" "C-x C-s")

    ;; window
    (modalka-define-kbd "0" "C-x 0")
    (modalka-define-kbd "1" "C-x 1")
    (modalka-define-kbd "2" "C-x 2")
    (modalka-define-kbd "3" "C-x 3")
    (modalka-define-kbd "4." "C-x 4")

    ;; buffer
    (modalka-define-kbd "xk" "C-x C-k")
    (modalka-define-kbd "<SPC>" "M-<SPC>")

    ;;;;;;;;;;;;;; major modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; elisp
    (modalka-define-kbd "xe" "C-x C-e")))

(use-package dired-sidebar)

(use-package org-super-agenda
  :init
  (org-super-agenda-mode)

  :config
  (setq org-agenda-sorting-strategy '(priority-down))


  (defun kadir/agenda()
    (interactive)
    (setq org-super-agenda-groups
          '(
            (:name "Çokomelli" :and (:scheduled nil :priority "A"))

            ;; OTHERS for file grouping
            (:name "HİPO" :and (:file-path ".*hipo.*"))

            ;; general groups
            (:name "Önemli" :and (:scheduled nil :priority "B"))
            (:name "EMACS" :and (:scheduled nil :tag "emacs"))
            (:name "Estheticana" :and (:scheduled nil :file-path ".*estheticana.org"))

            ;; OTHERS for file grouping
            (:name "Refile" :scheduled nil :file-path ".*inbox.org")

            ;; OTHErS for time grouping
            (:name "TOMORROW" :scheduled future :order 10)
            (:name "Feature" :scheduled today :time-grid t)))

    (let ((org-agenda-span 'day))
      (org-agenda nil "n")))
  )



(use-package smart-jump
  :defer 1
  :init
  (setq smart-jump-default-mode-list 'python-mode)
  :config
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'xref-find-definitions
                       :pop-fn 'xref-pop-marker-stack
                       :refs-fn 'xref-find-references
                       :should-jump t
                       :heuristic 'error
                       :async nil
                       :order 1)
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'dumb-jump-go
                       :pop-fn 'xref-pop-marker-stack
                       :should-jump t
                       :heuristic 'point
                       :async nil
                       :order 2))

(use-package pony-mode)
