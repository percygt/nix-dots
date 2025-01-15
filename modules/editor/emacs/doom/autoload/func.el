;;; $DOOMDIR/autoload/func.el -*- lexical-binding: t; -*-
(defun +org-capture/created-property ()
  (progn (org-set-property "CREATED" (format-time-string (org-time-stamp-format) (org-read-date nil t "+0d"))))
  (insert " ")
  (insert " ")
  (backward-char))
