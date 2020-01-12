(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(fringe-mode '(5 . 0))                  ; my laptop screen is not full hd :(

(load-theme 'wombat t)
(set-face-attribute 'default nil
                    :family "Source Code Pro" :height 80 :weight 'normal)

(setq package-enable-at-startup nil)

;; (use-package benchmark-init :ensure t)
(if (file-exists-p "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc")
    ;; TODO: get the from file whithout the version.
    (progn
      (load-file "~/.emacs.d/elpa/benchmark-init-20150905.938/benchmark-init.elc")
      (add-hook 'after-init-hook 'benchmark-init/deactivate))
  (message "benchmark test is not installed, so not tested."))
