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


;; (use-package svelte-mode
;;   :config
;;   (add-hook 'svelte-mode-hook  'kadir/buffer-local-disable-jit-defering)
;;   (add-hook 'svelte-mode-hook  'lsp-deferred)
;;   )



;; (electric-pair-mode)
;; (setq electric-pair-preserve-balance nil)

(use-package explain-pause-mode
  :defer 1
  :straight (explain-pause-mode :type git :host github :repo "lastquestion/explain-pause-mode")
  :init
  (explain-pause-mode)
  )
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
  :defer 1.11
  :init

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
  (defun kadir/open-fly-a-spell-fu-file()
    (interactive)
    (find-file (file-truename "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")))

  :config

  ;; for styling
  (custom-set-faces
   '(spell-fu-incorrect-face ((t (:underline (:color "Olivedrab4" :style wave))))))

  ;; for make sure aspell settings are correct (sometimes "en" not true)
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "en")

  ;; regex function
  (setq-default spell-fu-word-regexp (rx (maximal-match
                                          (or
                                           (>= 2 upper)
                                           (and upper
                                                (zero-or-more lower))
                                           (one-or-more lower)))))

  ;; for save dictionaries forever
  (setq spell-fu-directory "~/Dropbox/spell-fu-tmp/")
  (setq ispell-personal-dictionary "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")


  ;; for all kind of face check
  (setq-default spell-fu-check-range 'spell-fu--check-range-without-faces)

  ;; start spell-fu
  (global-spell-fu-mode)

  ;; Fixed case-fold-search for spell-fu--check-range-without-faces
  (defun kadir/with-case-fold-search-nil (func &rest args)
    (let ((case-fold-search nil))
      (apply func args)))



  (advice-add #'spell-fu--check-range-without-faces :around #'kadir/with-case-fold-search-nil)
  (advice-add #'spell-fu--word-add-or-remove :around #'kadir/with-case-fold-search-nil)
  ;; TODO: word add point wrong at AlexaDoc

  ;; Fixed upper cased search with delete (unless (equal word (upcase word))
  (defun spell-fu-check-word (point-start point-end word)
    (unless (gethash (encode-coding-string (downcase word) 'utf-8) spell-fu--cache-table nil)
      (spell-fu-mark-incorrect point-start point-end)))

  ;; Wrong examples::
  ;;     wrng Wrng WrngButJustWrngPart WRNG wrng-wrng wrongnot
  ;; Not wrong examples:
  ;;     NOTwrong not_wrong NotWrongAtAll wrong_not
  )
