;; (use-package syntactic-close)
;; (global-set-key (kbd "M-m") 'syntactic-close)



(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.25
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)



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


(use-package svelte-mode
  :bind
  (:map svelte-mode-map
        ("M-o" . other-window))
  :config
  (add-hook 'svelte-mode-hook  'kadir/buffer-local-disable-jit-defering)
  (add-hook 'svelte-mode-hook  'lsp-deferred))


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



(require 'git-file-tree)
;; (memory-report)
;; company-keywords-alist
;; thai-word-table



(use-package spell-fu
  :defer 2.22
  :if (executable-find "aspell")
  :init
  ;; yay -S aspell aspell-en

  ;; (setq-default spell-fu-faces-include
  ;;               '(tree-sitter-hl-face:comment
  ;;                 tree-sitter-hl-face:doc
  ;;                 tree-sitter-hl-face:string
  ;;                 tree-sitter-hl-face:function
  ;;                 tree-sitter-hl-face:variable
  ;;                 tree-sitter-hl-face:constructor
  ;;                 tree-sitter-hl-face:constant
  ;;                 default
  ;;                 font-lock-type-face
  ;;                 font-lock-variable-name-face
  ;;                 font-lock-comment-face
  ;;                 font-lock-doc-face
  ;;                 font-lock-string-face
  ;;                 magit-diff-added-highlight))

  ;; for if I want to check personal dict file
  ;; (defun kadir/open-fly-a-spell-fu-file()
  ;;   (interactive)
  ;;   (find-file (file-truename "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")))

  :config
  (custom-set-faces '(spell-fu-incorrect-face ((t (
                                                   :underline (:color "Blue" :style wave)
                                                   ;; :underline nil
                                                   ;; :background "#800000"
                                                   ;; :famliy "DejaVu Sans Mono"
                                                   ;; :weight ultra-bold
                                                   ;; :inverse-video t
                                                   )))))
  ;; start spell-fu
  (global-spell-fu-mode)
  ;; for make sure aspell settings are correct (sometimes "en" not true)
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "en")
  ;; for save dictionaries forever
  (setq spell-fu-directory "~/Dropbox/spell-fu-tmp/")
  (setq ispell-personal-dictionary "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")
  ;; regex function
  (use-package xr)

  (setq-default spell-fu-word-regexp
                (rx
                 (or
                  (seq word-boundary (one-or-more upper) word-boundary)
                  (and upper
                       (zero-or-more lower))
                  (one-or-more lower))))

  ;; for all kind of face check
  (setq-default spell-fu-check-range 'spell-fu--check-range-without-faces)

  (spell-fu-mode-disable)
  (spell-fu-mode)

  ;; Wrong examples::
  ;;     wrng
  ;;     Wrng
  ;;     WrngButJustWrngPart
  ;;     WRNG
  ;;     wrng-wrng
  ;;     wrongnot
  ;;     YESWRONG
  ;;     YES_WRNG
  ;;     WRNG_YES
  ;;
  ;;
  ;; Not wrong examples:
  ;;     not_wrong
  ;;     NotWrongAtAll
  ;;     wrong_not
  ;;     NOT_WRONG
  ;;     URLField
  ;; Not covered
  ;;     NOTwrong   (note possible when URLField covered)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Fixed case-fold-search for spell-fu--check-range-without-faces
  (defun kadir/with-case-fold-search-nil (func &rest args)
    (let ((case-fold-search nil))
      (apply func args)))
  (advice-add #'spell-fu--check-range-without-faces :around #'kadir/with-case-fold-search-nil)
  (advice-add #'spell-fu--word-add-or-remove :around #'kadir/with-case-fold-search-nil)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; START: very bad spell-fu word add prompt hack
  (defun kadir/spell-fu--word-at-point--read-from-minibuffer ()
    (interactive)
    (unless cache
      (setq cache (read-from-minibuffer "input: " (or (word-at-point) ""))))
    cache)

  (defun kadir/spell-fu-dictionary-add ()
    (interactive)
    (flet ((spell-fu--word-at-point () (kadir/spell-fu--word-at-point--read-from-minibuffer)))
      (let ((cache nil))
        (call-interactively 'spell-fu-word-add))))
  ;; END: very bad spell-fu word add prompt hack
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; START: Very bad spell fu hack for running upcase word spell check
  (defun spell-fu-check-word (pos-beg pos-end word)
    (unless (spell-fu--check-word-in-dict-list (spell-fu--canonicalize-word word))
      (spell-fu-mark-incorrect pos-beg pos-end)))
  ;; END: Very bad spell fu hack for running upcase word spell check
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  )


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


(global-set-key (kbd "C-x t g")
                (lambda ()
                  (interactive)
                  (kadir/open-updater)
                  (select-window (get-buffer-window refresh-buff))
                  (kadir-tree-mode)))



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
