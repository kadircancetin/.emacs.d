;; https://gist.github.com/rangeoshun/67cb17392c523579bc6cbd758b2315c1

(use-package mmm-mode)

(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(setq mmm-submode-decoration-level 0) ;; Turn off background highlight

;; Add JSX submodule, because typescript-mode is not that great at it
(mmm-add-classes
 '((mmm-jsx-mode
    :front "\\(return\s\\|n\s\\|(\n\s*\\)<"
    :front-offset -1
    :back ">\n?\s*)"
    :back-offset 1
    :submode html-mode)))

(mmm-add-mode-ext-class 'typescript-mode nil 'mmm-jsx-mode)

(defun mmm-reapply ()
  (mmm-mode)
  (mmm-mode))

(add-hook 'after-save-hook
          (lambda ()
            (when (string-match-p "\\.tsx?" buffer-file-name)
              (mmm-reapply))))
