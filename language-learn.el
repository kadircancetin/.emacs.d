(setq kadir/dilogretio-file "~/.emacs.d/test.org")
(setq kadir/dilogretio-template
      '("dilogretio" "Todo" entry (file kadir/dilogretio-file)
        "* %?"))


(use-package org-drill
  :init
  (setq org-drill-save-buffers-after-drill-sessions-p nil)
  (setq org-drill-hide-item-headings-p t)
  (setq org-drill-add-random-noise-to-intervals-p t)
  (setq org-drill-spaced-repetition-algorithm 'simple8)
  (setq org-drill-adjust-intervals-for-early-and-late-repetitions-p t))



(defun kadir/dilogretio-google-translate-response(text)
  "get `text return full translation of string"
  (require 'google-translate)
  (with-temp-buffer
    (insert text)
    (google-translate-buffer)
    (let ((buffer-name "*Google Translate*")
          (result nil))
      (setq result (with-current-buffer (get-buffer buffer-name)
                     (buffer-substring-no-properties (goto-char (point-min)) (goto-char (point-max)))))
      (delete-window (select-window (display-buffer buffer-name)))
      (kill-buffer (get-buffer buffer-name))
      result)))

(defun kadir/dilogretio-google-translate-basic(text)
  (require 'google-translate)
  (with-temp-buffer
    (google-translate-translate "auto" "tr" text 'current-buffer)
    (buffer-string)))

(defun kadir/parse-and-get-direct-translation(full-response)
  (with-temp-buffer
    (insert full-response)
    (goto-char (point-min))
    (next-line 4)
    (s-trim (thing-at-point 'line))))



(defun kadir/safe-add-org-capture-templates()
  (condition-case nil
      (unless (member kadir/dilogretio-template org-capture-templates)
        (add-to-list 'org-capture-templates kadir/dilogretio-template))
    (error
     (setq org-capture-templates (list kadir/dilogretio-template)))))


(defun kadir/dilogretio-org-capture-insert-text(text)
  (let ((full-response (kadir/dilogretio-google-translate-response text)))
    (concat
     (concat text "                               :drill:\n"
             ":PROPERTIES:\n"
             ":DRILL_CARD_TYPE: twosided\n"
             ":END:\n"
             "\n"
             "** english\n"
             text "\n"
             "** turkish\n"
             (kadir/parse-and-get-direct-translation full-response) "\n"
             "** solution\n"
             "#+begin_src emacs-lisp\n\n")
     full-response
     "\n" "#+end_src" "\n")))

(defun kadir/dilogretio-org-capture(text)
  (interactive)
  (kadir/safe-add-org-capture-templates)
  (org-capture nil "dilogretio")
  (insert (kadir/dilogretio-org-capture-insert-text text)))


(use-package grammarly)
(require 'grammarly)
(require 'json)
(use-package org-web-tools)
(require 'org-web-tools)


(setq posframe-buf-name "*scratch*")
(setq ex-json-data nil)

(defun html-normalize(html-data)
  (s-replace
   "\\\\" ""
   (s-replace
    " " " " (org-web-tools--html-to-org-with-pandoc html-data))))

(defun test-on-message (data)  ;; TODO rename
  "On message callback with DATA."
  (let ((json-data (json-parse-string data)))

    (when (gethash "score" json-data)
      (with-current-buffer (get-buffer-create posframe-buf-name)
        (goto-char (point-min))
        (insert (format "* SCORE: ~%s~\n\n" (gethash "score" json-data)))))

    (when (gethash "title" json-data)
      (with-current-buffer (get-buffer-create posframe-buf-name)
        (let ((text nil)))
        (org-mode)

        (setq ex-json-data json-data)
        (setq text
              (format
               "* %s -- \n** %s\n- [%s-%s] %s \n- (replace to ---> ~%s~)"
               (gethash "minicardTitle" json-data)
               (gethash "title" json-data)
               (gethash "highlightBegin" json-data)
               (gethash "highlightEnd" json-data)
               (gethash "text" json-data)
               (gethash "replacements" json-data)))

        (when (gethash "explanation" json-data)
          (setq text (concat text
                             (format  "\n** explanation\n%s" (html-normalize (gethash "explanation"
                                                                                      json-data))))))

        (when (gethash "details" json-data)
          (setq text (concat text (format  "\n*** details\n%s" (html-normalize (gethash "details"
                                                                                        json-data))))))

        (when (gethash "examples" json-data)
          (setq text (concat text (format  "\n** ex\n%s" (html-normalize (gethash "examples"
                                                                                  json-data))))))
        (goto-char (point-max))
        (insert text)))))

(add-to-list 'grammarly-on-message-function-list 'test-on-message)

(defun kadir/gramarly-result-to-buffer(text)
  (interactive)
  (setq kadir/before-gramarly-selected-frame (selected-frame))
  (with-current-buffer (get-buffer-create posframe-buf-name)
    (erase-buffer))
  (grammarly-check-text text))



(defun kadir/dilogretio()
  (interactive)
  (let ((text (if (region-active-p)
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (substring-no-properties (car kill-ring)))))
    (kadir/dilogretio-org-capture text)))

(defun kadir/gramarly()
  (interactive)
  (let ((text (if (region-active-p)
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (thing-at-point 'sentence t))))
    (kadir/gramarly-result-to-buffer text)))



(global-set-key (kbd "C-ç") 'kadir/dilogretio)
;; (global-set-key (kbd "C-g") 'kadir/gramarly)
;; Why are you talking like that to me? Kasf. asdf asf.
