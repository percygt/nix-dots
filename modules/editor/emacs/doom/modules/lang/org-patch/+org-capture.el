;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)

  (defun +org-capture/created-property ()
    (progn (org-set-property "CREATED" (format-time-string (org-time-stamp-format :long :inactive))))
    (insert " ")
    (insert " ")
    (backward-char))

  (setq org-tag-alist '(("dev"            . ?d)
                        ("quick"          . ?q)
                        ("url"            . ?u)

                        ("email"          . ?m)
                        ("parents"        . ?p)
                        ("errands"        . ?e)
                        ("watch"          . ?w)
                        ("read"           . ?r)
                        ("idea"           . ?i)

                        ("youtube"        . ?y)
                        ("video"          . ?v)
                        ("article"        . ?t)
                        ("web"            . ?n)
                        ("repo"           . ?g)
                        ("book"           . ?b)
                        ))

  (add-hook! 'org-capture-after-finalize-hook (delete-frame))
  (defun +org-capture/get-project-name ()
    (let ((heading
           (file-name-nondirectory (directory-file-name
                                    (org-project-capture-location-for-project
                                     (projectile-completing-read "Capture note for project:"
        							 (occ-get-categories org-projectile-strategy))
                                     )))
           ))
      (org-link-make-string
       (format "elisp:(org-project-capture-open-project \"%s\") [/]" heading) heading))
    )
  ;; (setq org-capture-templates '(("t" "Task" entry (file+headline (lambda ()
  ;;                                                                  (concat (org-project-capture-location-for-project
  ;;                                                                           (+org-capture/get-category)
  ;;                                                                           )
  ;;       					                           "hey.org"))  (file-name-nondirectory (directory-file-name
  ;;                                                                          (org-project-capture-location-for-project
  ;;                                                                           (+org-capture/get-category)

  ;;                                                                           ))))
  ;;                                "* TODO %?\n %U\n %i\n  %a")
  ;;                               ("n" "Note" entry (file+headline (lambda ()
  ;;       			                                   (concat (org-projectile-location-for-project
  ;;       				                                    (projectile-completing-read "Capture note for project:"
  ;;       								                                (occ-get-categories org-projectile-strategy))) "note/note.org")) "Notes")
  ;;                                "* %?\n %U\n %i\n  %a")
  ;;                               ("g" "Gate" entry (file+headline (lambda ()
  ;;       			                                   (concat (org-projectile-location-for-project
  ;;       				                                    (projectile-completing-read "Capture gate for project:"
  ;;       								                                (occ-get-categories org-projectile-strategy))) "note/note.org")) "Gates")
  ;;                                "* %?\n %U\n %i\n  %a")))
  (defun goto-end-of-subheading ()
    "Move point to the end of the first subheading (level 2) under the current heading."
    (org-forward-heading-same-level 1)  ;; Move to the first subheading at the same level
    (if (org-at-heading-p)
        (outline-next-heading)           ;; Move to the end of the subheading by going to the next heading
      (error "No subheading found")))
  (setq org-capture-templates
        (doct `(
                ("Centralised project templates"
                 :keys "o"
                 :type entry
                 :function (lambda ()
                             (progn
                               (require 'org-project-capture)
                               (let* ((category
                                       (org-projectile-completing-read
                                        "Select which project:"))
                                      (category-location
                                       (apply 'occ-get-category-heading-location '(category)))
                                      (heading-location (apply 'occ-get-category-heading-location '("Tasks"
                                                                                                    :goto-subheading (lambda ()
                                                                                                                       (org-forward-heading-same-level 1)
                                                                                                                       )
                                                                                                    )))
                                      )
                                 (if category-location
                                     (progn
                                       (goto-char category-location)
                                       (goto-char heading-location)
                                       ;; (goto-char "TASKS")
                                       )
                                   (occ-insert-at-end-of-file)
                                   (org-set-property "CATEGORY" category)
                                   (insert (org-project-capture-build-heading category))
                                   (org-insert-subheading t)
                                   (insert "Tasks")
                                   )))
                             )
                 :template (
                            "** %{time-or-todo} %?"
                            "%a")
                 :children (("Project todo"
                             :keys "t"
                             :time-or-todo "TODO"
                             :file org-project-capture-projects-file)
                            ("Project note"
                             :keys "n"
                             :time-or-todo "%U"
                             :file org-project-capture-projects-file)
                            ("Project changelog"
                             :keys "c"
                             :time-or-todo "%U"
                             :file org-project-capture-projects-file)
                            ))
                ("Tasks" :keys "t"
                 :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
                 :file +org-capture-todo-file
                 :headline "Tasks"
                 :type entry
                 :prepend t
                 :prepare-finalize (lambda ()
                                     (progn (org-priority)
                                            (org-set-tags-command)))
                 :template ("* TODO %? "
                            "%{extra}")
                 :children (("Default" :keys "t"
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow")
                             :hook +org-capture/created-property
                             :extra  "")
                            ("Url" :keys "u"
                             :icon ("nf-md-web" :set "mdicon" :color "blue")
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "url")
                                       (+org-capture/created-property)
                                       ))
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]")
                            ("Clipboard paste" :keys "c"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan")
                             :extra "%a")
                            ("Linked Task" :keys "l"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-link" :set "faicon" :color "magenta")
                             :extra "%i %a")
                            ("Task with deadline" :keys "d"
                             :extra ""
                             :hook (lambda ()
                                     (progn
                                       (org-deadline)
                                       (+org-capture/created-property)
                                       ))
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1)
                             )
                            ("Scheduled Task" :keys "s"
                             :extra ""
                             :hook (lambda ()
                                     (progn
                                       (org-schedule)
                                       (+org-capture/created-property)
                                       ))
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange")
                             )))
                ("Interesting" :keys "i"
                 :icon ("nf-fa-eye" :set "faicon" :color "cyan")
                 :file +org-capture-notes-file
                 :prepend t
                 :prepare-finalize (lambda ()
                                     (org-set-tags-command))
                 :type entry
                 :template ("* %?"
                            "%{extra}")
                 :children (("Webpage" :keys "w"
                             :icon ("nf-fa-globe" :set "faicon" :color "green")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "web")
                                       (+org-capture/created-property)
                                       )))
                            ("Video" :keys "v"
                             :icon ("nf-oct-video" :set "octicon" :color "red")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "video")
                                       (+org-capture/created-property)
                                       )))
                            ("Repo" :keys "r"
                             :icon ("nf-fa-git" :set "faicon" :color "orange")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "repo")
                                       (+org-capture/created-property)
                                       )))
                            ("Book" :keys "b"
                             :icon ("nf-fa-book" :set "faicon" :color "green")
                             :extra "%i %a"
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "book")
                                       (+org-capture/created-property)
                                       )))
                            ("Idea" :keys "I"
                             :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                             :extra ""
                             :hook (lambda ()
                                     (progn
                                       (org-set-tags "idea")
                                       (+org-capture/created-property)
                                       )))
                            )))
              )
        )
  )
