;; (use-package selectrum)
;; (use-package selectrum-prescient-mode)
;; (use-package prescient)

;; (selectrum-mode +1)
;; (selectrum-prescient-mode +1)
;; (prescient-persist-mode +1)

;; (setq selectrum-num-candidates-displayed 20
;;       selectrum-fix-minibuffer-height t
;;       selectrum-count-style 'current/matches
;;       selectrum-show-indices nil
;;       )
;; (setq projectile-completion-system 'default)


(use-package typo-suggest
  :straight (typo-suggest
             :type git
             :host github
             :repo "kadircancetin/typo-suggest"
             :branch "develop"
             )
  :init
  (require 'typo-suggest)
  (setq typo-suggest-default-search-method 'datamuse))

(global-set-key (kbd "M-ü") 'typo-suggest-helm)




(use-package modalka
  :init
  ;; (modalka-global-mode 1)

  (add-to-list 'modalka-excluded-modes '('magit-status-mode
                                         'helm-mode))


  (global-set-key (kbd "<return>") #'modalka-global-mode)
  (setq modalka-cursor-type '(hbar . 2)) ;; (setq-default cursor-type '(bar . 1))

  (advice-add 'self-insert-command
              :before
              (lambda (&rest r)
                (when (and (bound-and-true-p modalka-global-mode)
                           (cdr r))
                  (error "MODALKA MODALKA MODALKA MODALKA MODALKA MODALKA MODALKA"))))
  (progn
    ;; general
    (modalka-define-kbd "g" "C-g")
    ;; kill - yank
    (modalka-define-kbd "Y" "M-y")
    (modalka-define-kbd "w" "M-w")
    (modalka-define-kbd "k" "C-k")
    (modalka-define-kbd "y" "C-y")
    ;; (modalka-define-kbd "SPC" "C-SPC")
    ;; goto source - pop
    (modalka-define-kbd "." "M-.")
    (modalka-define-kbd "," "M-,")
    ;; editing
    (modalka-define-kbd "m" "C-m")
    (modalka-define-kbd "d" "C-d")
    (modalka-define-kbd "o" "C-o")
    (modalka-define-kbd "h" "<DEL>")
    (modalka-define-kbd "u" "C-_")
    (modalka-define-kbd "U" "M-_")
    ;; movement
    (modalka-define-kbd "a" "C-a")
    (modalka-define-kbd "b" "C-b")
    (modalka-define-kbd "e" "C-e")
    (modalka-define-kbd "f" "C-f")
    (modalka-define-kbd "n" "C-n")
    (modalka-define-kbd "p" "C-p")
    ;; viewving
    (modalka-define-kbd "l" "C-l")
    (modalka-define-kbd "v" "C-v")
    (modalka-define-kbd "V" "M-v")
    ;; file
    (modalka-define-kbd "xs" "C-x C-s")
    ;; window
    (modalka-define-kbd "0" "C-x 0")
    (modalka-define-kbd "1" "C-x 1")
    (modalka-define-kbd "2" "C-x 2")
    (modalka-define-kbd "3" "C-x 3")
    (modalka-define-kbd "4." "C-x 4")
    ;; buffer
    (modalka-define-kbd "xk" "C-x C-k")
    (modalka-define-kbd "<SPC>" "M-<SPC>")
    ;;;;;;;;;;;;;; major modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; elisp
    (modalka-define-kbd "xe" "C-x C-e")))

(use-package dired-sidebar)


(use-package smart-jump
  :defer 1
  :init
  (setq smart-jump-default-mode-list 'python-mode)
  :config
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'xref-find-definitions
                       :pop-fn 'xref-pop-marker-stack
                       :refs-fn 'xref-find-references
                       :should-jump t
                       :heuristic 'error
                       :async nil
                       :order 1)
  (smart-jump-register :modes 'python-mode
                       :jump-fn 'dumb-jump-go
                       :pop-fn 'xref-pop-marker-stack
                       :should-jump t
                       :heuristic 'point
                       :async nil
                       :order 2))

(use-package pony-mode)


(use-package su
  :straight (su
             :type git
             :host github
             :repo "PythonNut/su.el")
  :init
  (su-mode +1))


(use-package org-web-tools)
(use-package darkroom)
