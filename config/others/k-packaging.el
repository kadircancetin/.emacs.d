(defvar bootstrap-version)

(setq-default straight-check-for-modifications '(check-on-save find-when-checking))

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))




(when (version< emacs-version "29") (straight-use-package 'use-package) t)


(setq-default straight-use-package-by-default t)

(setq-default use-package-always-defer t
              use-package-expand-minimally t)


(straight-use-package 'no-littering)
(require 'no-littering)
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(if (file-exists-p custom-file)
    (load-file custom-file))
(add-to-list 'yas-snippet-dirs
             (expand-file-name "snippets" user-emacs-directory))



(setq straight-recipe-repositories
      '(org-elpa
        melpa
        gnu-elpa-mirror
        ;; nongnu-elpa ;; so big ??
        el-get
        emacsmirror-mirror))


(provide 'k-packaging)
