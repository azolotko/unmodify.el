;;; unmodify.el -*- lexical-binding: t; -*-

(defvar-local unmodify-original-content-size nil
  "Size of the original content of the buffer.")

(defvar-local unmodify-original-content-hash nil
  "Hash of the original content of the buffer.")

(defun unmodify-store-original-content-size ()
  "Store the size of the buffer's content in `unmodify-original-content-size`."
  (setq unmodify-original-content-size (buffer-size)))

(defun unmodify-store-original-content-hash ()
  "Store the hash of the buffer's content in `unmodify-original-content-hash`."
  (setq unmodify-original-content-hash (sha1 (buffer-string))))

(defun unmodify-check-content-against-original (a b c)
  "Check the current buffer's content size and hash against its original size and hash.
If they are the same, mark the buffer as unmodified."
  (when (and unmodify-original-content-size
             (= unmodify-original-content-size (buffer-size))
             unmodify-original-content-hash
             (string= (sha1 (buffer-string)) unmodify-original-content-hash))
    (set-buffer-modified-p nil)))

(add-hook 'after-change-functions 'unmodify-check-content-against-original)

(defun unmodify-setup-content-tracking ()
  "Set up the tracking of the buffer's original content hash."
  (unmodify-store-original-content-size)
  (unmodify-store-original-content-hash)
  (add-hook 'after-save-hook 'unmodify-store-original-content-size nil t)
  (add-hook 'after-save-hook 'unmodify-store-original-content-hash nil t))

(add-hook 'find-file-hook 'unmodify-setup-content-tracking)

(provide 'unmodify)
