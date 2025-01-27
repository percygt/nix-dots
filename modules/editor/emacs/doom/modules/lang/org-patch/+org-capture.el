;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)
  (defcustom org-capture/project-file (expand-file-name +org-capture-projects-file org-directory)
    "The path to the file in which project Note will be stored."
    :type '(string)
    )
  (defun +org-capture/created-property ()
    (org-set-property "CREATED" (format-time-string (org-time-stamp-format :long :inactive)))
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

  ;; (add-hook! 'org-capture-after-finalize-hook (delete-frame))

  (setq org-capture-templates
        (doct `(
                ("\tCentralised project templates"
                 :keys "o"
                 :type entry
                 :prepend t
                 :template ("* %{time-or-todo} %?"
                            "%i"
                            "%a")
                 :children (("Project todo"
                             :keys "t"
                             :prepend nil
                             :time-or-todo "TODO"
                             :heading "Tasks"
                             :function +org-capture/project-file)
                            ("Project note"
                             :keys "n"
                             :time-or-todo "%U"
                             :heading "Notes"
                             :function +org-capture/project-file)
                            ("Project changelog"
                             :keys "c"
                             :time-or-todo "%U"
                             :heading "Unreleased"
                             :function +org-capture/project-file)))
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
                 :children (
                            ("Default" :keys "t"
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
                             )
                            ))
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
