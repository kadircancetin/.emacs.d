(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)






(load-file (expand-file-name "side-window.el" user-emacs-directory))




(defun make-peek-frame (find-definition-function &rest args)
  ;; main source: https://tuhdo.github.io/emacs-frame-peek.html
  "Make a new frame for peeking definition"
  (interactive)
  (let* (doc-frame
         (abs-pixel-pos (save-excursion
                          (beginning-of-thing 'symbol)
                          (window-absolute-pixel-position)))
         (x (car abs-pixel-pos))
         (y (+ (cdr abs-pixel-pos) (frame-char-height))))

    (setq doc-frame (make-frame '((minibuffer . nil)
                                  (name . "*RTags Peek*")
                                  (width . 89)
                                  (visibility . nil)
                                  (height . 25))))

    (when (> y 550) (setq y (- y 330)))
    (when (< y 0 ) (setq y 0))
    (when (> x 800) (setq x (- x 200)))
    (when (< x 0 ) (setq x 0))

    (set-frame-position doc-frame x y)
    (with-selected-frame doc-frame
      (call-interactively find-definition-function))
    (make-frame-visible doc-frame)))



(defun lsp-peek-frame()
  (interactive)
  (make-peek-frame 'lsp-find-definition))

(global-set-key (kbd "s-.") 'lsp-peek-frame)
(global-set-key (kbd "s-,") '(lambda()(interactive)
                               (xref-pop-marker-stack)
                               (delete-frame)))


(setq kadir/last-next-line-count 0)
(setq kadir/jit-lock-defer-time 0.1)

(defun kadir/post-command(command N)
  (lexical-let ((command command)
                (kadir/last-next-line-count kadir/last-next-line-count)
                (N N))


    (run-with-idle-timer 0.1 t (lambda () (setq kadir/last-next-line-count 0)))

    (lambda()
      (if (eq last-command command)
          (progn
            (setq kadir/last-next-line-count (+ kadir/last-next-line-count 1))

            (when (> kadir/last-next-line-count N)
              (setq jit-lock-defer-time 0)
              (condition-case nil

                  (dotimes (i (min (/ kadir/last-next-line-count N) 10))
                    (funcall (symbol-function command)))

                (error nil))))

        (setq jit-lock-defer-time kadir/jit-lock-defer-time)
        (setq kadir/last-next-line-count 0)))))


(add-hook 'post-command-hook (kadir/post-command 'next-line 45))
(add-hook 'post-command-hook (kadir/post-command 'forward-char 45))
(add-hook 'post-command-hook (kadir/post-command 'backward-char 45))
(add-hook 'post-command-hook (kadir/post-command 'previous-line 45))
(add-hook 'post-command-hook (kadir/post-command 'scroll-up-command 4))
(add-hook 'post-command-hook (kadir/post-command 'scroll-down-command 4))
(remove-hook 'post-command-hook 'kadir/post-command)

