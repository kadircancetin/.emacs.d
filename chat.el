;; main source:: https://github.com/d1egoaz/c3po.el

(setq c3po-developer-role "You're a software engineer expert. Your responses should be brief and written
in proper markdown format. Response MUST use full and well written markdown.")

(setq c3po-writter-role "You are a writing assistant and you will help me with my grammar
issues. I will give you text to be used in the code. Please fix
any grammar issues. Just focus on basic grammar issues and avoid
complex ones or hard English words. If you couldn't find any
grammar issues, please respond with 'No grammar issues
found'. The initial and end double quotes MUST be removed from
the response. Your response MUST be concise.")

(setq c3po-model "gpt-3.5-turbo")
(setq c3po-buffer-name "*c3po*")

(setq kadir-chat-grammar-fix-faces
      '(tree-sitter-hl-face:doc
        tree-sitter-hl-face:string
        tree-sitter-hl-face:string.special
        font-lock-comment-face
        font-lock-doc-face
        font-lock-string-face
        font-lock-comment-delimiter-face
        font-lock-comment-end-skip
        font-lock-comment-start-skip))

(defvar c3po--last-role)

(setq c3po--session-messages '())

;; helpers


(defun c3po--request-open-api (role callback &rest args)
  (setq c3po--last-role role)
  (let* ((api-key kadir-chat-chatgpt-api-key)
         (url "https://api.openai.com/v1/chat/completions")
         (model c3po-model)
         (url-request-method "POST")
         (url-request-extra-headers `(("Content-Type" . "application/json")
                                      ("Authorization" . ,(format "Bearer %s" api-key))))
         ;; needed to use us-ascii, instead of utf-8 due to a multibyte text issue
         (url-request-data (encode-coding-string
                            (json-encode `(:model ,model :messages ,c3po--session-messages))
                            'us-ascii)))
    (url-retrieve url
                  #'c3po--extract-content-response
                  (list callback args))
    (message "Thinking...")))


(defun kadir-chat--faces-at-point ()
  "source: spell-fu.el"
  (let ((faces nil)
        (faceprop (or (get-text-property (point) 'read-face-name) (get-text-property (point) 'face))))
    (cond
     ((facep faceprop)
      (push faceprop faces))
     ((face-list-p faceprop)
      (dolist (face faceprop)
        (when (facep face)
          (push face faces)))))
    faces))

(defun kadir-chat--chat-at-point-is-grammar-face-p ()
  (let
      ((result (null kadir-chat-grammar-fix-faces))
       (faces-at-pos (kadir-chat--faces-at-point)))
    (while faces-at-pos
      (let ((face (pop faces-at-pos)))
        (when (and (null result) (memq face kadir-chat-grammar-fix-faces))
          (setq result t))))
    result))

(defun kadir-chat--char-at-point-is-blank-string-p ()
  ;; TODO write simple implemenation with string-blank-p
  (let ((ch (char-after (point))))
    (if (or (string-match-p "^[[:space:]]$" (char-to-string ch))
            (eq ch ?\n))
        t)))

(defun kadir-chat--fully-grammar-fix-face-p (start end)
  (unless (string-blank-p (buffer-substring start end))
    (let ((start (region-beginning))
          (end (region-end)))
      (catch 'not-str
        (save-excursion
          (goto-char start)
          (while (<= (point) end)
            (unless (or (kadir-chat--chat-at-point-is-grammar-face-p)
                        (kadir-chat--char-at-point-is-blank-string-p))
              (throw 'not-str nil))
            (forward-char))
          t)))))


(defun c3po-new-session ()
  "Reset the session message list to an empty list."
  (setq c3po--session-messages '()))

(defun c3po-append-result (str)
  (save-window-excursion
    (let ((buf (get-buffer-create c3po-buffer-name)))
      (with-current-buffer buf
        (visual-line-mode)
        (gfm-mode)
        (goto-char (point-max))
        (insert (concat "\n" str))
        (goto-char (point-max))))))

(defun c3po--add-message (role content)
  "Add a message with given ROLE and CONTENT to the session message alist."
  (setq c3po--session-messages (append c3po--session-messages `((("role" . ,role) ("content" . ,content))))))

(defun c3po--extract-content-response (_status callback &rest args)
  (let* ((data (buffer-substring-no-properties (1+ url-http-end-of-headers) (point-max)))
         (json-string (decode-coding-string data 'utf-8))
         (json-object (json-read-from-string json-string))
         (message-content (aref (cdr (assoc 'choices json-object)) 0))
         (content (cdr (assoc 'content (cdr (assoc 'message message-content))))))
    (apply callback content args)))


;; useful


(defun c3po-new-chat (prompt role)
  "Interact with the ChatGPT API with the PROMPT using the role ROLE.
Uses by default the writter role."
  (interactive)
  (c3po-new-session)
  (c3po-append-result (format "\n# New Session - %s\n## 🙋‍♂️ Prompt\n%s\n" (format-time-string "%A, %e %B %Y %T %Z") prompt))
  (c3po--add-message "system" (if (eq role 'dev) c3po-developer-role c3po-writter-role))
  (c3po--add-message "user" prompt)
  (c3po--request-open-api role
                          (lambda (result &rest _args)
                            (c3po--add-message "assistant" result)
                            (c3po-append-result (format "### 🤖 Response\n%s\n" result))
                            (open-chat-posframe))))


;; interactives


(defun c3po-reply ()
  "Reply with a message and submit the information."
  (interactive)
  (let ((prompt (read-string "Reply: ")))
    (c3po--add-message "user" prompt)
    (c3po-append-result (format "#### 🙋‍♂️ Reply\n%s\n" prompt))
    (c3po--request-open-api c3po--last-role
                            (lambda (result &rest _args)
                              (c3po--add-message "assistant" result)
                              (c3po-append-result (format "##### 🤖 Response\n%s\n" result))
                              (open-chat-posframe)))))


(defun kadir/chat ()
  (interactive)
  (let ((text nil)
        (role 'dev))
    (cond ((and (use-region-p)
                (kadir-chat--fully-grammar-fix-face-p (region-beginning) (region-end))
                (yes-or-no-p "Gammar Issue?"))
           (setq text (buffer-substring-no-properties (region-beginning) (region-end)))
           (setq text (concat "Here is the text:" ":\n\n" text))
           (setq role 'writter))

          ((and (use-region-p)
                (not (kadir-chat--fully-grammar-fix-face-p (region-beginning) (region-end))))
           (setq text (let ((prompt (read-string "Selected Code Prompt => ")))
                        (format "%s\n\nHere is the code:\n```\n%s\n```"
                                prompt
                                (buffer-substring-no-properties (region-beginning) (region-end)))))
           (setq role 'dev))
          (t
           (setq text (read-string "(DEV NEW) Enter text to explain: "))
           (setq role 'dev)))
    (c3po-new-chat text role)))


;; posframe related


(setq kadir-chat-pos-opened nil)
(defun open-chat-posframe ()
  "Shows the current buffer in a posframe."
  (interactive)
  (get-buffer-create c3po-buffer-name)
  (let ((buf (current-buffer))
        (posframe-max-height 30)
        (posframe-width 80))

    (posframe-show c3po-buffer-name
                   :max-height posframe-max-height
                   :width posframe-width
                   :poshandler 'posframe-poshandler-frame-top-center
                   :left-fringe 8
                   :right-fringe 8
                   :background-color "black"
                   :foreground-color (face-foreground 'default)
                   :internal-border-width 4
                   :cursor 'box
                   :window-point (with-current-buffer c3po-buffer-name (point-max))
                   :accept-focus t)

    (with-current-buffer c3po-buffer-name (visual-line-mode 1))

    (setq kadir-chat-pos-opened t)))

(defun my-hide-posframe ()
  "Hide the current `posframe` buffer."
  (interactive)
  (setq kadir-chat-pos-opened nil)
  (when (posframe-workable-p)
    (posframe-hide-all))
  (setq kadir-chat-pos-opened nil))

(defun toggle-posframe ()
  "Toggle the current `posframe` buffer."
  (interactive)
  (if kadir-chat-pos-opened
      (my-hide-posframe)
    (open-chat-posframe)))

;;; bind

(defun my-handle-key ()
  (interactive)
  (if kadir-chat-pos-opened
      (c3po-reply)
    (kadir/chat))
  (with-current-buffer c3po-buffer-name
    (end-of-buffer)))

(global-set-key (kbd "M-ç") 'my-handle-key)
(global-set-key (kbd "M-Ç") 'toggle-posframe)
