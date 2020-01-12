(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(fringe-mode '(5 . 0))                  ; my laptop screen is not full hd :(

(load-theme 'wombat t)
(set-face-attribute 'default nil
                    :family "Source Code Pro" :height 80 :weight 'normal)
