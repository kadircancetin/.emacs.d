(icomplete-mode 1)


;; some no-litterings (for -fo mode)
;; TODO: make them more robust paths
(setq-default save-place-file       "/home/kadir/.emacs.d/var/fo-save-place.el")
(setq-default savehist-file         "/home/kadir/.emacs.d/var/fo-savehist.el")

(let ((backup-dir "/home/kadir/.emacs.d/var/backup/fo/")
      ;; source: https://emacs.stackexchange.com/questions/33/put-all-backups-into-one-backup-folder
      (auto-saves-dir "/home/kadir/.emacs.d/var/auto-save/fo/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq-default backup-directory-alist `(("." . ,backup-dir))
                auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
                auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
                tramp-backup-directory-alist `((".*" . ,backup-dir))
                tramp-auto-save-directory auto-saves-dir))


(provide 'fo-defs)
