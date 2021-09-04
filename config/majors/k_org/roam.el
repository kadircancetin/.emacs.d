;; org-roam

(defun kadir/roam-hook()
  (interactive)

  ;; open backlink buffer automaticly, set dark background
  (unless (get-buffer-window org-roam-buffer)
    (org-roam-buffer-toggle)
    ;; set dark background
    (with-selected-window (get-buffer-window org-roam-buffer)
      (kadir/darken-background))
    ))


(use-package org-roam
  :straight (:no-native-compile t)
  :init
  (setq org-roam-v2-ack t)
  (setq org-roam-directory "~/Dropbox/org-roam")


  ;; org roam buffer displaying
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (slot . 0)
                 (window-width . 0.25)
                 (preserve-size . (t nil))
                 (window-parameters . (;; (no-other-window . t)
                                       (no-delete-other-windows . t)))))


  (setq org-roam-db-gc-threshold most-positive-fixnum)  ;; improve performance
  (setq org-roam-completion-everywhere t)  ;; auto complete things


  :hook
  (org-mode . org-roam-db-autosync-mode)  ;; auto activate with org-mode
  (org-mode . kadir/roam-hook)  ;; some hooks may I want

  :config
  (define-key org-roam-mode-map [mouse-1] #'org-roam-visit-thing) ;; mouse support for backlink buffer


  )


(use-package org-roam-ui
  :straight
  (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  :after org-roam
  ;;  :hook (after-init . org-roam-ui-mode)
  :init
  (setq org-roam-ui-sync-theme nil
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil)
  )
