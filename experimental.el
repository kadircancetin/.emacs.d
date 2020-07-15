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
(require 'cl-lib)
(require 'hippie-exp)


(defgroup helm-word nil
  "Fix the typos"
  :group 'matching
  :group 'helm)

(defcustom helm-word-suggestion-count 20
  "Number of suggestion for 'helm and company completion"
  :type 'integer)

(defcustom helm-word-timeout 10
  "Timeout second to connection server time."
  :type 'integer)



(defun helm-word--fetch-results (query)
  (with-current-buffer
      (url-retrieve-synchronously
       (format "https://api.datamuse.com/sug?max=%s&s=%s"
               helm-word-suggestion-count query)
       nil t helm-word-timeout)
    ;; TODO: show error or something to user if bigger than 1 sec
    (goto-char (point-min))
    (re-search-forward "^$")
    (delete-region (point)(point-min))(buffer-string)))

(defun helm-word--results (str)
  (mapcar 'cdr (mapcar 'car (json-read-from-string  (helm-word--fetch-results str)))))


(defun helm-word--replace-word(x)
  (interactive)
  (save-excursion
    (let ((beg nil))
      (delete-region (beginning-of-thing 'word) (end-of-thing 'word))
      (insert x))))

(defun helm-func(&optional arg)
  (helm-word--results helm-input))

(defconst helm-word-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map helm-map)
    (define-key map (kbd "C-c u") #'helm-word--replace-word)
    ;; TODO: <TAB> f2 work but shortcat does not
    map)
  "Keymap for `helm-word'.")


(defun helm-word--do-helm(input)
  (helm :sources
        (helm-build-sync-source "Helm Word"
          :candidates #'helm-func
          :fuzzy-match nil
          :action '(("Insert" . insert)
                    ("Update Word" . helm-word--replace-word))
          :volatile t
          :must-match t
          :keymap helm-word-map
          ;; :nohighlight t
          :match-dynamic t)
        :buffer "*helm test*"
        :input input))

(defun helm-word()
  (interactive)
  (helm-word--do-helm (thing-at-point 'word)))


(defun helm-word-company (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'helm-word-company))
    (prefix (company-grab-symbol))
    (candidates  (helm-word--results arg))
    (no-cache t)
    (require-match nil)
    (meta (format "Word search %s" arg))))

(setq company-backends '(;;helm-word-company
                         company-restclient
                         company-capf company-files
                         (company-dabbrev-code company-gtags company-etags company-keywords)
                         company-dabbrev ))




(defun helm-word--hippie-expand (old)
  (unless old
    (he-init-string (beginning-of-thing 'word) (end-of-thing 'word))
    (setq he-expand-list (helm-word--results he-search-string)))
  (if (null he-expand-list)
      (progn
        (when old (he-reset-string))
        ())
    (he-substitute-string (car he-expand-list) t)
    (setq he-tried-table (cons (car he-expand-list) (cdr he-tried-table)))
    (setq he-expand-list (cdr he-expand-list))
    t))


(setq hippie-expand-try-functions-list '(helm-word--hippie-expand))

(setq company-backends '(;;helm-word-company
                         company-restclient
                         company-capf company-files
                         (company-dabbrev-code company-gtags company-etags company-keywords)
                         company-dabbrev ))

(global-set-key (kbd "C-ü") 'helm-word-company)
(global-set-key (kbd "M-ü") 'helm-word)
(global-set-key (kbd "C-c 3") 'hippie-expand)
