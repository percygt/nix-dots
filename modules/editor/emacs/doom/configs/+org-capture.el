;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)
  (defun +org-capture/replace-brackets (link)
    (mapconcat
     (lambda (c)
       (pcase (key-description (vector c))
         ("[" "(")
         ("]" ")")
         (_ (key-description (vector c)))))
     link))

  (defun +aiz-www-get-page-title (url)
    (let ((title))
      (with-current-buffer (url-retrieve-synchronously url)
        (goto-char (point-min))
        (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
        (setq title (match-string 1))
        (goto-char (point-min))
        (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
        (decode-coding-string title (intern (match-string 1))))))

  ;;; from: https://abelstern.nl/posts/emacs-quick-capture/
  (defun +quick-capture ()
    (defun +aiz-org-capture-place-template-dont-delete-windows (oldfun args)
      (cl-letf (((symbol-function 'org-switch-to-buffer-other-window) 'switch-to-buffer))
        (apply oldfun args)))
    (defun +aiz-delete-frame-after-capture ()
      (delete-frame)
      (remove-hook 'org-capture-after-finalize-hook '+aiz-delete-frame-after-capture)
      )
    (set-frame-name "emacs org capture")
    (add-hook 'org-capture-after-finalize-hook '+aiz-delete-frame-after-capture)
    (+aiz-org-capture-place-template-dont-delete-windows 'org-capture nil))

  (add-hook! 'org-capture-after-finalize-hook (delete-frame))
  (setq org-capture-templates
        (doct `(("Tasks" :keys "t"
                 :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
                 :file +org-capture-todo-file
                 :headline "Tasks"
                 :type entry
                 :prepend t
                 :template ("* TODO %?"
                            "%{extra}"
                            ":PROPERTIES:"
                            ":Created: %U"
                            ":END:"
                            )
                 :children (("General Task" :keys "t"
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow")
                             :extra  "")
                            ("Url" :keys "u"
                             :icon ("nf-md-web" :set "mdicon" :color "blue")
                             :extra "[[%:link][%(+aiz-www-get-page-title \"%:link\")]]"
                             )
                            ("Clipboard paste" :keys "c"
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan")
                             :extra "%a")
                            ("Linked Task" :keys "l"
                             :icon ("nf-fa-link" :set "faicon" :color "magenta")
                             :extra "%i %a")
                            ("Task with deadline" :keys "d"
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1)
                             :extra "DEADLINE: %^{Deadline:}t")
                            ("Scheduled Task" :keys "s"
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange")
                             :extra "SCHEDULED: %^{Start time:}t")))

                ("Interesting" :keys "i"
                 :icon ("nf-fa-eye" :set "faicon" :color "cyan")
                 :file +org-capture-notes-file
                 :headline "Interesting"
                 :prepend t
                 :type entry
                 :template ("* %? :%{i-type}:"
                            ":PROPERTIES:"
                            ":Created: %U"
                            ":END:"
                            "%{extra}")
                 :children (("Webpage" :keys "w"
                             :icon ("nf-fa-globe" :set "faicon" :color "green")
                             :extra "[[%:link][%(+aiz-www-get-page-title \"%:link\")]]"
                             :i-type "read:web:%^{Type|dev|general}")
                            ("Video" :keys "v"
                             :icon ("nf-oct-video" :set "octicon" :color "red")
                             :extra "[[%:link][%(+aiz-www-get-page-title \"%:link\")]]"
                             :i-type "watch:video:%^{Type|dev|general}")
                            ("Repo" :keys "r"
                             :icon ("nf-fa-git" :set "faicon" :color "orange")
                             :extra "[[%:link][%(+aiz-www-get-page-title \"%:link\")]]"
                             :i-type "repo:dev")
                            ("Article" :keys "a"
                             :icon ("nf-fa-file_text_o" :set "faicon" :color "yellow")
                             :extra "[[%:link][%(+aiz-www-get-page-title \"%:link\")]]"
                             :i-type "read:article:%^{Type|dev|general}")
                            ("Book" :keys "b"
                             :icon ("nf-fa-book" :set "faicon" :color "green")
                             :extra "%i %a"
                             :i-type "read:book:%^{Type|dev|general}")
                            ("Information" :keys "i"
                             :icon ("nf-fa-info_circle" :set "faicon" :color "blue")
                             :extra "%a"
                             :i-type "read:info:%^{Type|dev|general}")
                            ("Idea" :keys "I"
                             :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                             :extra ""
                             :i-type "idea:%^{Type|dev|general}")))

                ("Project" :keys "p"
                 :icon ("nf-oct-repo" :set "octicon" :color "silver")
                 :prepend t
                 :type entry
                 :headline "Inbox"
                 :template ("* %{time-or-todo} %?"
                            "%i"
                            "%a")
                 :file ""
                 :custom (:time-or-todo "")
                 :children (("Project-local todo" :keys "t"
                             :icon ("nf-oct-checklist" :set "octicon" :color "green")
                             :time-or-todo "TODO"
                             :file +org-capture-project-todo-file)
                            ("Project-local note" :keys "n"
                             :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
                             :time-or-todo "%U"
                             :file +org-capture-project-notes-file)
                            ("Project-local changelog" :keys "c"
                             :icon ("nf-fa-list" :set "faicon" :color "blue")
                             :time-or-todo "%U"
                             :heading "Unreleased"
                             :file +org-capture-project-changelog-file)))
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
                             :file +org-capture-central-project-todo-file)
                            ("Project note"
                             :keys "n"
                             :time-or-todo "%U"
                             :heading "Notes"
                             :file +org-capture-central-project-notes-file)
                            ("Project changelog"
                             :keys "c"
                             :time-or-todo "%U"
                             :heading "Unreleased"
                             :file +org-capture-central-project-changelog-file)))

                )))

  ;; (add-hook 'org-capture-mode-hook 'delete-other-windows)
  )
