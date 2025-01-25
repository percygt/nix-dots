;;; lang/org-patch/autoload.el -*- lexical-binding: t; -*-
;; (defun +org-capture/replace-brackets (link)
;;   (mapconcat
;;    (lambda (c)
;;      (pcase (key-description (vector c))
;;        ("[" "(")
;;        ("]" ")")
;;        (_ (key-description (vector c)))))
;;    link))

(defun +org-capture/www-get-page-title (url)
  (let ((title))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char (point-min))
      (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
      (setq title (match-string 1))
      (goto-char (point-min))
      (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
      (decode-coding-string title (intern (match-string 1))))))

  ;;; from: https://abelstern.nl/posts/emacs-quick-capture/
(defun +org-capture/quick-capture ()
  (defun +org-capture/place-template-dont-delete-windows (oldfun args)
    (cl-letf (((symbol-function 'org-switch-to-buffer-other-window) 'switch-to-buffer))
      (apply oldfun args)))
  (defun +org-capture/delete-frame-after-capture ()
    (delete-frame)
    (remove-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
    )
  (set-frame-name "emacs org capture")
  (add-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
  (+org-capture/place-template-dont-delete-windows 'org-capture nil))
