(require 'cl)
(require 'dash)


(defvar k-binds-map (make-sparse-keymap))

(defun k-bind-both-god-and-normal (key-map)
  (define-key k-binds-map (kbd (concat "ö" (car key-map))) (cdr key-map))

  (let ((key (car key-map)))
    (setq key (concat "C-" (mapconcat #'char-to-string (mapcar 'identity key) " C-")))
    (message key)

    (define-key k-binds-map (kbd (concat "C-ö " key)) (cdr key-map))))


(defvar tuslar
  '(("ö"                 . (lambda()(interactive)(insert "ö")))
    ("l"                 . goto-last-change)
    ("a"                 . kadir/helm-do-ag-project-root-or-current-dir)
    ("t"                 . hs-toggle-hiding)
    ("y"                 . yas-insert-snippet)
    ;; ("d"                 . deadgrep)
    ("c"                 . (lambda()(interactive)(org-capture nil "t")))
    ("ç"                 . (lambda() (interactive) (eval-buffer) (message "eval") (save-buffer)))
    ("j"                 . dumb-jump-go)

    ;; D
    ("dm"                 . (lambda() (interactive)
                              (let ((helm-rg-default-glob-string "models.py"))
                                (helm-rg "class model " ))))

    ;; W
    ("ws"                 . ace-swap-window)
    ("ww"                 . resize-window-width)
    ("wh"                 . resize-window-height)

    ;; ;; İ
    ("ia"                 . helm-imenu-in-all-buffers)
    ("ii"                 . helm-imenu)
    ("it"                 . typo-suggest-ivy)

    ;; o
    ("oi"                 . kadir/find-inbox)
    ("oc"                 . kadir/find-config)
    ("oe"                 . kadir/find-experimental-config)
    ("os"                 . kadir/find-scratch-buffer)
    ("od"                 . kadir/find-dashboard)
    ("oa"                 . kadir/agenda)


    ;; h
    ("ha"                 . helm-apropos)
    ("he"                 . helm-emmet)
    ("hr"                 . helm-rg)
    ("hs"                 . helm-swoop)
    ("ht"                 . typo-suggest-helm)

    ;; hh
    ("hha"                . hs-hide-all)
    ("hhs"                . hs-show-all)
    ("hho"                . (lambda () (interactive) (hs-hide-level 1)))
    ("hht"                . (lambda () (interactive) (hs-hide-level 2)))

    ;; b
    ("bt"                 . bm-toggle)
    ("bb"                 . bm-toggle)
    ("bn"                 . bm-next)
    ("bp"                 . bm-previous)
    ("ba"                 . helm-bm)

    ;; r
    ("rl"                 . org-roam)
    ("rf"                 . org-roam-find-file)
    ("rt"                 . org-roam-dailies-today)
    ("ri"                 . org-roam-insert)
    ("rg"                 . org-roam-show-graph)))



(define-minor-mode k-binds-mode
  "t"
  "t" "m" k-binds-map
  (--map (k-bind-both-god-and-normal it) tuslar)
  (if k-binds-mode
      (message "Binds")))

(k-binds-mode 1)

(kadir/bind
 '(;; editing
   ("C-w"             . spacemacs/backward-kill-word-or-region)
   ("C-a"             . mwim-beginning-of-code-or-line)
   ("C-e"             . mwim-end-of-line-or-code)
   ("/"               . kadir/comment-or-self-insert)
   ("C-t"             . er/expand-region)
   ("C-M-SPC"         . goto-last-change)

   ;; doc
   ;; ("C-c DEL"         . devdocs-search)

   ;; MC
   ("C-M-n"           . mc/mark-next-like-this)
   ("C-M-p"           . mc/mark-previous-like-this)
   ("C-M-S-n"         . mc/skip-to-next-like-this)
   ("C-M-S-p"         . mc/skip-to-previous-like-this)
   ("C-S-N"           . mc/unmark-previous-like-this)
   ("C-S-P"           . mc/unmark-next-like-this)
   ("C-M-<mouse-1>"   . mc/add-cursor-on-click)

   ;; window-buffer
   ("M-o"             . other-window)
   ("M-u"             . winner-undo)
   ("C-x k"           . (lambda () (interactive) (kill-buffer (current-buffer))))
   ("M-ı"             . kadir/format-buffer)
   ("C-x 2"           . kadir/split-and-follow-horizontally)
   ("C-x 3"           . kadir/split-and-follow-vertically)
   ("C-x o"           . ace-window)
   ("M-<SPC>"         . kadir/last-buffer)

   ;; shortcuts
   ("C-x *"           . kadir/open-thunar)
   ("C-x -"           . kadir/open-terminator)

   ;; helm
   ("M-x"             . helm-M-x)
   ("C-x b"           . helm-buffers-list)
   ("C-x C-f"         . helm-find-files)
   ;; ("C-x i"           . helm-imenu-all-buffer)
   ;; ("C-x C-i"         . helm-imenu)
   ("M-y"             . helm-show-kill-ring)
   ("C-x f"           . helm-projectile)

   ;; helm-rg
   ("<C-tab>"         . helm-rg)
   ("<C-iso-lefttab>" . deadgrep)

   ;; undo-tree
   ("M-_"             . undo-tree-redo)
   ("C-_"             . undo-tree-undo)
   ("s-u"             . undo-tree-redo)

   ;; magit
   ("C-x g"           . magit-status)

   ;; fonts
   ("C-+"                . kadir/font-size-bigger)
   ("C--"                . kadir/font-size-smaller)
   ("C-c c"                 . (lambda()(interactive)(org-capture nil "t")))
   )
 )



(provide 'binds)

;;; binds.el ends here
