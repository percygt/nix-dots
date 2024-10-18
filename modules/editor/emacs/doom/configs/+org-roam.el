;;; +roam.el -*- lexical-binding: t; -*-

(setq org-roam-directory (file-name-concat org-directory "notes")
      org-roam-db-location (file-name-concat org-directory "resources/.org-roam.db")
      org-roam-dailies-directory "journal/")


(map! :after org-roam
      :leader
      :prefix ("o" . "Org")
      "b" #'org-roam-buffer-toggle
      "f" #'org-roam-node-find
      "g" #'org-roam-graph
      "c" #'org-roam-capture
      "d" #'org-roam-dailies-capture-today
      "p" #'org-roam-find-project
      "t" #'org-roam-capture-task
      "i" #'org-roam-capture-inbox
      )

(map! :after org-roam
      :leader
      :map org-mode-map
      :prefix ("o" . "Org")
      "." #'completion-at-point
      "I" #'org-roam-node-insert-immediate
      "i" #'org-roam-node-insert)

(after! org-roam
  (cl-defmethod org-roam-node-capitalized-slug
    ((node org-roam-node)) (capitalize (org-roam-node-slug node)))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  (setq org-roam-capture-templates
        `(("i" "index" plain
           ,(format "#+title: ${capitalized-title}\n#+filetags: :MOC:${slug}:\n%%[%s/templates/index.org]" org-directory)
           :target (file "${capitalized-slug}.org")
           :jump-to-captured t
           :immediate-finish t
           :unnarrowed t)
          ("n" "note" plain
           ,(format "#+title: ${title}\n%%[%s/templates/note.org]" org-directory)
           :target (file "note/%<%Y%m%d%H%M%S>-${slug}.org")
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
          )))