(defun kadir/buffer-local-disable-jit-defering()
  (make-variable-buffer-local 'kadir/jit-lock-defer-time)
  (setq kadir/jit-lock-defer-time 0))



;; (electric-pair-mode)
;; (setq electric-pair-preserve-balance nil)


;; (defun lsp--create-filter-function (workspace)(prin1 workspace))

(use-package company-tabnine
  :defer 20
  :init
  (defun kadir/company-tabnine-disable()
    (interactive)
    (setq company-backends (remove 'company-tabnine company-backends)))

  (defun kadir/company-tabnine-enable()
    (interactive)
    (set (make-local-variable 'company-idle-delay) .15)
    (set (make-local-variable 'company-tooltip-idle-delay) .15)
    (set (make-local-variable 'company-echo-delay) .15)
    (set (make-local-variable 'company-backends ) '(company-tabnine))
    (set (make-local-variable 'lsp-completion-provider ) :none)
    )

  (setq company-tabnine--disable-next-transform nil)
  (defun my-company--transform-candidates (func &rest args)
    (if (not company-tabnine--disable-next-transform)
        (apply func args)
      (setq company-tabnine--disable-next-transform nil)
      (car args)))

  (defun my-company-tabnine (func &rest args)
    (when (eq (car args) 'candidates)
      (setq company-tabnine--disable-next-transform t))
    (apply func args))

  (advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
  (advice-add #'company-tabnine :around #'my-company-tabnine))

;; (defun kadir/format-haha()
;;   (interactive)
;;   (kadir/dired-smart-open)
;;   (lsp-format-buffer)
;;   (save-buffer)
;;   (kadir/last-buffer)
;;   (next-line)
;;   )
;; (global-set-key (kbd "C-ü") 'kadir/format-haha)


;; (require 'git-file-tree)
;; ;; (memory-report)
;; ;; company-keywords-alist
;; ;; thai-word-table



(use-package too-long-lines-mode
  :straight (too-long-lines-mode :type git :host github :repo "rakete/too-long-lines-mode")

  :init
  (load-file (expand-file-name "straight/repos/too-long-lines-mode/too-long-lines-mode.el" user-emacs-directory))

  (setq too-long-lines-threshold 600)
  (setq too-long-lines-show-number-of-characters 120)
  (setq too-long-lines-special-buffer-modes '(json-mode eshell-mode))
  (setq too-long-lines-idle-seconds 10)

  (defun kadir/activate-too-long-lines()
    (interactive)
    (too-long-lines-mode t)
    (toggle-truncate-lines 1)
    (set (make-variable-buffer-local 'column-number-mode) nil)
    (set (make-variable-buffer-local 'global-hl-line-mode) nil)
    (set (make-variable-buffer-local 'line-number-mode) nil)
    (setq-local bidi-inhibit-bpa t))

  (defun kadir/dactivate-too-long-lines()
    (interactive)
    (too-long-lines-mode 0)
    (toggle-truncate-lines -1)
    (set (make-variable-buffer-local 'column-number-mode) 1)
    (set (make-variable-buffer-local 'global-hl-line-mode) 1)
    (set (make-variable-buffer-local 'line-number-mode) 1)
    (setq-local bidi-inhibit-bpa nil))

  (kadir/activate-too-long-lines))


(column-number-mode 0)



(use-package perspective
  :defer 0.1
  :custom
  (persp-mode-prefix-key (kbd "M-m p"))
  (persp-state-default-file (no-littering-expand-var-file-name "perspective.el"))
  :bind*
  ( :map persp-mode-map
    ("C-x p" . persp-switch)
    ("C-x C-p" . persp-switch-quick)
    ("C-M-SPC" . persp-switch-last)
    :map perspective-map
    ("p" . persp-switch)
    ("k" . persp-kill)
    ("q" . persp-switch-quick)
    ("n" . (lambda () (interactive) (persp-switch (make-temp-name "p-")))))
  :hook
  (kill-emacs . persp-state-save)

  :config
  (persp-mode)
  ;; (persp-state-load (no-littering-expand-var-file-name "perspective.el"))
  )



(use-package which-key
  :defer 3
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 1))



(use-package eros
  :defer 2
  :config
  (eros-mode 1))



(defun buffer-shown-in-a-window?(buf)
  "Return t if buffer shown in any window"
  (if (member buf (mapcar (lambda (wind) (window-buffer wind)) (window-list))) t nil))


;; (global-set-key (kbd "C-x t g")
;;                 (lambda ()
;;                   (interactive)
;;                   (kadir/open-updater)
;;                   (select-window (get-buffer-window refresh-buff))
;;                   (kadir-tree-mode)))

;; 

;; Put backup files neatly away
(let ((backup-dir "~/tmp/emacs/backups")
      (auto-saves-dir "~/tmp/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too



(use-package blamer
  :ensure t
  :defer 200
  :custom
  (blamer-type 'both)
  (blamer-min-offset 70)
  (blamer-datetime-formatter " [%s] ")
  (blamer-author-formatter "%s")
  (blamer-commit-formatter "%s")
  (blamer-max-commit-message-length 3500)
  (blamer-max-lines 500)
  (blamer-uncommitted-changes-message "-- NO COMMIT --")
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :background nil
                   ;; :height 89
                   :italic t)))

  :init
  (defun kadir/blame-line-or-region()
    (interactive)
    (require 'blamer)
    (message "blame")
    (setq blamer-idle-time 0)
    (blamer--try-render)
    (add-hook 'pre-command-hook 'kadir/blame-line-or-region--reset-state-hook nil t))
  :config
  ;; (global-blamer-mode 0)
  (defun kadir/blame-line-or-region--reset-state-hook()
    (message "rest")
    (blamer--reset-state)
    (remove-hook 'pre-command-hook 'kadir/blame-line-or-region--reset-state-hook t)))



(setq create-lockfiles nil)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; very bad vc-msg copy paste for directly copy git commit link
(defun kadir/copy-git-commit-url()
  (interactive)
  (require 'vc-msg)
  (let* ((plugin (vc-msg-find-plugin))
         (current-file (funcall vc-msg-get-current-file-function))
         (executer (plist-get plugin :execute))
         (commit-info (and current-file
                           (funcall executer
                                    current-file
                                    (funcall vc-msg-get-line-num-function)
                                    (funcall vc-msg-get-version-function)))))


    (setq vc-msg-previous-commit-info commit-info)

    (let* ((info vc-msg-previous-commit-info))
      (with-temp-buffer
        (insert (plist-get info :id))
        (call-interactively 'git-link-commit)))))



;; (use-package rainbow-blocks)
(use-package prism)
;; (use-package darkroom)



(defun uuid-kadir ()
  (interactive)
  ;; (insert (format "\"%x\"" (random 100000)))
  (insert (format "%s" (random 100000))))



(use-package vertico
  :defer 0.3
  :init
  (setq vertico-count 20)
  :config
  (savehist-mode)
  (vertico-mode))

(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


;; (use-package consult
;;   ;; Replace bindings. Lazily loaded due by `use-package'.
;;   :bind (
;;          ("C-c m" . consult-mode-command)
;;          ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
;;          ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
;;          ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
;;          ("C-x f" . projectile-find-file)
;;          ;; ("M-y" . consult-yank-pop)                ;; orig. yank-pop
;;          ("M-g g" . consult-goto-line)             ;; orig. goto-line
;;          ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
;;          ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
;;          ("M-g i" . consult-imenu)
;;          ("M-g I" . consult-imenu-multi))

;;   :hook (completion-list-mode . consult-preview-at-point-mode)
;;   )



(use-package marginalia
  :init
  (define-key minibuffer-local-map (kbd "M-f") #'marginalia-cycle)
  (marginalia-mode))



(use-package f
  :init
  (load-file (expand-file-name (format "%sstraight/repos/f.el/f-shortdoc.el" user-emacs-directory)))
  (require 'f-shortdoc))


(pixel-scroll-precision-mode 1)



(use-package nix-mode
  :mode "\\.nix\\'")


(use-package sql-indent
  :hook (sql-mode . sqlind-minor-mode))

(use-package sqlformat
  :after sql-mode
  :init
  (setq sqlformat-command 'pgformatter)
  )


(use-package devdocs)


(global-unset-key (kbd "C-z"))


(use-package view-mode
  :straight (:type built-in)
  :bind (:map view-mode-map
              ("n" . next-line)
              ("p" . previous-line)))


(use-package org-rainbow-tags
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-rainbow-tags-mode)
  )


;; (use-package emojify
;;   :hook (after-init . global-emojify-mode))



(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)




(use-package expreg )
(global-set-key (kbd "C-t") 'expreg-expand)




(use-package gptel
  :init
  (setq gptel-log-level 'debug)


  (defun kadir-gptel-groq()
    (setq gptel-model  'llama-3.3-70b-specdec
          gptel-max-tokens nil
          gptel-temperature 0
          gptel-backend (gptel-make-openai "Groq"
                          :host "api.groq.com"
                          :endpoint "/openai/v1/chat/completions"
                          :stream t
                          :key ""
                          :models
                          '("llama-3.3-70b-specdec"
                            "llama-3.1-8b-instant"
                            "llama3-70b-8192"
                            "mixtral-8x7b-32768"
                            "llama3-8b-8192"))))

  (defun kadir-gptel-openai()
    (setq gptel-model  'gpt-4o-mini-2024-07-18
          gptel-max-tokens nil
          gptel-temperature 0
          gptel-backend (gptel-make-openai "ChatGPT"
                          :stream t
                          :key ""
                          :models
                          '("gpt-4o-mini-2024-07-18"
                            "gpt-4o"
                            ))))

  (defun kadir-gptel-gemini()
    (setq gptel-model  'gemini-exp-1206
          gptel-max-tokens nil
          gptel-temperature 0
          gptel-backend (gptel-make-gemini "Gemini"
                          :stream t
                          :models
                          '("gemini-exp-1206"))))

  (defun kadir-gptel-local()
    (setq gptel-model 'phi3.5)
    (setq gptel-temperature 0)
    (setq gptel-backend (gptel-make-ollama "ollama"
                          :models '("phi3.5"
                                    "deepseek-coder-v2"
                                    "deepseek-coder:6.7b"
                                    "gemma2:2b"
                                    "llama3.1"
                                    "gemma2:9b")
                          :stream t)))

  ;; (kadir-gptel-gemini)
  (kadir-gptel-groq)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; gpt el settings
  (setq gptel-directives
        '((default     . "You are an LLM integrated within a text editor, designed to assist with brief, concise, and helpful responses.")
          (programming . "You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
          (writing     . "You are a large language model and a writing assistant. Respond concisely.")
          (chat        . "You are a large language model and a conversation partner. Respond concisely.")))

  (setq gptel-prompt-prefix-alist
        '((markdown-mode . "### --USER:\n")
          (org-mode . "*** ")
          (text-mode . "### ")))

  (setq gptel-response-prefix-alist
        '((markdown-mode . "### --ASSISTANT:\n")
          (org-mode . "")
          (text-mode . "")))

  ;; OTHERS

  (require 'gptel)
  (require 's)
  (require 'gptel-context)

  (defface gptel-kadir--user-title-font
    '((t (:foreground "YellowGreen" :height 1.3)))
    "Face for the user title in gptel-kadir."
    :group 'gptel-kadir)

  (defface gptel-kadir--assistant-title-font
    '((t (:foreground "Indianred2" :height 1.3)))
    "Face for the assistant title in gptel-kadir."
    :group 'gptel-kadir)

  (font-lock-add-keywords 'markdown-mode `(("^### --\\(USER\\):$" 1 'gptel-kadir--user-title-font prepend)) 'append)
  (font-lock-add-keywords 'markdown-mode `(("^### --\\(ASSISTANT\\):$" 1 'gptel-kadir--assistant-title-font prepend)) 'append)

  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)


  ;; mode

  (setq gptel-kadir--chat-buffer-name "gptel-kadir")

  (defun gptel-kadir--open-and-jump-buffer ()
    (interactive)
    (let ((buf gptel-kadir--chat-buffer-name))
      (unless (buffer-live-p buf)
        (gptel buf))
      (display-buffer buf '((display-buffer-in-side-window)
                            (side . right)
                            (window-width . 80)))
      (select-window (get-buffer-window buf))
      (visual-line-mode 1)
      (goto-char (point-max))))


  (defun gptel-kadir--send-or-delete-buffer()
    (interactive)
    (goto-char (point-max))
    (gptel-send)
    ;; ;; delete window if the last prompt is empty user prompt
    ;; ;; else send
    ;; (if (and
    ;;      ;; role equals USER
    ;;      (s-equals? (car (last (mapcar (lambda (x) (plist-get x :role)) (gptel--create-prompt)))) "user")
    ;;      ;; and string equals delimeter
    ;;      (s-equals? (car (last (mapcar (lambda (x) (plist-get x :content)) (gptel--create-prompt)))) (s-trim (gptel-prompt-prefix-string))))
    ;;     ;; then
    ;;     (delete-window)
    ;;   ;; else
    ;;   )
    )

  (defun gptel-kadir ()
    (interactive)
    (cond
     ((bound-and-true-p gptel-mode) (gptel-kadir--send-or-delete-buffer))
     ((region-active-p)
      (if (gptel-context--at-point)
          (gptel-context-remove)
        (gptel-context-add)))
     (t (gptel-kadir--open-and-jump-buffer))))

  (global-set-key (kbd "M-ç") 'gptel-kadir))


(use-package elysium
  :config
  (use-package smerge-mode
    :commands smerge-mode
    :hook
    (prog-mode . smerge-mode)))

(use-package beyin
  :straight (beyin :type git :host github :repo "kadircancetin/beyin")
  :init
  :config

  ;;;;;;;;;;;;;;;;;;

  (require 'company)

  (global-company-mode 1)

  (setq beyin-company-prefix "kk")

  (setq command-and-functions
        '(("-> prompt-grammar" . (lambda () (insert "Find and fix grammar issues on the given text.")))
          ("-> model-openai-4o" . (lambda () (activate-gpt-model "gpt-4o" 'kadir-gptel-openai)))
          ("-> model-openai-4o-mini" . (lambda () (activate-gpt-model "gpt-4o-mini-2024-07-18" 'kadir-gptel-openai)))
          ("-> model-gemma2-2b" . (lambda () (activate-gpt-model "gemma2:2b" 'kadir-gptel-local)))
          ("-> model-gemma2-9b" . (lambda () (activate-gpt-model "gemma2:9b" 'kadir-gptel-local)))
          ("-> model-phi3.5" . (lambda () (activate-gpt-model "phi3.5" 'kadir-gptel-local)))
          ("-> model-llama-3.3--70" . (lambda () (activate-gpt-model "llama-3.3-70b-specdec" 'kadir-gptel-groq)))
          ("-> model-llama-3.3--70" . (lambda () (activate-gpt-model "gemini-exp-1206" 'kadir-gptel-gemini)))
          ))

  (defun activate-gpt-model (model func)
    "Activate the specified GPT model and notify the user."
    (funcall func)
    (setq gptel-model model)
    (message (concat gptel-model " ACTIVATED")))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun better-fuzzy-match (prefix candidates)
    (let ((prefix-list (string-to-list prefix)))
      (cl-sort
       (cl-remove-if-not
        (lambda (candidate)
          (cl-subsetp prefix-list (string-to-list candidate)))
        candidates)
       (lambda (a b)
         (let ((count-a (count-matches prefix a))
               (count-b (count-matches prefix b)))
           (if (= count-a count-b)
               (string< a b)
             (> count-a count-b)))))))


  (defun count-matches (prefix candidate)
    (let ((count 0)
          (start 0))
      (while (string-match (regexp-quote prefix) candidate start)
        (setq count (1+ count))
        (setq start (match-end 0)))
      count))

  (defun beyin-company-backend (command &optional arg &rest ignored)
    (condition-case nil
        (let* ((all-candidates (mapcar 'car command-and-functions)))
          (case command
            (prefix (when (eq major-mode 'beyin-mode)
                      (let ((symbol (symbol-name (symbol-at-point))))
                        (when (and symbol (string-prefix-p beyin-company-prefix symbol))
                          (substring symbol (length beyin-company-prefix))))))
            (candidates (better-fuzzy-match arg all-candidates))
            (sorted t)
            (post-completion
             (delete-region (- (point) (+ (length arg) (length beyin-company-prefix))) (point))
             (let ((func (cdr (assoc arg command-and-functions))))
               (when func
                 (funcall func))))))
      (error nil)))

  (add-to-list 'company-backends 'beyin-company-backend)

  (define-key company-active-map (kbd "RET")
              (lambda ()
                (interactive)
                (if (and
                     (string-prefix-p "-> " (nth company-selection company-candidates))
                     (eq major-mode 'beyin-mode))
                    (company-complete-selection)
                  (company-abort)
                  (newline))))


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  )





(use-package consult-web
  :straight (consult-web :type git :host github :repo "armindarvish/consult-web" :files (:defaults "sources/*.el"))
  :after consult
  :defer nil
  )
(require 'consult)
(require 'consult-web)
(require 'consult-web-doi)



(use-package w3)



(use-package vdiff)
(use-package vdiff-magit)

;; (use-package indent-bars
;;   :hook ((python-mode yaml-mode) . indent-bars-mode)) ; or whichever modes you prefer



;; (use-package chatgpt-shell)




;; i hate eldoc with no reason

(global-eldoc-mode 0)
(defun eldoc-mode(&rest args) (message "no eldoc"))


(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))





(use-package helm-mode-manager)




;; (display-battery-mode 1)                ;a






;; this is a config
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t
  :defer nil
  :config
  (setq copilot-idle-delay 0)
  (add-hook 'prog-mode-hook 'copilot-mode)

  (global-set-key (kbd "C-ç") 'copilot-complete)
  (define-key copilot-completion-map (kbd "C-ç") 'copilot-accept-completion)
  ;; (define-key copilot-completion-map (kbd "M-n") 'copilot-next-completion)
  ;; (define-key copilot-completion-map (kbd "M-p") 'copilot-previous-completion)
  (copilot-mode 1)
  )
