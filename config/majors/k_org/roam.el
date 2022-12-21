;; org-roam

(defun kadir/roam-hook()
  (interactive)

  ;; open backlink buffer automaticly, set dark background
  (require 'f)
  (require 'org-roam-mode)

  (when (and (buffer-file-name) (f-parent-of? org-roam-directory (buffer-file-name)) )
    (unless (get-buffer-window org-roam-buffer)
      (org-roam-buffer-toggle)
      (with-selected-window (get-buffer-window org-roam-buffer)
        (kadir/darken-background))
      )))

(use-package org-roam
  :straight (:no-native-compile t)
  :init
  (setq org-roam-v2-ack t)
  (setq org-roam-directory "~/Dropbox/org-roam")

  (setq org-roam-list-files-commands '(rg))
  ;; org roam buffer displaying
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . left)
                 (slot . 0)
                 (window-width . 0.28)
                 (preserve-size . (t nil))
                 (window-parameters . ((no-other-window . t)
                                       (no-delete-other-windows . t)))))


  (setq org-roam-db-gc-threshold most-positive-fixnum)  ;; improve performance
  (setq org-roam-completion-everywhere t)  ;; auto complete things


  :hook
  (org-mode . org-roam-db-autosync-mode)  ;; auto activate with org-mode
  (org-mode . kadir/roam-hook)  ;; some hooks may I want

  :config
  (define-key org-roam-mode-map [mouse-1] #'org-roam-visit-thing) ;; mouse support for backlink buffer


  ;; helm thing https://github.com/org-roam/org-roam/wiki/Hitchhiker's-Rough-Guide-to-Org-roam-V2
  (cl-defmethod org-roam-node-directories ((node org-roam-node))
    (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
        (format "(%s)" (car (f-split dirs)))
      ""))

  (cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
    (let* ((count (caar (org-roam-db-query
                         [:select (funcall count source)
                                  :from links
                                  :where (= dest $s1)
                                  :and (= type "id")]
                         (org-roam-node-id node)))))
      (format "[%d]" count)))

  (setq org-roam-node-display-template "${title:100} ${tags:10} ${backlinkscount:6}")
  )



;; https://github.com/org-roam/org-roam/issues/1853
(with-eval-after-load 'org-roam-mode
  (setq org-roam-fontify-buffer (get-buffer-create "*org-roam-fontify-buffer*"))
  (with-current-buffer org-roam-fontify-buffer
    (org-mode))

  (defun org-roam-fontify-like-in-org-mode (s)
    (with-current-buffer org-roam-fontify-buffer
      (erase-buffer)
      (insert s)
      (let ((org-ref-buffer-hacked t))
        (org-font-lock-ensure)
        (buffer-string)))))

(use-package org-roam-ui
  :straight
  (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out") :no-native-compile t)
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (use-package simple-httpd)
  (use-package websocket)
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
