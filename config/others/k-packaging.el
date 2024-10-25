(setq-default straight-check-for-modifications '(check-on-save find-when-checking))
(setq-default straight-use-package-by-default t)
(setq-default straight-recipe-repositories
              '(org-elpa
                melpa
                gnu-elpa-mirror
                ;; nongnu-elpa ;; so big ??
                el-get
                emacsmirror-mirror))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))




(use-package no-littering
  :defer nil
  :init
  (require 'no-littering)
  ;; (setq auto-save-file-name-transforms
  ;;       `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (if (file-exists-p custom-file)
      (load-file custom-file))
  (add-to-list 'yas-snippet-dirs
               (expand-file-name "snippets" user-emacs-directory)))




(setq-default use-package-always-defer t
              use-package-expand-minimally t)




(provide 'k-packaging)
