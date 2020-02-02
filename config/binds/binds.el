(require 'cl)

(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)


(defun kadir/bind (args)
  (loop for (key . value) in args
        collect (cons value key)
        do
        (global-set-key (kbd key) value)))


(bind-keys
 :prefix-map kadir/custom
 :prefix "ö"
 ("ö"                 . (lambda()(interactive)(insert "ö")))
 ("l"                 . goto-last-change)
 ("r"                 . helm-rg)
 ("a"                 . kadir/helm-do-ag-project-root-or-current-dir)
 ("t"                 . hs-toggle-hiding)
 ("y"                 . yas-insert-snippet)
 ("d"                 . deadgrep)
 ("j"                 . dumb-jump-go))

(bind-keys
 :prefix-map kadir/window
 :prefix "öw"
 ("s"                 . ace-swap-window)
 ("w"                 . resize-window-width)
 ("h"                 . resize-window-height)
 )

(bind-keys
 :prefix-map kadir/helm
 :prefix "öh"
 ("a"                 . helm-apropos))

(bind-keys
 :prefix-map kadir/bookmark
 :prefix "öb"
 ("t"                 . bm-toggle)
 ("b"                 . bm-toggle)
 ("n"                 . bm-next)
 ("p"                 . bm-previous)
 ("a"                 . helm-bm))


(kadir/bind
 '(;; editing
   ("C-w"             . spacemacs/backward-kill-word-or-region)
   ("C-a"             . mwim-beginning-of-code-or-line)
   ("C-e"             . mwim-end-of-line-or-code)
   ("/"               . kadir/comment-or-self-insert)
   ("C-t"             . er/expand-region)
   ("C-M-SPC"         . goto-last-change)
   
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
   ("M-ı"             . (lambda() (interactive) (indent-region (point-min) (point-max))))
   ("C-x 2"           . kadir/split-and-follow-horizontally)
   ("C-x 3"           . kadir/split-and-follow-vertically)
   ("C-x o"           . ace-window)
   ("M-<SPC>"         . kadir/last-buffer)

   ;; shortcuts
   ("C-x c"           . kadir/find-config)
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

   ;; bm
   ("C-x C-m"         . bm-toggle)
   ("C-x C-n"         . bm-next)
   ("C-x C-p"         . bm-previous)
   ("C-x C-a"         . helm-bm)

   ;; magit
   ("C-x g"           . magit-status)

   ;; treemacs
   ("M-0"             . treemacs)

   ;; fonts
   ("C-+"                . text-scale-increase)
   ("C--"                . text-scale-decrease)
   )
 )


(provide 'binds)