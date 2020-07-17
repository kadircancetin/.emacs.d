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
(setq company-backends '(;;typo-suggest-company
                         company-restclient
                         company-capf company-files
                         (company-dabbrev-code company-gtags company-etags company-keywords)
                         company-dabbrev ))


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
