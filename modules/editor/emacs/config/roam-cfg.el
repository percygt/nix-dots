;;; roam-cfg.el --- Roam Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :preface
  (defun get-files-in-directory (dir)
    "Return a list of file names in the specified directory DIR, excluding directories."
    (let ((files (directory-files dir t)))
      (cl-remove-if (lambda (file)
                      (or (file-directory-p file) ; Ignore directories
                          (string-match-p "\\`\\." (file-name-nondirectory file)))) ; Ignore '.' and '..'
                    files)))
  (defun get-next-file-number (dir)
    "Return the next available file number based on the first two digits in file names in DIR."
    (let ((files (get-files-in-directory dir)) ; Get the list of files
          (max-number -1)) ; Initialize the max number
      ;; Iterate through each file
      (dolist (file files)
	(let* ((file-name (file-name-nondirectory file)) ; Get just the file name
               (number (and (string-match "\\`\\([0-9][0-9]\\)-" file-name) ; Extract digits
                            (string-to-number (match-string 1 file-name)))))
          (when number
            (setq max-number (max max-number number))))) ; Update max number if necessary
      (format "%02d" (1+ max-number))))
  :config
  (org-roam-setup)
  (cl-defmethod org-roam-node-numbered-slug
    ((node org-roam-node)) (upcase (concat (get-next-file-number notes-directory) "-" (org-roam-node-slug node))))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  :custom
  (org-roam-directory notes-directory)
  (org-roam-dailies-directory "journals/")
  (org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$")
  (org-roam-capture-templates
   `(
     ("i" "index" plain
      "* Map of Content\n\n#+BEGIN: notes :tags \"${slug}\"\n\n#+END:"
      :target
      (file+head
       "${numbered-slug}.org"
       "#+title: ${capitalized-title}\n#+date: %<%Y-%m-%d>\n#+filetags: :MOC:${slug}:\n\n")
      :unnarrowed t)
     ("s" "standard" plain "%?"
      :target
      (file+head
       "org/%<%Y%m%d_%H%M%S>_${slug}.org"
       "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: : \n\n")
      :unnarrowed t)
     ("r" "ref" plain "%?"
      :target
      (file+head
       "org/${citekey}.org"
       "#+title: ${slug}: ${title}\n#+filetags: reference ${keywords} \n\n* ${title}\n\n\n* Summary\n\n\n* Rough note space\n")
      :unnarrowed t)
     ("p" "person" plain "%?"
      :target
      (file+head
       "org/${slug}.org"
       "%^{relation|some guy|family|friend|colleague}p %^{birthday}p %^{address}p#+title:${slug}\n#+filetags: :person: \n"
       :unnarrowed t))))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+datetree
	       "%<%Y-%m-%d>.org" week))))
  (org-roam-mode-sections '(org-roam-backlinks-section
                            org-roam-reflinks-section
                            org-roam-unlinked-references-section))
  :evil-bind ((:map (leader-map)
		    ("eb" . org-roam-buffer-toggle)
		    ("ef" . org-roam-node-find)
		    ("eg" . org-roam-graph)
		    ("el" . org-roam-node-insert)
		    ("ec" . org-roam-capture)
		    ;; Dailies
		    ("ed" . org-roam-dailies-capture-today))))


(provide 'roam-cfg)
;;; roam-cfg.el ends here