;; Default dired settings
;; make dired human readble

;; (setq-default dired-listing-switches "-lha --group-directories-first")


;; FUNCTIONS

(defun file-size (filename)
  "Return size of file FILENAME in bytes.
   The size is converted to float for consistency.
   This doesn't recurse directories."
  (float (file-attribute-size			; might be int or float
          (file-attributes filename))))

(defun kadir/dired-smart-open ()
  "If file size bigger then 100 mb, open directly whith system, if
  bigger then 1 mb, ask to user if opening system or on emacs. Else
  open whith emacs."
  (interactive)
  (let* ((file (dired-get-filename nil t))
         (size (file-size file))
         (one-mb 1000000)
         (hunderd-mb 10000000)
         (k_open-with-emacs t))
    (if (> size hunderd-mb)
        (progn
          (browse-url-of-dired-file)
          (setq k_open-with-emacs nil))
      (when (and (> size one-mb)
                 k_open-with-emacs
                 (yes-or-no-p "Bigger then 1 MB, open whith system (y) whith emacs (n)?"))
        (browse-url-of-dired-file)
        (setq k_open-with-emacs nil)))
    (when k_open-with-emacs
      (dired-find-file))))


;; PACKAGES

(use-package dired
  :straight (:type built-in)
  :bind (:map dired-mode-map
              (("O" . browse-url-of-dired-file)
               ("RET" . kadir/dired-smart-open)
               ("C-x C-q" . (lambda()
                              (interactive)
                              (all-the-icons-dired-mode -1)
                              (dired-toggle-read-only)
                              ))
               ))
  :config

  ;; (when (package-installed-p 'stripe-buffer)
  ;;   (add-hook 'dired-mode-hook 'stripe-listify-buffer)) ;; TODO: fix this

  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  )


(use-package dired-subtree
  ;; source: https://github.com/KaratasFurkan/.emacs.d#dired-subtree
  :after dired
  :init
  (setq dired-subtree-use-backgrounds nil)
  :bind
  (:map dired-mode-map
        ("<tab>" . dired-subtree-toggle)
        ("TAB" . dired-subtree-toggle)
        ("<C-iso-lefttab>" . dired-subtree-remove))
  :config
  (defadvice dired-subtree-toggle (after add-dired-icons activate)
    (dired-revert))

  )


(use-package all-the-icons-dired
  ;; source: https://github.com/KaratasFurkan/.emacs.d#dired-subtree
  ;; TODO: 2 adet bug var
  ;; 1) auto revert buffer yapılmazsa resimler görünmüyor
  ;; 2) resimler varken isimlendirme yapma sıkıntı olabiliyor
  :init
  (add-to-list 'all-the-icons-icon-alist
               '("\\.mkv" all-the-icons-faicon "film" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.srt" all-the-icons-octicon "file-text" :v-adjust
                 0.0 :face all-the-icons-cyan))
  :hook (dired-mode . all-the-icons-dired-mode)
  :after dired)



(provide 'k_dired)
