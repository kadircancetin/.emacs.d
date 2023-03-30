(require 'use-package)

(use-package darkroom) ;; NOTE: do I realy need it
(use-package deadgrep)
(use-package multiple-cursors)
(use-package mwim)
(use-package goto-chg)
(use-package projectile)
(use-package ace-window)
(use-package su :init (su-mode 1))
(use-package ivy)
(use-package string-inflection)
(use-package all-the-icons :defer 0.5)

(use-package undo-tree
  :defer 0.5
  :config
  (global-undo-tree-mode)
  ;; (setq undo-limit 1600)
  ;; (setq undo-tree-strong-limit 1600)
  ;; (setq undo-tree-outer-limit 160000)
  )

(use-package expand-region
  :custom
  (expand-region-fast-keys-enabled   nil)
  (expand-region-subword-enabled     t))

(use-package shackle
  :defer 0.5
  :config
  (shackle-mode 1)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("\\`\\*helpful.*?\\*\\'" :regexp t :align t :size 0.4)
          (lsp-help-mode :align t :size 0.4 :select t)
          (help-mode :align t :size 0.4 :select t))))

(use-package wrap-region
  :defer 0.5
  :commands (wrap-region-add-wrapper)
  :config
  (wrap-region-add-wrapper "<>" "</>" "#" 'rjsx-mode)
  (wrap-region-add-wrapper "#+begin_src emacs-lisp\n  " "\n#+end_src" "*" 'org-mode)
  (wrap-region-add-wrapper "{% trans \"" "\"  %}" "*" 'web-mode)
  (wrap-region-add-wrapper "<p>" "</p>" "!" 'web-mode)
  (wrap-region-add-wrapper "=" "=" "=" 'org-mode)
  (wrap-region-global-mode t))

(use-package yasnippet
  :defer 3
  :custom
  (yas-indent-line nil)
  (yas-inhibit-overlay-modification-protection t)
  :bind*
  (;; ("C-j" . yas-expand)
   :map yas-minor-mode-map
   ("TAB" . nil)
   ("<tab>" . nil)
   :map yas-keymap
   ("TAB" . (lambda () (interactive) (company-abort) (yas-next-field)))
   ("<tab>" . (lambda () (interactive) (company-abort) (yas-next-field))))
  :config
  (use-package yasnippet-snippets)
  (yas-global-mode 1))


(use-package magit
  :config
  (require 'k-spell-fu)
  (defun kadir/cool-spell()
    (spell-fu-mode 1)

    (setq-local
     face-remapping-alist
     '((spell-fu-incorrect-face (:underline
                                 (:color "yellow" :style wave)))))
    (setq-local spell-fu-idle-delay 0.0))

  (defun kadir/decrease-text()
    (text-scale-decrease 10))

  ;; (use-package magit-todos :hook (magit-mode . magit-todos-mode))
  (add-to-list 'git-commit-setup-hook 'git-commit-turn-on-flyspell)

  (add-hook 'magit-diff-mode-hook 'kadir/cool-spell 100)
  (add-hook 'magit-mode-hook 'kadir/cool-spell 100)

  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)



  (defun th/magit--with-difftastic (buffer command)
    "Run COMMAND with GIT_EXTERNAL_DIFF=difft then show result in BUFFER."
    (let ((process-environment
           (cons (concat "GIT_EXTERNAL_DIFF=difft --width="
                         (number-to-string (frame-width)))
                 process-environment)))
      ;; Clear the result buffer (we might regenerate a diff, e.g., for
      ;; the current changes in our working directory).
      (with-current-buffer buffer
        (setq buffer-read-only nil)
        (erase-buffer))
      ;; Now spawn a process calling the git COMMAND.
      (make-process
       :name (buffer-name buffer)
       :buffer buffer
       :command command
       ;; Don't query for running processes when emacs is quit.
       :noquery t
       ;; Show the result buffer once the process has finished.
       :sentinel (lambda (proc event)
                   (when (eq (process-status proc) 'exit)
                     (with-current-buffer (process-buffer proc)
                       (goto-char (point-min))
                       (ansi-color-apply-on-region (point-min) (point-max))
                       (setq buffer-read-only t)
                       (view-mode)
                       (end-of-line)
                       ;; difftastic diffs are usually 2-column side-by-side,
                       ;; so ensure our window is wide enough.
                       (let ((width (current-column)))
                         (while (zerop (forward-line 1))
                           (end-of-line)
                           (setq width (max (current-column) width)))
                         ;; Add column size of fringes
                         (setq width (+ width
                                        (fringe-columns 'left)
                                        (fringe-columns 'right)))
                         (goto-char (point-min))
                         (pop-to-buffer
                          (current-buffer)
                          `(;; If the buffer is that wide that splitting the frame in
                            ;; two side-by-side windows would result in less than
                            ;; 80 columns left, ensure it's shown at the bottom.
                            ,(when (> 80 (- (frame-width) width))
                               #'display-buffer-at-bottom)
                            (window-width
                             . ,(min width (frame-width))))))))))))

  (defun th/magit-show-with-difftastic (rev)
    "Show the result of \"git show REV\" with GIT_EXTERNAL_DIFF=difft."
    (interactive
     (list (or
            ;; If REV is given, just use it.
            (when (boundp 'rev) rev)
            ;; If not invoked with prefix arg, try to guess the REV from
            ;; point's position.
            (and (not current-prefix-arg)
                 (or (magit-thing-at-point 'git-revision t)
                     (magit-branch-or-commit-at-point)))
            ;; Otherwise, query the user.
            (magit-read-branch-or-commit "Revision"))))
    (if (not rev)
        (error "No revision specified")
      (th/magit--with-difftastic
       (get-buffer-create (concat "*git show difftastic " rev "*"))
       (list "git" "--no-pager" "show" "--ext-diff" rev))))

  (defun th/magit-diff-with-difftastic (arg)
    "Show the result of \"git diff ARG\" with GIT_EXTERNAL_DIFF=difft."
    (interactive
     (list (or
            ;; If RANGE is given, just use it.
            (when (boundp 'range) range)
            ;; If prefix arg is given, query the user.
            (and current-prefix-arg
                 (magit-diff-read-range-or-commit "Range"))
            ;; Otherwise, auto-guess based on position of point, e.g., based on
            ;; if we are in the Staged or Unstaged section.
            (pcase (magit-diff--dwim)
              ('unmerged (error "unmerged is not yet implemented"))
              ('unstaged nil)
              ('staged "--cached")
              (`(stash . ,value) (error "stash is not yet implemented"))
              (`(commit . ,value) (format "%s^..%s" value value))
              ((and range (pred stringp)) range)
              (_ (magit-diff-read-range-or-commit "Range/Commit"))))))
    (let ((name (concat "*git diff difftastic"
                        (if arg (concat " " arg) "")
                        "*")))
      (th/magit--with-difftastic
       (get-buffer-create name)
       `("git" "--no-pager" "diff" "--ext-diff" ,@(when arg (list arg))))))

  (transient-define-prefix th/magit-aux-commands ()
    "My personal auxiliary magit commands."
    ["Auxiliary commands"
     ("#" "Difftastic Diff (dwim)" th/magit-diff-with-difftastic)
     ("s" "Difftastic Show" th/magit-show-with-difftastic)])

  (transient-append-suffix 'magit-dispatch "!"
    '("#" "My Magit Cmds" th/magit-aux-commands))

  (define-key magit-status-mode-map (kbd "#") #'th/magit-diff-with-difftastic)

  )

(use-package magit-delta
  :init
  (add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1))))




(use-package git-link
  :commands (git-link)
  :init
  ;; (setq git-link-default-branch "develop")
  (setq git-link-use-commit t))

(use-package vc-msg)



(use-package posframe)


(use-package wakatime-mode
  :defer 2
  :if (executable-find "wakatime")
  :config
  (global-wakatime-mode t))

(use-package google-translate
  :init
  (setq google-translate-default-source-language "auto"
        google-translate-default-target-language "tr")

  (with-eval-after-load 'google-translate
    ;; fix from https://github.com/atykhonov/google-translate/issues/52#issuecomment-850813058
    (defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
    (setq google-translate-backend-method 'curl)))



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



(use-package typo-suggest
  :commands (typo-suggest-helm typo-suggest-ivy)
  :init
  (setq typo-suggest-timeout 10))




(use-package winum
  :bind*
  ("M-1" . winum-select-window-1)
  ("M-2" . winum-select-window-2)
  ("M-3" . winum-select-window-3)
  ("M-4" . winum-select-window-4)
  ("M-5" . winum-select-window-5)
  ("M-6" . winum-select-window-6)
  ("M-7" . winum-select-window-7)
  ("M-8" . winum-select-window-8)
  ("M-9" . winum-select-window-9)
  :config
  (winum-mode))


(use-package gcmh
  :defer 1
  :init
  (setq gcmh-verbose nil)
  (setq gcmh-idle-delay 2.5)
  :config
  (gcmh-mode)
  ;; (setq garbage-collection-messages nil)
  )



(provide 'core-extra)
