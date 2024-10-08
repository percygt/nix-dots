;;; common.el --- Common config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(defun common/org-prettify-symbols-setup ()
    ;; checkboxes
    (push '("[ ]" .  "☐") prettify-symbols-alist)
    (push '("[X]" . "☑" ) prettify-symbols-alist)
    ;; (push '("[X]" . "☒" ) prettify-symbols-alist)
    (push '("[-]" . "❍" ) prettify-symbols-alist)
  
    ;; org-babel
    (push '("#+BEGIN_SRC" . ?≫) prettify-symbols-alist)
    (push '("#+END_SRC" . ?≫) prettify-symbols-alist)
    (push '("#+begin_src" . ?≫) prettify-symbols-alist)
    (push '("#+end_src" . ?≫) prettify-symbols-alist)
  
    (push '("#+BEGIN" . ?≫) prettify-symbols-alist)
    (push '("#+END" . ?≫) prettify-symbols-alist)
    (push '("#+BEGIN_QUOTE" . ?❝) prettify-symbols-alist)
    (push '("#+END_QUOTE" . ?❞) prettify-symbols-alist)
  
    ;; (push '("#+BEGIN_SRC python" . ) prettify-symbols-alist) ;; This is the Python symbol. Comes up weird for some reason
    (push '("#+RESULTS:" . ?≚ ) prettify-symbols-alist)
  
    ;; drawers
    (push '(":PROPERTIES:" . ?) prettify-symbols-alist)
  
    ;; tags
    ;; (push '(":Misc:" . "" ) prettify-symbols-alist)
  
    (prettify-symbols-mode))

(provide 'common)
;;; common.el ends here