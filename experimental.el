(require 'use-package)


(use-package typo-suggest
  :defer 0.1
  :init
  (setq typo-suggest-timeout 10))


(use-package god-mode
  :init
  (setq-default cursor-type 'bar)
  (god-mode-all)

  ;; enabling god mode
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  ;; styling
  ;; TODD: cursor type for terminal mode will could be good
  (defun my-god-mode-update-cursor ()
    (interactive)
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

  ;; some editing
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'kadir/split-and-follow-horizontally)
  (global-set-key (kbd "C-x C-3") #'kadir/split-and-follow-vertically)
  (global-set-key (kbd "C-x C-0") #'kadir/delete-window)
  (global-set-key (kbd "C-c C-h") #'helpful-at-point)
  (global-set-key (kbd "C-x C-k") #'kadir/kill-buffer)

  ;; fixes
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "/") #'kadir/comment-or-self-insert)
  (define-key god-local-mode-map (kbd "d") #'delete-char)
  (define-key god-local-mode-map (kbd "y") #'yank)

  ;; extra binds
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
  (define-key god-local-mode-map (kbd "C-S-U") #'undo-tree-redo)
  (define-key god-local-mode-map (kbd "7") #'kadir/comment-or-self-insert))


(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (add-hook 'mmm-mode-hook
            (lambda ()
              (set-face-background 'mmm-default-submode-face nil))))


(use-package syntactic-close)
(global-set-key (kbd "M-m") 'syntactic-close)


(use-package anki-editor)

(use-package vc-msg)



(defun kadir/load-eaf()
  (if (file-exists-p "/usr/share/emacs/site-lisp/eaf/eaf.el")
      (progn
        (add-to-list 'load-path "/usr/share/emacs/site-lisp/eaf/")
        (require 'eaf))
    (message "eaf is not installed")))



(defun kadir/fast-python()
  (interactive)

  (setq font-lock-maximum-decoration 2)
  (revert-buffer)
  (k-colors-mode 0)
  (flycheck-mode 0)
  (wucuo-mode 0)
  (auto-highlight-symbol-mode 1)
  (highlight-symbol-nav-mode 1)
  (setq font-lock-maximum-decoration t))

(defun kadir/normal-python()
  (interactive)
  (setq font-lock-maximum-decoration t)
  (revert-buffer)
  (k-colors-mode 1)
  (wucuo-mode 1)
  (flycheck-mode 1))

(global-set-key (kbd "M-:") 'xref-find-definitions-other-window)

(setq jit-lock-defer-time 0.1
      jit-lock-context-time 0.3
      jit-lock-chunk-size 1000
      jit-lock-stealth-time 2)

(defun eldoc-mode(&rest args)
  ;; TODO: find who opens the eldoc on python and fix it. Not like that.
  (message "no eldoc"))

;; (defun tooltip-mode(&rest args)
;;   ;; TODO: find who opens the eldoc on python and fix it. Not like that.
;;   (message "no eldoc"))


(defun tooltip-mode(&rest args)
  (message "no tooltip mode"))

;; TODO: (delq 'tooltip-hide pre-command-hook)


(use-package plantuml-mode
  :mode "\\.plantuml\\'"
  :init
  (setq plantuml-java-args (list "-Djava.awt.headless=true" "-jar") ;; somehow related to java-8 I think
        plantuml-jar-path (concat no-littering-etc-directory "plantuml.jar")
        plantuml-default-exec-mode 'jar
        plantuml-indent-level 4))

(use-package gitignore-mode
  :mode "/\\.gitignore\\'")

(global-auto-revert-mode 1)

(use-package posframe)
(use-package screenshot.el
  :straight (screenshot.el :type git :host github :repo "tecosaur/screenshot")
  :commands (screenshot))


(use-package wucuo
  :init
  (setq ispell-program-name "aspell")
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together" "--run-together-limit=16" "--camel-case"))

  (setq wucuo-flyspell-start-mode "normal")
  (add-hook 'prog-mode-hook #'wucuo-start)
  (add-hook 'text-mode-hook #'wucuo-start)
  (setq wucuo-personal-font-faces-to-check '(font-lock-type-face))
  )


(use-package winum
  :bind*
  ("s-1" . winum-select-window-1)
  ("s-2" . winum-select-window-2)
  ("s-3" . winum-select-window-3)
  ("s-4" . winum-select-window-4)
  ("s-5" . winum-select-window-5)
  ("s-6" . winum-select-window-6)
  ("s-7" . winum-select-window-7)
  ("s-8" . winum-select-window-8)
  ("s-9" . winum-select-window-9)
  :config
  (winum-mode))


(use-package groovy-mode)
(use-package jenkinsfile-mode)



(load-file (expand-file-name "side-window.el" user-emacs-directory))
(global-set-key (kbd "M-ü") 'kadir/smart-push-pop)

;; (use-package imenu-list
;;   :init
;;   (setq imenu-list-position 'left)
;;   (setq imenu-list-auto-resize nil)
;;   (setq imenu-list-focus-after-activation t)

;;   (defun kadir/imenu-change-function(arg)
;;     (run-with-idle-timer
;;      0.5 nil
;;      (lambda ()
;;        (imenu-list-update-safe))))

;;   (defun kadir/imenu-list()
;;     (interactive)
;;     (add-to-list 'window-selection-change-functions 'kadir/imenu-change-function)
;;     (imenu-list)
;;     (kadir/buffer-to-side-left)
;;     (when (derived-mode-p 'imenu-list-major-mode)
;;       (delete-window))))



;; (use-package flycheck-grammarly
;;   :init
;;   (require 'flycheck-grammarly)
;;   )





(use-package string-inflection)


(use-package git-link)



;; (use-package protobuf-mode
;;   :defer 10
;;   )


(use-package elixir-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.elixir2\\'" . elixir-mode))

  ;; for lsp installation and add exec-path
  ;; git clone https://github.com/elixir-lsp/elixir-ls.git
  ;; cd elixir-ls (that you just cloned)
  ;; mix deps.get
  ;; mix elixir_ls.release
  (add-to-list 'exec-path "/home/kadir/elixir-ls/release/")

  :hook
  (elixir-mode . lsp-deferred))



;; TODO: https://getpocket.com/read/3087997252
