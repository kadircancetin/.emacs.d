(defun kadir/helm-do-ag-project-root-or-current-dir ()
  ;; source: https://github.com/KaratasFurkan/.emacs.d
  "If in a project call `helm-do-ag-project-root', else call
     `helm-do-ag' with current directory."
  (interactive)
  (if (projectile-project-p)
      (helm-do-ag-project-root)
    (helm-do-ag default-directory)))

(defun kadir/long-lsp-find ()
  (interactive)
  (let ((lsp-response-timeout 20))
    (lsp-ui-peek-find-definitions)))
