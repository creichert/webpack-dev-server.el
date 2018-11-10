;;; package --- Emacs mode to manage webpack-dev-server via compilation-mode
;;;
;;; Commentary:
;;;
;;; webpack-dev-server.el allows you to run a webpack-dev-server process for
;;; your project in an isolated buffer and jump to errors using standard error
;;; navigation via compilation-minor-mode.
;;;
;;; Use M-x webpack-dev-server to launch
;;;
;;; License: MIT
;;;
;;; Code:

(defgroup webpack-dev-server nil
  "Webpack Dev Server mode for Emacs"
  :group 'programming
  :prefix "webpack-dev-server-")

(defcustom webpack-dev-server-command  "webpack-dev-server"
  "Command to run webpack-dev-server."
  :group 'webpack-dev-server
  :type 'string)

(defcustom webpack-dev-server-host "localhost"
  "Host of the webpack-dev-server"
  :group 'webpack-dev-server
  :type 'string)

(defcustom webpack-dev-server-port "8080"
  "Command to run webpack-dev-server."
  :group 'webpack-dev-server
  :type 'string)

(defcustom webpack-dev-server-project-root "."
  "Directory to run webpack-dev-server in."
  :group 'webpack-dev-server
  :type 'string)

(setq webpack-dev-server-height 30)

(setq webpack-dev-server-buf-name "*webpack-dev-server*")

(define-minor-mode webpack-dev-server-mode
  "A minor mode for webpack-dev-server terminals"
  :lighter " Webpack-Dev-Server"
  ;;(nlinum-mode -1)
  (linum-mode -1)
  ;; add error regexp for webpack errors
  (add-to-list
   'compilation-error-regexp-alist-alist
   '(webpack "\\(?:ERROR\\|\\(WARNING\\)\\).* \\(at\\|on\\|in\\) \\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\)"
             3   ;; file
             4   ;; line
             nil ;; column
             (0 . 1)))
  (add-to-list 'compilation-error-regexp-alist 'webpack)
  (compilation-minor-mode))

(defun new-webpack-dev-server-term ()
  (interactive)
  (kill-webpack-dev-server)
  (setq-local default-directory webpack-dev-server-project-root)
  (let ((webpack-dev-server-buf (get-buffer-create webpack-dev-server-buf-name)))
    (display-buffer
     webpack-dev-server-buf
     '((display-buffer-at-bottom
        display-buffer-pop-up-window
        display-buffer-reuse-window)
       (window-height . 30)))
    (select-window (get-buffer-window webpack-dev-server-buf))
    (make-term "webpack-dev-server" "/bin/bash")
    (term-mode)
    (term-char-mode)
    (term-set-escape-char ?\C-x)
    (setq-local term-buffer-maximum-size webpack-dev-server-height)
    (setq-local scroll-down-aggressively 1)
    (setq-local compilation-scroll-output 'first-error)
    (webpack-dev-server-mode)))

(defun kill-webpack-dev-server ()
  (let* ((webpack-dev-server-buf (get-buffer webpack-dev-server-buf-name))
         (webpack-dev-server-proc (get-buffer-process webpack-dev-server-buf)))
    (when (processp webpack-dev-server-proc)
      (progn
        (set-process-query-on-exit-flag webpack-dev-server-proc nil)
        (kill-process webpack-dev-server-proc)))))

(defun add-stars (s) (format "*%s*" s))

;;;###autoload
(defun webpack-dev-server ()
  "Run webpack-dev-server"
  (interactive)
  (let ((cur (selected-window)))
    (new-webpack-dev-server-term)
    (comint-send-string webpack-dev-server-buf-name (format "%s\n" webpack-dev-server-command))
    (select-window cur)))

;;;###autoload
(defun webpack-dev-server-stop ()
  "Stop webpack-dev-server"
  (interactive)
  ;; Assumes that only one window is open
  (let* ((webpack-dev-server-buf (get-buffer webpack-dev-server-buf-name))
         (webpack-dev-server-window (get-buffer-window webpack-dev-server-buf)))
    (when webpack-dev-server-buf
      (progn
        (kill-webpack-dev-server)
        (select-window webpack-dev-server-window)
        (kill-buffer-and-window)))))

;;;###autoload
(defun webpack-dev-server-browse ()
  "Browse the webpack dev server index."
  (interactive)
  (let ((url (concat "http://" webpack-dev-server-host ":"  webpack-dev-server-port)))
    (run-with-timer 2 nil 'browse-url url)))


(provide 'webpack-dev-server)
