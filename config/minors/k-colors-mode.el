(require 'use-package)


;; NOTE: highlight-operators kebap case'i bozuyor
;; (use-package highlight-operators)

(use-package highlight-numbers)

(use-package highlight-symbol
  :config
  (defun kadir/highlight-add()
    (interactive)
    (highlight-symbol (read-from-minibuffer "add highlight: " (thing-at-point 'symbol))))

  (defun kadir/highlight-remove()
    (interactive)
    (highlight-symbol-remove-symbol (read-from-minibuffer "remove highlight: " (thing-at-point 'symbol)))))

(use-package auto-highlight-symbol
  :config
  (setq-default ahs-case-fold-search nil
                ahs-default-range 'ahs-range-display
                ahs-idle-interval 0.1
                ahs-inhibit-face-list nil))

(use-package rainbow-delimiters)

(use-package hl-todo)

(use-package diff-hl)


(use-package color-identifiers-mode)

(use-package beacon
  :init
  (setq-default beacon-color "#2FB90E")

  ;; `beacon-blink' manually instead of activating `beacon-mode' to not
  ;; calculate every time on post-command-hook if should beacon blink
  (defadvice other-window (after blink activate)
    (beacon-blink))
  (defadvice winum-select-window-by-number (after blink activate)
    (beacon-blink))
  (defadvice scroll-up-command (after blink activate)
    (beacon-blink))
  (defadvice scroll-down-command (after blink activate)
    (beacon-blink))
  (defadvice recenter-top-bottom (after blink activate)
    (beacon-blink))
  (defadvice move-to-window-line-top-bottom (after blink activate)
    (beacon-blink))
  (defadvice ace-select-window (after blink activate)
    (beacon-blink))
  (defadvice ace-swap-window (after blink activate)
    (beacon-blink))
  (defadvice avy-jump (after blink activate)
    (beacon-blink))
  )

(use-package volatile-highlights
  :config
  (vhl/install-extension 'undo-tree)
  (vhl/define-extension 'undo-tree 'undo-tree-yank 'undo-tree-move))

(use-package prism
  :straight (prism :type git :host github :repo "alphapapa/prism.el")
  :config
  (prism-set-colors
   :num 16
   :desaturations (cl-loop for i from 0 below 16
                           collect (* i 1))
   :lightens (cl-loop for i from 0 below 16
                      collect (* i 1))
   :comments-fn
   (lambda (color)
     (prism-blend color
                  "#2d9574" 0.5))
   :strings-fn
   (lambda (color)
     (prism-blend color "#2d9574" 0))

   :colors (list
            "#bf6bc7"  ;; pembe
            "#4f97e7"  ;; blue
            "#c2c2c2"  ;; base
            ;; yellow
            "#b1951d")))


(define-minor-mode k-colors-mode
  "Some cool color features for programing."
  :lighter "colors"
  ;; TODO: highlight-symbol-nav-mode is not about coloring move more appopriate
  (if k-colors-mode
      (progn
        (highlight-numbers-mode 1)
        (rainbow-delimiters-mode 1)
        (color-identifiers-mode 1)
        (auto-highlight-symbol-mode 1)
        (highlight-symbol-nav-mode 1)  ;; https://github.com/mickeynp/smart-scan is may alternative
        )

    (highlight-numbers-mode 0)
    (rainbow-delimiters-mode 0)
    (color-identifiers-mode 0)
    (auto-highlight-symbol-mode 0)
    (highlight-symbol-nav-mode 0)))

(define-minor-mode k-colors-global-mode
  ;; TODO: rename, it is not k-colors's global mode. it is different
  "Some cool color features for programing."
  :lighter "colors-G"
  :global t
  (if k-colors-global-mode
      (progn (global-hl-todo-mode 1)
             (global-diff-hl-mode 1)
             ;; (beacon-mode 1)  ;; beacon mode activating manually handled
             ;; (diff-hl-flydiff-mode 1)
             (volatile-highlights-mode 1))

    (global-hl-todo-mode 0)
    (global-diff-hl-mode 0)
    ;; (beacon-mode 0)  ;; beacon mode activating manually handled
    ;; (diff-hl-flydiff-mode 0)
    (volatile-highlights-mode 0)))

(provide 'k-colors-mode)
