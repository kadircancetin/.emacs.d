;; (use-package syntactic-close)
;; (global-set-key (kbd "M-m") 'syntactic-close)



(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)



(defun eldoc-mode(&rest args)
  (message "no eldoc"))

(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))




(load-file (expand-file-name "side-window.el" user-emacs-directory))
(global-set-key (kbd "M-ü") 'kadir/smart-push-pop)



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



(load-file (expand-file-name "language-learn.el" user-emacs-directory))
(global-set-key (kbd "C-ç") 'kadir/dilogretio)



;; (require 'git-file-tree)
;; ;; (memory-report)
;; ;; company-keywords-alist
;; ;; thai-word-table



(use-package too-long-lines-mode
  :straight (too-long-lines-mode :type git :host github :repo "rakete/too-long-lines-mode")

  :init
  (load-file (expand-file-name "straight/repos/too-long-lines-mode/too-long-lines-mode.el" user-emacs-directory))

  (setq too-long-lines-threshold 220)
  (setq too-long-lines-show-number-of-characters 50)
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



(setenv "JAVA_HOME"
        "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/")

;; (animate-birthday-present)
(defun lsp-metals--server-command ()
  "Generate the Scala language server startup command."
  `("/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java"
    "-Xss4m"
    "-Xms100m"
    "-Dmetals.client=vscode"
    "-Xmx1G"
    ,@lsp-metals-server-args
    "scala.meta.metals.Main"))



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
  (blamer-max-commit-message-length 35)
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


(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (
         ("C-c m" . consult-mode-command)
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x f" . projectile-find-file)
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi))

  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init

  (setq register-preview-delay 0.5 register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config

  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   ;; consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.2 any))

  (setq consult-narrow-key "<"))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq
   ;; completion-styles '(basic partial-completion orderless)
   completion-styles '(orderless)
   completion-category-defaults nil
   ;; orderless-match-faces [
   ;;                        completions-common-part
   ;;                        orderless-match-face-1
   ;;                        orderless-match-face-2
   ;;                        orderless-match-face-3
   ;;                        ]
   completion-category-overrides '((file (styles partial-completion)))))


(use-package marginalia
  :init
  (define-key minibuffer-local-map (kbd "M-f") #'marginalia-cycle)
  (marginalia-mode))



(use-package f
  :init
  (load-file (expand-file-name (format "%sstraight/repos/f.el/f-shortdoc.el" user-emacs-directory)))
  (require 'f-shortdoc))
