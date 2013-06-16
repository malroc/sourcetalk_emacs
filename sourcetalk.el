;;; sourcetalk.el --- SourceTalk (http://sourcetalk.net) plugin for Emacs

;; Copyright (C) 2013 Oleg Kalistratov

;; Author: Oleg Kalistratov <oleg@sourcetalk.net>
;; Keywords: sourcetalk code discussion
;; Version: 0.0.1

(require 'request)

(defun sourcetalk-get-current-line ()
  "Returns the currently selected line number (starting from 1)"
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (1+ (count-lines 1 (point))))))

(defun sourcetalk-get-buffer-content ()
  "Returns the text content of the current buffer"
  (substring-no-properties (buffer-string)))

(defun sourcetalk-get-buffer-file-name ()
  "Returns the file name of the current buffer"
  (file-name-nondirectory (buffer-file-name (current-buffer))))

(defun sourcetalk-start-external-conference ()
  "Starts a new SourceTalk conference in a browser window"
  (interactive)
  (request
   "http://sourcetalk.net/conferences.json"
   :type "POST"
   :data `(("conference[file_name]" . ,(sourcetalk-get-buffer-file-name))
           ("conference[source]" . ,(sourcetalk-get-buffer-content)))
   :parser 'json-read
   :success (function*
             (lambda
               (&key data &allow-other-keys)
               (browse-url (concat "http://sourcetalk.net/conferences/"
                                   (assoc-default 'slug data)
                                   "/"
                                   (number-to-string
                                    (sourcetalk-get-current-line))))))))

(provide 'sourcetalk)
