(require 'use-package)

(use-package typo-suggest
  :defer 0.1
  :init
  (setq typo-suggest-timeout 10))


(use-package god-mode
  :init
  (setq-default cursor-type 'bar)

  (god-mode-all)
  ;; (setq god-exempt-major-modes nil) ;; enable for all mode but I don't know it is good or bad
  ;; (setq god-exempt-predicates nil)

  ;; enableing god mode
  (global-set-key (kbd "ş") #'god-local-mode)
  (define-key isearch-mode-map (kbd "ş") #'god-local-mode)

  ;; styling
  ;; (setq modalka-cursor-type '(hbar . 2)) ;; (setq-default cursor-type '(bar . 1))
  (defun my-god-mode-update-cursor ()
    (interactive)
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

  ;; some editingtings
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'kadir/split-and-follow-horizontally)
  (global-set-key (kbd "C-x C-3") #'kadir/split-and-follow-vertically)
  (global-set-key (kbd "C-x C-0") #'delete-window)
  (global-set-key (kbd "C-c C-h") #'helpful-at-point)
  (global-set-key (kbd "C-x C-k") (lambda nil (interactive) (kill-buffer (current-buffer))))

  ;; fixes
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)

  ;; extra binds
  (define-key god-local-mode-map (kbd "z") #'repeat)
  (define-key god-local-mode-map (kbd "h") #'backward-delete-char-untabify)
  (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
  (define-key god-local-mode-map (kbd "C-S-U") #'undo-tree-redo)
  (define-key god-local-mode-map (kbd "/") #'kadir/comment-or-self-insert)
  ;; (require 'god-mode-isearch)
  ;; (define-key isearch-mode-map (kbd "<return>") #'god-mode-isearch-activate)
  ;; (define-key god-mode-isearch-map (kbd "<return>") #'god-mode-isearch-disable)
  )


;;; experimental.el ends here




(defun test--get-suggestion-list(input)
  (message "sleep before")
  (sleep-for 1)
  (message "sleep after")

  (when input
    (list (length input))))

;; (add-to-list 'helm-before-update-hook (lambda ()(message "HOOK** before update")))
;; (add-to-list 'helm-after-update-hook (lambda ()(message "HOOK** after update")))

(defun helm-update-source-p(source) t)
(defun test-helm ()
  (let ((helm-candidate-cache (make-hash-table :test 'equal)))
    (helm :sources (helm-build-sync-source "test"
                     :match-dynamic t
                     :candidates (lambda () (test--get-suggestion-list helm-input))))))

(setq-default helm-debug t
              helm-debug-buffer "Debug Helm Log")

;; (global-set-key (kbd "M-ü") '(lambda () (interactive) (condition-case nil (eval-buffer) (error nil))
;;                                (test-helm)))

(defun disable-all-minors()
  (interactive)
  (let ((active-minor-modes nil))
    (mapc (lambda (mode) (condition-case nil
                        (if (and (symbolp mode) (symbol-value mode))
                            (add-to-list 'active-minor-modes mode))
                      (error nil)))
          minor-mode-list)

    (prin1 active-minor-modes)
    (--map (condition-case nil
               (funcall  it  0)
             (error nil))
           active-minor-modes)))


