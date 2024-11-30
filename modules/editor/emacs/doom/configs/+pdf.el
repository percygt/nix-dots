;;; +pdf.el -*- lexical-binding: t; -*-

;; Open PDF files in emacs
(if (assoc "\\.pdf\\'" org-file-apps)
    (setcdr (assoc "\\.pdf\\'" org-file-apps) 'emacs)
  (add-to-list 'org-file-apps '("\\.pdf\\'" . emacs) t))

(after! pdf-tools
  (pdf-tools-install)
  )
