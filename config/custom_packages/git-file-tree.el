(require 'projectile)
(require 'ht)

(setq refresh-buff "*kadir-buffers*")
;; TODO: make buffer name for buffer name confict
;; TODO: hide deleted ones

(setq git-files '())

(defun update-git-changes()
  (setq git-files '())

  (when (projectile-project-root)
    (condition-case nil
        (make-process
         :command `("bash" "-c" ,(format "cd %s; git status -s | cut -c4-" (projectile-project-root)))
         :name "async-process"
         :sentinel (lambda (process event)
                     (when (s-equals? event "finished\n")
                       (refresh-kadir-opened-buffers)))
         :filter (lambda (process output)
                   (setq git-files
                         (--filter (and
                                    (not (s-ends-with? "/" it))
                                    (not (s-contains? ".#" it))
                                    (not (s-equals? "" it)))
                                   (s-split "\n" output)))))
      (error (message "err")))))


(defun refresh-kadir-opened-buffers()
  (interactive)
  (unless (or (eq (current-buffer) (get-buffer-create refresh-buff))
              (not (projectile-project-root)))

    (setq buffer-files
          (-non-nil (--map
                     (s-chop-prefix (projectile-project-root) (buffer-file-name it))
                     (projectile-project-buffers))))

    ;; start
    (setq all-files  (-distinct (append git-files buffer-files)))

    (setq files-trees (ht-create))
    ;;LOOP
    (dolist (file all-files)

      (setq file-parsed  (s-split "/" file))

      (setq last-tree files-trees)
      (while (> (length file-parsed) 0)
        (let ((node (car file-parsed)))
          (if (> (length file-parsed) 1)
              (progn
                ;; if folder
                (if (not (ht-get last-tree node))
                    ;; if folder but not setted on hashtable
                    (progn
                      (setq inner-tree (ht-create))
                      (ht-set! last-tree node inner-tree)
                      (setq last-tree inner-tree))

                  ;; if folder and setted on hashtable
                  (setq last-tree (ht-get last-tree node))))

            ;; if not folder, then add-or-create to 'files list
            (let ((file-node (ht ('name node)
                                 ('relative-path file)
                                 ('file-path (concat (projectile-project-root) file)))))
              (if (ht-get last-tree 'files)
                  (push file-node (ht-get last-tree 'files))
                (ht-set! last-tree 'files (list file-node)))))

          (setq file-parsed (cdr file-parsed)))))

    ;; files-trees =
    ;; {
    ;;     "folder_name_1": {
    ;;         files:["a.py", "b.py"],
    ;;         "inner": {
    ;;             files: ["a.py"]
    ;;         }
    ;;     },
    ;;     "folder_name_2": {
    ;;         files: ["x.py"]
    ;;     }
    ;; }


    (let ((root (projectile-project-root))
          (current-buffer-name (buffer-file-name (current-buffer))))
      (with-current-buffer (get-buffer-create refresh-buff)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert root)
          (insert "\n\n")
          (recursive-write files-trees 0))))))


(defun kadir-tree/kill-from-button()
  (interactive)
  (let* ((butn (button-at (point)) )
         (file-path (button-get butn 'file-path))
         (buf- (get-file-buffer file-path)))

    (when buf- (kill-buffer buf-))
    (kadir-tree/next-line)
    (refresh-kadir-opened-buffers)))

(defun kadir-tree/open-from-button()
  (interactive)
  (let* ((butn (button-at (point)) )
         (file-path (button-get butn 'file-path)))

    (find-file file-path)
    (kadir-tree/next-line)))


(defun recursive-write (tree depth)
  (setq windows-buffers (-distinct (-non-nil (--map (buffer-file-name (window-buffer it))
                                                    (window-list)))))

  (let ((files (sort (ht-get tree 'files)
                     (lambda (a b) (string< (ht-get a 'name) (ht-get b 'name)))))
        (button-face nil))

    (dolist (file files)

      (dotimes (i depth) (insert "|  "))
      (when (eq depth 0) (insert "- "))

      (when (-contains? git-files (ht-get file 'relative-path))  ;; TODO: should more fast
        (setq button-face 'link-visited))
      (when (-contains? buffer-files (ht-get file 'relative-path)) ;; TODO: should more fast
        (setq button-face 'link))
      (when (-contains? windows-buffers (ht-get file 'file-path)) ;; TODO: should more fast
        (setq button-face 'link)) ;; -bold


      ;; (insert (ht-get file 'name))

      (insert-text-button
       (ht-get file 'name)
       'face button-face
       'file-path (ht-get file 'file-path)
       'keymap (let ((map (make-sparse-keymap)))
                 (define-key map "k" #'kadir-tree/kill-from-button)
                 (define-key map "o" #'kadir-tree/open-from-button)
                 (define-key map (kbd "C-m") #'kadir-tree/open-from-button)
                 map)
       'follow-link t)


      (if (s-equals? current-buffer-name (ht-get file 'file-path))  ;; TODO: local is bind bad
          (insert " <<-----")
        ;; (when (-contains? windows-buffers (ht-get file 'file-path)) ;; TODO: should more fast
        ;;   (insert " <-"))
        )

      (insert "\n")))

  (when (eq depth 0) (insert "\n"))

  (let ((folders (sort (ht-keys tree) 'string<)))

    (dolist (key folders)
      (unless (eq key 'files)

        (dotimes (i depth) (insert "|  "))
        (insert key)
        (insert "\n")
        (recursive-write (ht-get tree key) (+ 1 depth))))))


(defun kadir/updater-activate()
  (interactive)
  (add-hook 'buffer-list-update-hook 'update-git-changes))

(defun kadir/updater-deactivate()
  (interactive)
  (remove-hook 'buffer-list-update-hook 'update-git-changes))


;;;;;;;;;;;;;;;;;;;;;;;;


(defun kadir/open-updater()
  (interactive)
  (kadir/updater-activate)
  (kadir/split-and-follow-horizontally)
  (other-window 1)
  (other-window -1)
  (display-buffer (get-buffer-create refresh-buff) '(display-buffer-same-window))
  (select-window (get-buffer-window refresh-buff))
  (kadir/smart-push-pop))


;;;;;;;;;;;;;;;;;;;;;;;;


(defun kadir-tree/next-line()
  (interactive)
  (forward-button 1))

(defun kadir-tree/prev-line()
  (interactive)
  (backward-button 1))

(defvar kadir-tree-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "C-n" #'kadir-tree/next-line)
    (define-key map "n" #'kadir-tree/next-line)
    (define-key map "p" #'kadir-tree/prev-line)
    (define-key map "C-p" #'kadir-tree/prev-line)
    (define-key map "g" #'update-git-changes)
    map))



(define-derived-mode kadir-tree-mode nil "Kadir Tree"
  (god-local-mode -1)
  (god-local-mode-pause)
  (toggle-truncate-lines -1)
  (toggle-read-only 1))


(global-set-key (kbd "C-ü")
                (lambda ()
                  (interactive)
                  (kadir/open-updater)
                  (select-window (get-buffer-window refresh-buff))
                  (kadir-tree-mode)))


(provide 'git-file-tree)
