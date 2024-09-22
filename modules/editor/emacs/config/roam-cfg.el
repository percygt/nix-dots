;;; roam-cfg.el --- Roam Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package md-roam
  :ensure nil
  :after org-roam
  :load-path (expand-file-name "var/packages/md-roam-2024-09-21" user-emacs-data-directory))
  :custom
  (md-roam-file-extension "md")
  :config
  (md-roam-mode 1))

(use-package org-roam
  :after (evil org marginalia)
  :init
  (setq org-roam-v2-ack t)
  :preface
  (defvar auto-org-roam-db-sync--timer nil)
  (defvar auto-org-roam-db-sync--timer-interval 5)
  (defun org-follow-link-other-window ()
    "Force the link at point to open in another window."
    (interactive)
    (let ((org-link-frame-setup
           (cons '(file .
                        (lambda ()
                          (when-let* ((buf (find-file-noselect filename)))
                            (display-buffer-in-direction buf '((direction . rightmost))))))
                 org-link-frame-setup)))
      (org-open-at-point)))
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
  (cl-defmethod org-roam-node-directories ((node org-roam-node))
    (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
	    (format "(%s)" (car (split-string dirs "/")))
      ""))
  (cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
    (let* ((count (caar (org-roam-db-query
			             [:select (funcall count source)
				                  :from links
				                  :where (= dest $s1)
				                  :and (= type "id")]
			             (org-roam-node-id node)))))
      (format "[%d]" count)))
  (cl-defmethod org-roam-node-hierarchy ((node org-roam-node))
    (let ((level (org-roam-node-level node)))
      (concat
       (when (> level 0) (concat (org-roam-node-file-title node) " > "))
       (when (> level 1) (concat (string-join (org-roam-node-olp node) " > ") " > "))
       (org-roam-node-title node))))
  (cl-defmethod org-roam-node-numbered-slug
    ((node org-roam-node)) (upcase (concat (get-next-file-number notes-directory) "-" (org-roam-node-slug node))))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  (define-minor-mode auto-org-roam-db-sync-mode
    "Toggle automatic `org-roam-db-sync' when Emacs is idle.
     Referece: `auto-save-visited-mode'"
    :group 'org-roam
    :global t
    (when auto-org-roam-db-sync--timer (cancel-timer auto-org-roam-db-sync--timer))
    (setq auto-org-roam-db-sync--timer
	      (when auto-org-roam-db-sync-mode
	        (run-with-idle-timer
	         auto-org-roam-db-sync--timer-interval :repeat
	         #'org-roam-db-sync))))

  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-full-frame)))
  :custom
  (org-roam-node-display-template
   (concat "${hierarchy:*} " (propertize "${tags:20}" 'face 'org-tag))
   org-roam-node-annotation-function
   (lambda (node) (marginalia--time (org-roam-node-file-mtime node))))
  (org-roam-directory notes-directory)
  (org-roam-dailies-directory "journals/")
  (org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$")
  (org-roam-capture-templates
   `(("i" "index" plain "%?"
      :target
      (file+head
       "${numbered-slug}.org"
       "#+title: ${capitalized-title}\n#+created: <%<%Y-%m-%d>>\n#+modified: \n#+filetags: :MOC:${slug}:\n\n* Map of Content\n\n#+BEGIN: notes :tags ${slug}\n#+END:")
      :jump-to-captured t
      :immediate-finish t
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
  :general
  (global-definer
    "w"  '(nil :wk "Writer")
    "wb" 'org-roam-buffer-toggle
    "wf" 'org-roam-node-find
    "wg" 'org-roam-graph
    "wc" 'org-roam-capture
    "wd" 'org-roam-dailies-capture-today)
  (global-definer
    :keymaps '(org-mode-map)
    "wi" 'org-roam-node-insert
    ;; "<return>" (general-predicate-dispatch 'org-follow-link-other-window
    ;;              (org-at-table-p) 'org-table-copy-down)
    )
  )

(use-package org-roam-timestamps
  :after org-roam
  :config (org-roam-timestamps-mode))

(provide 'roam-cfg)
;;; roam-cfg.el ends here
