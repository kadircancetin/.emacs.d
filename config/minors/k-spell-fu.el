(use-package spell-fu
  :defer 2.22
  :if (executable-find "aspell")
  :init
  ;; yay -S aspell aspell-en

  ;; (setq-default spell-fu-faces-include
  ;;               '(tree-sitter-hl-face:comment
  ;;                 tree-sitter-hl-face:doc
  ;;                 tree-sitter-hl-face:string
  ;;                 tree-sitter-hl-face:function
  ;;                 tree-sitter-hl-face:variable
  ;;                 tree-sitter-hl-face:constructor
  ;;                 tree-sitter-hl-face:constant
  ;;                 default
  ;;                 font-lock-type-face
  ;;                 font-lock-variable-name-face
  ;;                 font-lock-comment-face
  ;;                 font-lock-doc-face
  ;;                 font-lock-string-face
  ;;                 magit-diff-added-highlight))

  ;; for if I want to check personal dict file
  ;; (defun kadir/open-fly-a-spell-fu-file()
  ;;   (interactive)
  ;;   (find-file (file-truename "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")))

  :config
  (custom-set-faces '(spell-fu-incorrect-face ((t (
                                                   :underline (:color "Blue" :style wave)
                                                   ;; :underline nil
                                                   ;; :background "#800000"
                                                   ;; :famliy "DejaVu Sans Mono"
                                                   ;; :weight ultra-bold
                                                   ;; :inverse-video t
                                                   )))))
  ;; start spell-fu
  (global-spell-fu-mode)
  ;; for make sure aspell settings are correct (sometimes "en" not true)
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "en")
  ;; for save dictionaries forever
  (setq spell-fu-directory "~/Dropbox/spell-fu-tmp/")
  (setq ispell-personal-dictionary "~/Dropbox/spell-fu-tmp/kadir_personal.en.pws")
  ;; regex function
  (use-package xr)

  (setq-default spell-fu-word-regexp
                (rx
                 (or
                  (seq word-boundary (one-or-more upper) word-boundary)
                  (and upper
                       (zero-or-more lower))
                  (one-or-more lower))))

  ;; for all kind of face check
  (setq-default spell-fu-check-range 'spell-fu--check-range-without-faces)


  (spell-fu-mode 0)
  (spell-fu-mode 1)

  ;; Wrong examples::
  ;;     wrng
  ;;     Wrng
  ;;     WrngButJustWrngPart
  ;;     WRNG
  ;;     wrng-wrng
  ;;     wrongnot
  ;;     YESWRONG
  ;;     YES_WRNG
  ;;     WRNG_YES
  ;;
  ;;
  ;; Not wrong examples:
  ;;     not_wrong
  ;;     NotWrongAtAll
  ;;     wrong_not
  ;;     NOT_WRONG
  ;;     URLField
  ;; Not covered
  ;;     NOTwrong   (note possible when URLField covered)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Fixed case-fold-search for spell-fu--check-range-without-faces
  (defun kadir/with-case-fold-search-nil (func &rest args)
    (let ((case-fold-search nil))
      (apply func args)))
  (advice-add #'spell-fu--check-range-without-faces :around #'kadir/with-case-fold-search-nil)
  (advice-add #'spell-fu--word-add-or-remove :around #'kadir/with-case-fold-search-nil)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; START: very bad spell-fu word add prompt hack
  (defun kadir/spell-fu--word-at-point--read-from-minibuffer ()
    (interactive)
    (unless cache
      (setq cache (read-from-minibuffer "input: " (or (word-at-point) ""))))
    cache)

  (defun kadir/spell-fu-dictionary-add ()
    (interactive)
    (flet ((spell-fu--word-at-point () (kadir/spell-fu--word-at-point--read-from-minibuffer)))
      (let ((cache nil))
        (call-interactively 'spell-fu-word-add))))
  ;; END: very bad spell-fu word add prompt hack
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; START: Very bad spell fu hack for running upcase word spell check
  (defun spell-fu-check-word (pos-beg pos-end word)
    (unless (spell-fu--check-word-in-dict-list (spell-fu--canonicalize-word word))
      (spell-fu-mark-incorrect pos-beg pos-end)))
  ;; END: Very bad spell fu hack for running upcase word spell check
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  )

(provide 'k-spell-fu)
