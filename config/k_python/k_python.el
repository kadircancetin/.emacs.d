(use-package pyvenv)

(use-package python
  :bind (:map python-mode-map
              ("C-c C-n" . flymake-goto-next-error)
              ("C-c C-p" . flymake-goto-prev-error)
              ("M-ı" . eglot-format-buffer) ;  M-ı used for indet all
                                        ;  the buffer. But in
                                        ;  python I use language
                                        ;  server for that.
              ("M-." . xref-find-definitions)))

;;(add-hook 'before-save-hook (lambda() (interactive) (eglot-format-buffer)))


(defun kadir/configure-python ()
  (progn
    (eglot-ensure)))

(defun activate-venv-configure-python ()
  "source: https://github.com/jorgenschaefer/pyvenv/issues/51"
  (interactive)
  (require 'projectile)
  (progn
    (let* ((pdir (projectile-project-root)) (pfile (concat pdir ".venv")))
      (if (file-exists-p pfile)
          (pyvenv-workon (with-temp-buffer
                           (insert-file-contents pfile)
                           (nth 0 (split-string (buffer-string))))))))
  (kadir/configure-python))



(add-hook 'python-mode-hook 'activate-venv-configure-python)
(provide 'k_python)
