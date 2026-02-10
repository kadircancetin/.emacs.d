(epa-file-enable)
(let ((secrets-file "~/.emacs.d/secrets.el.gpg"))
  (if (file-exists-p secrets-file)
      (load secrets-file)
    (message "Warning: Secrets file not found")))


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

  :config

  (setq
   groq-backend (gptel-make-openai "Groq"
                  :host "api.groq.com"
                  :endpoint "/openai/v1/chat/completions"
                  :stream t
                  :key kadir-groq-api-key
                  :models
                  '("moonshotai/kimi-k2-instruct-0905"))
   gptel-backend groq-backend
   gptel-model "moonshotai/kimi-k2-instruct-0905")

  (setq
   open-router-backend (gptel-make-openai "OpenRouter"
                         :header (lambda ()
                                   (when-let* ((key (gptel--get-api-key)))
                                     `(("Authorization" . ,(concat "Bearer " key))
                                       ;; ;; https://openrouter.ai/docs/app-attribution
                                       ("HTTP-Referer" . "https://github.com/karthink/gptel")
                                       ("X-Title" . "emacs/gptel"))))
                         :host "openrouter.ai"
                         :endpoint "/api/v1/chat/completions"
                         :stream t
                         :key kadir-open-router-api-key

                         :models '("moonshotai/kimi-k2.5"
                                   "google/gemini-3-flash-preview"
                                   "moonshotai/kimi-k2.5"
                                   "deepseek/deepseek-v3.2"
                                   "anthropic/claude-opus-4.6"
                                   "google/gemini-3-pro-preview"
                                   )
                         ;; https://openrouter.ai/docs/features/provider-routing
                         ;; https://openrouter.ai/docs/guides/best-practices/reasoning-tokens#reasoning-effort-level
                         ;; :request-params '(:provider (:order ["z-ai"]))
                         ;; :request-params '(:reasoning (:effort "minimal"))
                         ;; :request-params '(:reasoning (:enabled :json-false))
                         ;; :request-params '(:provider (:sort "throughput"))

                         :request-params '(
                                           :provider (:sort "latency")
                                           :reasoning (:effort "low"))
                         ;; :request-params '(
                         ;;                   :provider (
                         ;;                              :order ["deepseek"]
                         ;;                              :sort "latency"
                         ;;                              )
                         ;;                   )
                         )
   gptel-backend open-router-backend

   gptel-model "deepseek/deepseek-v3.2"
   gptel-model "anthropic/claude-opus-4.6"
   gptel-model "google/gemini-3-pro-preview"
   ;;
   gptel-model "anthropic/claude-sonnet-4.5"
   gptel-model "moonshotai/kimi-k2.5"
   gptel-model "google/gemini-3-flash-preview"
   )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  (setq-default gptel-directives
                '((default
                   .
                   "- You are an LLM integrated within a text editor. Provide brief, concise, and helpful responses.
- Selected text appears within <file> and <context> tags when present.
- Keep responses short and direct. Prioritize clarity over completeness.
- Avoid unnecessary explanations, preambles, or asking clarifying questions unless critical.
")))



  (defface beyin-user-title-font
    '((t (:foreground "YellowGreen" :height 1.3)))
    "HERE"
    ;; :type 'integer
    :group 'beyin)

  (defface beyin-asistant-title-font
    '((t (:foreground "Indianred2" :height 1.3)))
    "HERE"
    :group 'beyin)


  (dolist (role-face '(("USER" . beyin-user-title-font)
                       ("ASSISTANT" . beyin-asistant-title-font)
                       ))
    (font-lock-add-keywords 'markdown-mode
                            `((,(concat "^# --\\(" (car role-face) "\\):$") 1 ',(cdr role-face) prepend)) 'append))
  (dolist (role-face '(("USER" . beyin-user-title-font)
                       ("ASSISTANT" . beyin-asistant-title-font)
                       ))
    (font-lock-add-keywords 'org-mode
                            `((,(concat "^* --\\(" (car role-face) "\\):$") 1 ',(cdr role-face) prepend)) 'append))


  (setq gptel-default-mode 'org-mode)
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "* --USER:\n")
  (setf (alist-get 'org-mode gptel-response-prefix-alist) "* --ASSISTANT:\n")

  ;; (setq gptel-default-mode 'markdown-mode)
  ;; (setf (alist-get 'markdown-mode gptel-prompt-prefix-alist) "# --USER:\n")
  ;; (setf (alist-get 'markdown-mode gptel-response-prefix-alist) "# --ASSISTANT:\n")

  (setq gptel-relsponse-separator "\n")
  (setq gptel-log-level 'debug
        gptel-max-tokens nil
        gptel-temperature 0.5
        gptel-include-reasoning 'ignore
        )

  (defun my-gptel-send-in-en-buffer ()
    (interactive)
    (let ((current-buffer (current-buffer)))
      (end-of-buffer)
      (gptel-send)))

  (define-key gptel-mode-map (kbd "C-c RET") 'my-gptel-send-in-en-buffer)

  :init
  (setq last-beyin-buffer nil)

  (defun beyin-display-last-buffer ()
    "Display the beyin buffer in a side window on the right.
Close the buffer window only if the cursor is in the beyin buffer.
If a region is active and not in the buffer, copy the region and paste it between ```` tags."
    (interactive)
    ;; Save the current beyin buffer if in gptel-mode
    (when (bound-and-true-p gptel-mode)
      (setq last-beyin-buffer (current-buffer)))

    (when (or (not last-beyin-buffer)
              (not (buffer-live-p last-beyin-buffer)))
      (setq last-beyin-buffer (get-buffer (gptel (string-trim (shell-command-to-string "uuidgen -7"))))))

    (if (eq (current-buffer) last-beyin-buffer)
        ;; if the cursor is in the beyin buffer, close the window
        (delete-window (get-buffer-window (current-buffer)))
      ;; else:
      (if (region-active-p)
          (progn
            (let* ((start-line (line-number-at-pos (region-beginning)))
                   (source-file (or (buffer-file-name) (buffer-name)))
                   (source-mode (symbol-name major-mode))
                   (lang (replace-regexp-in-string "-mode\\'" "" source-mode))
                   (last-beyin-buffer (get-buffer-create (gptel "beyin"))))
              (copy-region-as-kill (region-beginning) (region-end))
              (display-buffer last-beyin-buffer
                              `((display-buffer-in-side-window)
                                (side . right)
                                (window-width . 80)))
              (select-window (get-buffer-window last-beyin-buffer 0))
              (goto-char (point-max))
              (visual-line-mode 1)
              (spell-fu-mode 0)
              (insert "\n** Context \nFile: " source-file  "\nLine: " (number-to-string start-line)
                      "\n\n#+begin_src " lang "\n" (current-kill 0) "\n#+end_src\n** Question\n")

              ))
        ;; If no region is active, just display the buffer
        (display-buffer last-beyin-buffer
                        `((display-buffer-in-side-window)
                          (side . right)
                          (window-width . 80)))
        (select-window (get-buffer-window last-beyin-buffer 0))
        (goto-char (point-max))
        (spell-fu-mode 0)
        (visual-line-mode 1))))

  (defun beyin-new()
    (interactive)
    (setq
     last-beyin-buffer
     (get-buffer (gptel (string-trim (shell-command-to-string "uuidgen -7")))))  ;; uuid7
    (when (bound-and-true-p gptel-mode)
      (kadir/delete-window))
    (beyin-display-last-buffer))

  (defun beyin-next-beyin ()
    (interactive)
    (let* ((gptel-buffers (seq-filter (lambda (buf)
                                        (buffer-local-value 'gptel-mode buf))
                                      (buffer-list)))
           (sorted-buffers (sort gptel-buffers
                                 (lambda (a b)
                                   (string< (buffer-name a) (buffer-name b)))))
           (current (current-buffer))
           (current-pos (cl-position current sorted-buffers))
           (buf-count (length sorted-buffers)))
      (cond
       ;; No gptel buffers: create one
       ((zerop buf-count)
        (prin1 "No gptel buffers found. Creating a new one.")
        (call-interactively 'beyin-new))
       ;; At last buffer with content: spawn new instead of wrapping
       ((and current-pos
             (= current-pos (1- buf-count))
             (not (string= (with-current-buffer current
                             (buffer-string))
                           "* --USER:\n")))
        (prin1 "At the last gptel buffer with content. Creating a new one.")
        (call-interactively 'beyin-new))
       ;; Normal cycle (next or wrap to first)
       (t (switch-to-buffer
           (if current-pos
               (nth (mod (1+ current-pos) buf-count) sorted-buffers)
             (car sorted-buffers)))))))

  (global-set-key (kbd "M-ç") 'beyin-display-last-buffer)
  (require 'gptel)
  (define-key gptel-mode-map (kbd "M-n") 'beyin-next-beyin)

  )





(use-package consult-web
  :straight (consult-web :type git :host github :repo "armindarvish/consult-web" :files (:defaults "sources/*.el"))
  :after consult
  :defer nil)
(require 'consult)
(require 'consult-web)
(require 'consult-web-doi)



(use-package w3)



(use-package vdiff)
(use-package vdiff-magit)

;; (use-package indent-bars
;;   :hook ((python-mode yaml-mode) . indent-bars-mode)) ; or whichever modes you prefer


;; i hate eldoc with no reason

(global-eldoc-mode 0)
(defun eldoc-mode(&rest args) (message "no eldoc"))


(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))


(use-package helm-mode-manager)


(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t
  :defer 10
  :config
  (setq copilot-idle-delay 0)
  (setq copilot-enable-predicates nil)

  (add-hook 'python-mode-hook 'copilot-mode)

  (global-set-key (kbd "C-ç") 'copilot-complete)
  (define-key copilot-completion-map (kbd "C-ç") 'copilot-accept-completion)
  )



(setq warning-minimum-level :error)


(use-package helm-xref)



(use-package gdscript-mode
  :straight (gdscript-mode
             :type git
             :host github
             :repo "godotengine/emacs-gdscript-mode")
  :hook (gdscript-mode . eglot-ensure)
  :custom (gdscript-eglot-version 3)
  )


(use-package mermaid-mode)
(use-package ox-pandoc)

