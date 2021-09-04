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
