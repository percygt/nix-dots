;;; +org-roam-capture.el -*- lexical-binding: t; -*-

(after! org-roam
  (cl-defmethod org-roam-node-capitalized-slug
    ((node org-roam-node)) (capitalize (org-roam-node-slug node)))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  (setq org-roam-dailies-capture-templates
        (let ((head
               (concat "#+title: %<%Y-%m-%d (%A)>\n"
                       "#+startup: showall\n"
                       "#+filetags: :dailies:\n"
                       "* Daily Overview\n"
                       "* [/] Do Today\n"
                       "* [/] Maybe Do Today\n"
                       "* Journal\n")))
          `(("j" "journal" entry
             "* %<%H:%M> %?"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" ,head ("journal"))
             :empty-lines 1
             :jump-to-captured t)
            ("t" "do today" entry
             "** TODO %i %?"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" ,head ("do today"))
             :immediate-finish t
             :empty-lines 1
             :jump-to-captured t)
            ("m" "maybe do today" entry
             "** SOMEDAY %a"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" ,head ("maybe do today"))
             :immediate-finish t
             :empty-lines 1
             :jump-to-captured t))))
  (setq org-roam-capture-templates
        `(("m" "moc" plain "%?"
           :target
           (file+head
            "${capitalized-slug}.org"
            "#+title: ${capitalized-title}\n#+created: <%<%Y-%m-%d>>\n#+filetags: :MOC:${slug}:\n* Map of Content\n#+BEGIN: notes :tags ${slug}\n#+END:")
           :jump-to-captured t
           :unnarrowed t)
          ("n" "note" plain
           ,(format "#+title: ${title}\n%%[%s/templates/note.org]" org-directory)
           :target (file "notes/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
           :unnarrowed t)
          ("r" "ref" plain "%?"
           :target
           (file+head
            "org/${citekey}.org"
            "#+title: ${slug}: ${title}\n#+filetags: reference ${keywords} \n\n* ${title}\n\n\n* Summary\n\n\n* Rough note space\n"
            )
           )))
  )
