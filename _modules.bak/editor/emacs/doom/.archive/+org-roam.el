;;; +org-roam.el -*- lexical-binding: t; -*-

(after! org-roam
  (load! "+org-roam-capture.el")
  (load! "+org-roam-nursery.el")
  )
(setq org-roam-directory org-directory
      org-roam-db-location (file-name-concat org-directory "resources/.org-roam.db")
      org-roam-dailies-directory "journal/")

(setq org-roam-node-display-template
      "${title:65}📝${tags:*}")

(map! :after org-roam
      :leader
      :prefix ("R" . "Roam")
      "b" #'org-roam-buffer-toggle
      "f" #'org-roam-node-find
      "g" #'org-roam-graph
      "c" #'org-roam-capture
      "d" #'org-roam-dailies-capture-today
      "p" #'org-roam-find-project
      "t" #'org-roam-capture-task
      "n" #'org-roam-capture-inbox)

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
   nil
   :templates
   '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Project:")
      :unnarrowed t))))

(defun org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* TODO %?"
                                   :target (file+head "Inbox.org" "#+title: Inbox\n\n")))))

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
                                                          "#+title: ${title}\n#+filetags: :Project:"
                                                          ("Tasks"))))))

(map! :after org-roam
      :leader
      :map org-roam-mode-map
      :prefix ("o" . "Org")
      "." #'completion-at-point
      "i" #'org-roam-node-insert)
