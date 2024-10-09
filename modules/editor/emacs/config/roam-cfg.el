;;; roam-cfg.el --- Roam Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package org-roam
  :after (org marginalia)
  :init
  (setq org-roam-v2-ack t)
  (unless (file-exists-p roam/resourcesDir) (make-directory roam/resourcesDir t))
  :preface
  (defvar roam/resourcesDir (expand-file-name "resources" notesDirectory)
    "Resources directory")

  (defvar auto-org-roam-db-sync--timer nil)

  (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args))) (defvar auto-org-roam-db-sync--timer-interval 5)

  (defun org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (org-roam-list-notes-by-tag "Project")))

  (defun org-roam-project-finalize-hook ()
    "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
    ;; Remove the hook since it was added temporarily
    (remove-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Add project file to the agenda list if the capture was confirmed
    (unless org-note-abort
      (with-current-buffer (org-capture-get :buffer)
        (add-to-list 'org-agenda-files (buffer-file-name)))))

  (defun org-roam-find-project ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Select a project file to open, creating it if necessary
    (org-roam-node-find
     nil
     nil
     (org-roam-filter-by-tag "Project")
     :templates '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
                   :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
                   :unnarrowed t))))

  (defun org-roam-capture-inbox ()
    (interactive)
    (org-roam-capture- :node (org-roam-node-create)
                       :templates '(("i" "inbox" plain "* %?"
                                     :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun org-roam-capture-task ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Capture the new task, creating the project file if necessary
    (org-roam-capture- :node (org-roam-node-read
                              nil
                              (org-roam-filter-by-tag "Project"))
                       :templates '(("p" "project" plain "** TODO %?"
                                     :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                            "#+title: ${title}\n#+filetags: Project"
                                                            ("Tasks"))))))
  :config
  (cl-defmethod org-roam-node-capitalized-slug
    ((node org-roam-node)) (capitalize (org-roam-node-slug node)))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-full-frame)))
  ;; Build the agenda list the first time for the session
  (org-roam-refresh-agenda-list)
  (org-roam-db-autosync-enable)
  (org-roam-setup)
  :custom
  (org-roam-directory notesDirectory)
  (org-roam-db-location (expand-file-name "org-roam.db" roam/resourcesDir))
  (org-roam-node-display-template
   (concat "${title:80} " (propertize "${tags:20}" 'face 'org-tag))
   org-roam-node-annotation-function
   (lambda (node) (marginalia--time (org-roam-node-file-mtime node))))
  (org-roam-completion-everywhere t)
  (org-roam-dailies-directory "journals/")
  (org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$")
  (org-roam-capture-templates
   `(("i" "index" plain "%?"
      :target
      (file+head
       "${capitalized-slug}.org"
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
     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
      :unnarrowed t)
     ("r" "ref" plain "%?"
      :target
      (file+head
       "org/${citekey}.org"
       "#+title: ${slug}: ${title}\n#+filetags: reference ${keywords} \n\n* ${title}\n\n\n* Summary\n\n\n* Rough note space\n")
      :unnarrowed t)
     ))
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
    "wd" 'org-roam-dailies-capture-today
    "wp" 'org-roam-find-project
    "wt" 'org-roam-capture-task
    "wi" 'org-roam-capture-inbox
    )
  (global-definer
    :keymaps '(org-mode-map)
    "w." 'completion-at-point
    "wI" 'org-roam-node-insert-immediate
    "wi" 'org-roam-node-insert))

;; (use-package consult-notes
;;   :commands (consult-notes
;;              consult-notes-search-in-all-notes
;;              ;; if using org-roam
;;              consult-notes-org-roam-find-node
;;              consult-notes-org-roam-find-node-relation)
;;   :config
;;   (setq consult-notes-file-dir-sources '(("Name"  ?key  "path/to/dir"))) ;; Set notes dir(s), see below
;;   ;; Set org-roam integration, denote integration, or org-heading integration e.g.:
;;   (setq consult-notes-org-headings-files '("~/path/to/file1.org"
;;                                            "~/path/to/file2.org"))
;;   (consult-notes-org-headings-mode)
;;   (when (locate-library "denote")
;;     (consult-notes-denote-mode))
;;   ;; search only for text files in denote dir
;;   (setq consult-notes-denote-files-function (function denote-directory-text-only-files)))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-roam-timestamps
  :after org-roam
  :config (org-roam-timestamps-mode))

;; (use-package md-roam
;;   :ensure nil
;;   :after org-roam
;;   :custom
;;   (md-roam-file-extension "md")
;;   :config
;;   (md-roam-mode 1))

(provide 'roam-cfg)
;;; roam-cfg.el ends here
