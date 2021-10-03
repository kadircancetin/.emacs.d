(require 'use-package)


(use-package syntactic-close)
(global-set-key (kbd "M-m") 'syntactic-close)



(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.1
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)



(defun eldoc-mode(&rest args)
  (message "no eldoc"))

(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))




(load-file (expand-file-name "side-window.el" user-emacs-directory))
(global-set-key (kbd "M-ü") 'kadir/smart-push-pop)




(use-package tree-sitter
  :defer t
  :straight
  (tree-sitter :host github
               :repo "ubolonton/emacs-tree-sitter"
               :files ("lisp/*.el")))

(use-package tree-sitter-langs
  :defer t
  :straight
  (tree-sitter-langs :host github
                     :repo "ubolonton/emacs-tree-sitter"
                     :files ("langs/*.el" "langs/queries")))

(add-hook 'python-mode-hook  (lambda () (require 'tree-sitter-langs) (tree-sitter-hl-mode)))
(add-hook 'python-mode-hook  (lambda () (rainbow-delimiters-mode-disable)))



(use-package gcmh
  :init
  (gcmh-mode)
  (setq garbage-collection-messages t)
  (setq gcmh-verbose t)
  (setq gcmh-idle-delay 2)
  ;; (add-hook  'post-gc-hook (lambda() (message "garbage collected")))
  )


(use-package which-key
  :defer 3
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 2.0)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))




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


(use-package zoom
  :init
  (zoom-mode)
  (setq zoom-size '(85 . 22)))


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
;; (remove-hook 'post-command-hook 'kadir/post-command)

(defun kadir/buffer-local-disable-jit-defering()
  (make-variable-buffer-local 'kadir/jit-lock-defer-time)
  (setq kadir/jit-lock-defer-time 0))

(use-package svelte-mode
  :config
  (add-hook 'svelte-mode-hook  'kadir/buffer-local-disable-jit-defering)
  (add-hook 'svelte-mode-hook  'lsp-deferred)
  )



;; (use-package magit-delta
;;   :init
;;   (add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1))))


;; (electric-pair-mode)
;; (setq electric-pair-preserve-balance nil)

(use-package explain-pause-mode
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


(require 'projectile)
(require 'ht)

(setq refresh-buff "*kadir-buffers*")
(defun refresh-kadir-opened-buffers()
  (interactive)
  (unless (eq (current-buffer) (get-buffer-create refresh-buff))
    (setq all-files
          (-non-nil (--map
                     (s-chop-prefix (projectile-project-root) (buffer-file-name it))
                     (projectile-project-buffers))))


    (setq files-trees (ht-create))
    ;;LOOP
    (dolist (file all-files)

      (setq file-parsed  (s-split "/" file))

      (setq last-tree files-trees)
      (while (> (length file-parsed) 0)
        (let ((node (car file-parsed)))
          (if (> (length file-parsed) 1)
              (progn
                ;; if folder
                (if (not (ht-get last-tree node))
                    ;; if folder but not setted on hashtable
                    (progn
                      (setq inner-tree (ht-create))
                      (ht-set! last-tree node inner-tree)
                      (setq last-tree inner-tree))

                  ;; if folder and setted on hashtable
                  (setq last-tree (ht-get last-tree node))))

            ;; if not folder, then add-or-create to 'files list
            (let ((file-node (ht ('name node)
                                 ('file-path (concat (projectile-project-root) file)))))
              (if (ht-get last-tree 'files)
                  (push file-node (ht-get last-tree 'files))
                (ht-set! last-tree 'files (list file-node)))))

          (setq file-parsed (cdr file-parsed))))

      )
    ;; files-trees =
    ;; {
    ;;     "folder": {
    ;;         files:["a.py", "b.py"],
    ;;         "inner": {
    ;;             files: ["a.py"]
    ;;         }
    ;;     },
    ;;     "folder2": {
    ;;         files: ["x.py"]
    ;;     }
    ;; }

    (defun recursive-write (tree depth)

      (let ((files (sort (ht-get tree 'files)
                         (lambda (a b) (string< (ht-get a 'name) (ht-get b 'name))))))
        (dolist (file files)
          (dotimes (i depth) (insert "|  "))
          (when (eq depth 0) (insert "- "))
          (insert-text-button
           (ht-get file 'name)
           'face 'link
           'action `(lambda (_button)
                      (find-file ,(ht-get file 'file-path)))
           'follow-link t)

          (when (s-equals? current-buffer-name (ht-get file 'file-path))  ;; TODO: local is bind bad
            (insert " <<--"))

          (insert "\n")))

      (when (eq depth 0) (insert "\n"))

      (let ((folders (sort (ht-keys tree) 'string<)))

        (dolist (key folders)
          (unless (eq key 'files)

            (dotimes (i depth) (insert "|  "))
            (insert key)
            (insert "\n")
            (recursive-write (ht-get tree key) (+ 1 depth))))))


    (let ((root (projectile-project-root))
          (current-buffer-name (buffer-file-name (current-buffer))))
      (with-current-buffer (get-buffer-create "*kadir-buffers*")
        (erase-buffer)
        (insert root)
        (insert "\n\n")
        (recursive-write files-trees 0)))))

(add-hook 'buffer-list-update-hook 'refresh-kadir-opened-buffers)
