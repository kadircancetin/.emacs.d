(use-package flycheck
  :bind
  (:map flycheck-mode-map
        (("C-c C-n" . flycheck-next-error)
         ("C-c C-p" . flycheck-previous-error))))

(add-hook 'prog-mode-hook #'hs-minor-mode)
;; (add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook #'k-colors-mode)
(add-hook 'prog-mode-hook #'kadir/activate-flycheck)


(defun kadir/activate-flycheck()
  (flymake-mode-off)
  (flycheck-mode 1))

(defun kadir/deactivate-flycheck()
  (flycheck-mode 0))



(use-package dumb-jump
  :straight(:no-native-compile t)
  :after helm
  :init
  (setq-default dumb-jump-prefer-searcher 'rg
                dumb-jump-force-searcher  'rg
                dumb-jump-selector 'popup)
  (setq-default dumb-jump-aggressive t))


(defun kadir/lsp-ui-activate ()
  (interactive)
  (use-package lsp-ui
    ;; :after lsp-mode
    :custom
    ;; DOC
    (lsp-ui-doc-delay 0.1)
    (lsp-ui-doc-position 'top)

    ;; Others
    (lsp-ui-sideline-enable nil)
    (lsp-ui-imenu-enable nil)
    (lsp-ui-peek-enable)
    ;; (lsp-ui-sideline-delay 0)
    ;; (lsp-ui-peek-fontify 'always)
    :bind
    ;; (:map lsp-mode-map (("M-." . lsp-ui-peek-find-definitions)))
    ))

(use-package lsp-mode
  :straight (:no-byte-compile t)

  :init
  (defun kadir/long-lsp-find ()
    (interactive)
    (let ((lsp-response-timeout 20))
      (lsp-ui-peek-find-definitions)))
  :bind (:map lsp-mode-map
              ("C-c C-d" . lsp-describe-thing-at-point))
  :config
  ;; lsp-eldoc-render-all nil                                                      ???????
  (setq
   ;; lsp-log-io t
   ;; lsp-print-performance t
   lsp-headerline-breadcrumb-enable nil
   lsp-headerline-breadcrumb-enable-diagnostics nil
   lsp-headerline-breadcrumb-segments '(project path-up-to-project file symbols)
   lsp-enable-snippet nil

   lsp-enable-folding nil ;; hiç kullanmadığım için
   lsp-enable-semantic-highlighting nil   ;; bi işe yaradığını görmedim
   lsp-progress-via-spinner nil ;; gereksiz gibi
   lsp-auto-execute-action nil ;; anlamadım ama tehlikeli geldi :D

   lsp-eldoc-enable-hover nil ;; hover genelde yavaş çalışıyor TODO: pyls illa hover açıyor gibi
   lsp-enable-symbol-highlighting nil

   lsp-response-timeout 10 ;; TODO: is it true way?
   lsp-signature-auto-activate nil
   lsp-signature-render-documentation nil
   ;; lsp-signature-doc-lines 5

   ;; lsp-prefer-capf nil ;;                       TODO:
   ;; ?????????????

   ;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; get from doom emacs
   ;;;;;;;;;;;;;;;;;;;;;;;;;
   lsp-enable-links nil
   ;; Potentially slow
   lsp-enable-file-watchers nil
   lsp-enable-text-document-color nil
   lsp-enable-semantic-highlighting nil
   ;; Don't modify our code without our permission
   lsp-enable-indentation nil
   lsp-enable-on-type-formatting nil
   ;; capf is the preferred completion mechanism for lsp-mode now
   ;; lsp-prefer-capf t
   )
  )


;; (use-package helm-xref
;;   :hook
;;   (helm-mode . (lambda() (require 'helm-xref)) ))



(use-package eglot
  :straight (:type built-in)
  ;; (add-to-list 'eglot-server-programs '((js-mode) "typescript-language-server" "--stdio"))
  :bind
  (:map eglot-mode-map("C-c C-d" . 'eglot-help-at-point)))



(use-package tree-sitter
  :straight
  (tree-sitter :host github
               :repo "ubolonton/emacs-tree-sitter"
               :files ("lisp/*.el")))

(use-package tree-sitter-langs
  :straight
  (tree-sitter-langs :host github
                     :repo "ubolonton/emacs-tree-sitter"
                     :files ("langs/*.el" "langs/queries")))


(provide 'k-langs)
