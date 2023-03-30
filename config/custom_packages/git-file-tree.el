(require 'projectile)
(require 'ht)


(cl-defstruct file-info name relative-path file-path) ;; TODO: :type  :constructor
(cl-defstruct kadir-tree-source refresh-func print-face cached-value is-async) ;; TODO: :type  :constructor


(setq kadir-tree/refresh-buff "*kadir-buffers*")
(setq kadir-tree/git-files '())
(setq kadir-tree/opened-buffers '())



(progn

  (defun update-git-changes(source)
    (interactive)
    (setq kadir-tree/git-files '())

    (when (projectile-project-root)
      ;; (condition-case nil
      (make-process
       :noquery t

       :command `("bash" "-c" ,(format "cd %s; git status -s | cut -c4-" (projectile-project-root)))
       :name "async-process"

       :filter (lambda (process output)

                 (setq kadir-tree/git-files
                       (--filter (and
                                  (not (s-ends-with? "/" it))
                                  (not (s-contains? ".#" it))
                                  (not (s-equals? "" it)))
                                 (s-split "\n" output))))

       :sentinel (lambda (process event)
                   (when (s-equals? event "finished\n")
                     (kadir-tree/refresh-kadir-tree-buffer))))

      ;; (error (message "err"))
      ;; )
      ))


  (update-git-changes (make-kadir-tree-source :refresh-func 'update-git-changes
                                              :print-face 'link-visited
                                              :is-async t)))




(defun update-opened-buffers()
  (-non-nil (--map (s-chop-prefix (projectile-project-root) (buffer-file-name it))
                   (projectile-project-buffers))))

;;

(setq kadir-tree-sources
      (list
       (make-kadir-tree-source :refresh-func 'update-git-changes
                               :print-face 'link-visited
                               :is-async t)

       (make-kadir-tree-source :refresh-func 'update-opened-buffers
                               :print-face 'link
                               :is-async nil)))




(defun kadir-tree/get-internal-data-type(relative-file-path)
  "
  input:
  '('f1/inner_f/a.py'  'f1/a.py'  'f1/b.py' 'f2/a.py')

  returns
  {
      'f1': {
          'inner_f': {
              'files': [
                  <file-info>
              ]
          },
          'files':[
              <file-info>,
              <file-info>,
          ],
      },
      'f2': {
          'files': [
              <file-info>,
          ]
      }
  }
  "
  (let ((relative-file-path (-distinct relative-file-path))
        (f-tree (ht-create)))

    ;;LOOP
    (dolist (file relative-file-path)

      (let ((file-parsed  (s-split "/" file))
            (last-tree f-tree)
            (inner-tree nil))

        (while (> (length file-parsed) 0)
          (let ((node (car file-parsed)))
            (if (> (length file-parsed) 1)
                (progn
                  ;; if folder
                  (if (not (ht-get last-tree node))
                      ;; if folder but not setted on hashtable
                      (progn
                        (setq inner-tree (ht-create))
                        (ht-set last-tree node inner-tree)
                        (setq last-tree inner-tree))

                    ;; if folder and setted on hashtable
                    (setq last-tree (ht-get last-tree node))))

              ;; if not folder, then add-or-create to 'files list
              (let ((file-node (make-file-info
                                :name node
                                :relative-path file
                                :file-path (concat (projectile-project-root) file))))

                (if (ht-get last-tree 'files)
                    (push file-node (ht-get last-tree 'files))
                  (ht-set last-tree 'files (list file-node)))))

            (setq file-parsed (cdr file-parsed))))))

    f-tree))



(defun kadir-tree/get-all-cached-files()
  (let ((all-files '()))
    (dolist (source kadir-tree-sources)
      (when (kadir-tree-source-cached-value source)
        (setq all-files (-concat (kadir-tree-source-cached-value source) all-files))))
    all-files))


(defun kadir-tree/update-sync-source-caches()
  ;; run sync sources
  (dolist (source kadir-tree-sources)
    (when (eq (kadir-tree-source-is-async source) nil)
      (setf (kadir-tree-source-cached-value source)
            (funcall (kadir-tree-source-refresh-func source))))))


(defun kadir-tree/run-async-sources()
  (dolist (source kadir-tree-sources)
    (when (eq (kadir-tree-source-is-async source) t)
      (funcall (kadir-tree-source-refresh-func source) source))))

(defun kadir-tree/refresh-kadir-tree-buffer()
  (interactive)
  (unless (or (eq (current-buffer) (get-buffer-create kadir-tree/refresh-buff))
              (not (projectile-project-root)))

    (kadir-tree/update-sync-source-caches)

    (let ((files-trees (kadir-tree/get-internal-data-type (kadir-tree/get-all-cached-files)))
          (root (projectile-project-root))
          (curr-buffer (buffer-file-name (current-buffer))))

      (with-current-buffer (get-buffer-create kadir-tree/refresh-buff)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert root)
          (insert "\n\n")
          (recursive-write files-trees 0 curr-buffer))))))




(defun kadir-tree/kill-from-button()
  (interactive)
  (let* ((butn (button-at (point)) )
         (file-path (button-get butn 'file-path))
         (buf- (get-file-buffer file-path)))

    (when buf- (kill-buffer buf-))
    (kadir-tree/next-line)
    )
  (kadir-tree/refresh-kadir-tree-buffer))

(defun kadir-tree/open-from-button()
  (interactive)
  (let* ((butn (button-at (point)) )
         (file-path (button-get butn 'file-path)))

    (find-file file-path)
    (kadir-tree/next-line)))


(defun recursive-write (tree depth curr-buffer)
  (setq windows-buffers (-distinct (-non-nil (--map (buffer-file-name (window-buffer it))
                                                    (window-list)))))

  (let ((files (sort (ht-get tree 'files)
                     (lambda (a b) (string< (file-info-name a) (file-info-name b)))))
        (button-face 'link-visited))

    (dolist (file files)

      (dotimes (i depth) (insert "|  "))
      (when (eq depth 0) (insert "- "))

      (when (-contains? kadir-tree/git-files (file-info-relative-path file))  ;; TODO: should more fast
        (setq button-face 'link-visited))
      (when (-contains? kadir-tree/opened-buffers (file-info-relative-path file)) ;; TODO: should more fast
        (setq button-face 'link))
      (when (-contains? windows-buffers (file-info-file-path file)) ;; TODO: should more fast
        (setq button-face 'link)) ;; -bold


      (insert-text-button
       (file-info-name file)
       'face button-face
       'file-path (file-info-file-path file)
       'keymap (let ((map (make-sparse-keymap)))
                 (define-key map "k" #'kadir-tree/kill-from-button)
                 (define-key map "o" #'kadir-tree/open-from-button)
                 (define-key map (kbd "C-m") #'kadir-tree/open-from-button)
                 map)
       'follow-link t)

      (if (s-equals? curr-buffer (file-info-file-path file))  ;; TODO: local is bind bad
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
        (recursive-write (ht-get tree key) (+ 1 depth) curr-buffer)))))




(defun kadir/updater-activate()
  (interactive)
  (add-hook 'buffer-list-update-hook 'kadir-tree/run-async-sources)) ;; TODO: what if only sync sources

(defun kadir/updater-deactivate()
  (interactive)
  (remove-hook 'buffer-list-update-hook 'kadir-tree/run-async-sources))




(defun kadir/open-updater()
  (interactive)
  (kadir/updater-activate)
  (kadir/split-and-follow-horizontally)
  (other-window 1)
  (other-window -1)
  (display-buffer (get-buffer-create kadir-tree/refresh-buff) '(display-buffer-same-window))
  (select-window (get-buffer-window kadir-tree/refresh-buff))
  (kadir/smart-push-pop))





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
    map))



(define-derived-mode kadir-tree-mode nil "Kadir Tree"
  (god-local-mode -1)
  (god-local-mode-pause)
  (toggle-truncate-lines -1)
  (toggle-read-only 1))


(provide 'git-file-tree)
