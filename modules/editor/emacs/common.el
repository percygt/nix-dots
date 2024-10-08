;;; common.el --- Common config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(defun common/org-prettify-symbols-setup ()
  ;; checkboxes
  (push '("[ ]" .  "☐") prettify-symbols-alist)
  (push '("[X]" . "☑" ) prettify-symbols-alist)
  (push '("[X]" . "☒" ) prettify-symbols-alist)
  (push '("[-]" . "❍" ) prettify-symbols-alist)
  
  ;; org-babel
  (push '("#+BEGIN:" . ?) prettify-symbols-alist)
  (push '("#+END:" . ?) prettify-symbols-alist)
  
  (push '("#+BEGIN_QUOTE" . ?❝) prettify-symbols-alist)
  (push '("#+END_QUOTE" . ?❞) prettify-symbols-alist)
  
  (push '("#+RESULTS:" . ?≚ ) prettify-symbols-alist)
  
  ;; ;; drawers
  ;; (push '(":PROPERTIES:" . ?) prettify-symbols-alist)
  
  (prettify-symbols-mode))

(provide 'common)
;;; common.el ends here