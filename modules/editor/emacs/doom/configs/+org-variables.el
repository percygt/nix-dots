(setq enable-dir-local-variables t)
(defun +aiz-find-time-property (property)
  "Find the PROPETY in the current buffer."
  (save-excursion
    (goto-char (point-min))
    (let ((first-heading
           (save-excursion
             (re-search-forward org-outline-regexp-bol nil t))))
      (when (re-search-forward (format "^#\\+%s:" property) nil t)
        (point)))))

(defun +aiz-has-time-property-p (property)
  "Gets the position of PROPETY if it exists, nil if not and empty string if it's undefined."
  (when-let ((pos (+aiz-find-time-property property)))
    (save-excursion
      (goto-char pos)
      (if (and (looking-at-p " ")
               (progn (forward-char)
                      (org-at-timestamp-p 'lax)))
          pos
        ""))))

(defun +aiz-set-time-property (property &optional pos)
  "Set the PROPERTY in the current buffer.
Can pass the position as POS if already computed."
  (when-let ((pos (or pos (+aiz-find-time-property property))))
    (save-excursion
      (goto-char pos)
      (if (looking-at-p " ")
          (forward-char)
        (insert " "))
      (delete-region (point) (line-end-position))
      (let* ((now (format-time-string "<%Y-%m-%d %H:%M>")))
        (insert now)))))

(add-hook! 'before-save-hook (when (derived-mode-p 'org-mode)
                               (+aiz-set-time-property "LAST_MODIFIED")
                               (+aiz-set-time-property "DATE_UPDATED")))
