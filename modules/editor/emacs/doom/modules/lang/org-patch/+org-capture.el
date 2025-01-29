;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)
  (defcustom org-capture/project-file (expand-file-name +org-capture-projects-file org-directory)
    "The path to the file in which project Note will be stored."
    :type '(string)
    )

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

  (setq org-capture-templates
        (doct `(("Project templates"
                 :keys "p"
                 :type entry
                 :prepend t
                 :icon ("nf-fa-laptop_code" :set "faicon" :color "blue")
                 :function +org-capture/project-file
                 :delete-frame t
                 :template ("* %{time-or-todo} %?" "%{extra}")
                 :children (("Todo templates"
                             :keys "t"
                             :prepend nil
                             :icon ("nf-cod-checklist" :set "codicon" :color "green")
                             :time-or-todo "TODO"
                             :heading "Tasks"
                             :children (("Default" :keys "t"
                                         :extra ""
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                                        ("Url" :keys "u"
                                         :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                                         :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                                         :icon ("nf-md-web" :set "mdicon" :color "blue"))
                                        ("Clipboard paste" :keys "c"
                                         :extra "%a"
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                                        ("Linked Task" :keys "l"
                                         :extra "%i %a"
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                                        ("Task with deadline" :keys "d"
                                         :extra "DEADLINE: %^{Deadline:}t"
                                         :hook +org-capture/created-property
                                         :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1))
                                        ("Scheduled Task" :keys "s"
                                         :extra "SCHEDULED: %^{Start time:}t"
                                         :hook +org-capture/created-property
                                         :icon ("nf-oct-calendar" :set "octicon" :color "orange"))
                                        )
                             )
                            ("Note templates"
                             :keys "n"
                             :time-or-todo "%U"
                             :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
                             :heading "Notes"
                             :children (("Default" :keys "n"
                                         :extra  ""
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                                        ("Url" :keys "u"
                                         :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                                         :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                                         :icon ("nf-md-web" :set "mdicon" :color "blue"))
                                        ("Clipboard paste" :keys "c"
                                         :extra "%a"
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                                        ("Linked Task" :keys "l"
                                         :extra "%i %a"
                                         :hook +org-capture/created-property
                                         :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                                        ("Task with deadline" :keys "d"
                                         :extra "DEADLINE: %^{Deadline:}t"
                                         :hook +org-capture/created-property
                                         :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1))
                                        ("Scheduled Task" :keys "s"
                                         :extra "SCHEDULED: %^{Start time:}t"
                                         :hook +org-capture/created-property
                                         :icon ("nf-oct-calendar" :set "octicon" :color "orange"))
                                        )
                             )
                            ))
                ("Tasks" :keys "t"
                 :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
                 :file +org-capture-todo-file
                 :headline "Tasks"
                 :type entry
                 :prepend t
                 :prepare-finalize (lambda () (progn (org-priority) (org-set-tags-command)))
                 :template ("* TODO %? " "%{extra}")
                 :children (("Default" :keys "n"
                             :extra  ""
                             :hook +org-capture/created-property
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                            ("Url" :keys "u"
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                             :icon ("nf-md-web" :set "mdicon" :color "blue"))
                            ("Clipboard paste" :keys "c"
                             :extra "%a"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                            ("Linked Task" :keys "l"
                             :extra "%i %a"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                            ("Task with deadline" :keys "d"
                             :extra "DEADLINE: %^{Deadline:}t"
                             :hook +org-capture/created-property
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1))
                            ("Scheduled Task" :keys "s"
                             :extra "SCHEDULED: %^{Start time:}t"
                             :hook +org-capture/created-property
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange"))))
                ("References" :keys "r"
                 :icon ("nf-fa-eye" :set "faicon" :color "cyan")
                 :file +org-capture-notes-file
                 :prepend t
                 :prepare-finalize (lambda () (org-set-tags-command))
                 :type entry
                 :template ("* %?" "%{extra}")
                 :children (("Webpage" :keys "w"
                             :icon ("nf-fa-globe" :set "faicon" :color "green")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "web") (+org-capture/created-property))))
                            ("Video" :keys "v"
                             :icon ("nf-oct-video" :set "octicon" :color "red")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "video") (+org-capture/created-property))))
                            ("Repo" :keys "r"
                             :icon ("nf-fa-git" :set "faicon" :color "orange")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "repo") (+org-capture/created-property))))
                            ("Book" :keys "b"
                             :icon ("nf-fa-book" :set "faicon" :color "green")
                             :extra "%i %a"
                             :hook (lambda ()(progn (org-set-tags "book") (+org-capture/created-property))))
                            ("Idea" :keys "I"
                             :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                             :extra ""
                             :hook (lambda ()(progn (org-set-tags "idea") (+org-capture/created-property))))
                            )))
              )
        )
  )
