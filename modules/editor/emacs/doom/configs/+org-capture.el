;;; +org-capture.el -*- lexical-binding: t; -*-
(after! org-capture
  (defun +org-capture/replace-brackets (link)
    (mapconcat
     (lambda (c)
       (pcase (key-description (vector c))
         ("[" "(")
         ("]" ")")
         (_ (key-description (vector c)))))
     link))

  (setq org-capture-templates
        (doct `(("Home" :keys "h"
                 :icon ("nf-fa-home" :set "faicon" :color "cyan")
                 :file "Home.org"
                 :prepend t
                 :headline "Inbox"
                 :template ("* TODO %?"
                            "%i %a"))
                ("Work" :keys "w"
                 :icon ("nf-fa-building" :set "faicon" :color "yellow")
                 :file "Work.org"
                 :prepend t
                 :headline "Inbox"
                 :template ("* TODO %?"
                            "SCHEDULED: %^{Schedule:}t"
                            "DEADLINE: %^{Deadline:}t"
                            "%i %a"))
                ("Note" :keys "n"
                 :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
                 :file "Notes.org"
                 :template ("* %?"
                            "%i %a"))
                ("Journal" :keys "j"
                 :icon ("nf-fa-calendar" :set "faicon" :color "pink")
                 :type plain
                 :function (lambda ()
                             (org-journal-new-entry t)
                             (unless (eq org-journal-file-type 'daily)
                               (org-narrow-to-subtree))
                             (goto-char (point-max)))
                 :template "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
                 :jump-to-captured t
                 :immediate-finish t)
                ("Protocol" :keys "P"
                 :icon ("nf-fa-link" :set "faicon" :color "blue")
                 :file "Notes.org"
                 :template ("* TODO %^{Title}"
                            "Source: %u"
                            "#+BEGIN_QUOTE"
                            "%i"
                            "#+END_QUOTE"
                            "%?"))
                ("Protocol link" :keys "L"
                 :icon ("nf-fa-link" :set "faicon" :color "blue")
                 :file "Notes.org"
                 :template ("* TODO %?"
                            "[[%:link][%:description]]"
                            "Captured on: %U"))
                ("Project" :keys "p"
                 :icon ("nf-oct-repo" :set "octicon" :color "silver")
                 :prepend t
                 :type entry
                 :headline "Inbox"
                 :template ("* %{keyword} %?"
                            "%i"
                            "%a")
                 :file ""
                 :custom (:keyword "")
                 :children (("Task" :keys "t"
                             :icon ("nf-cod-checklist" :set "codicon" :color "green")
                             :keyword "TODO"
                             :file +org-capture-project-todo-file)
                            ("Note" :keys "n"
                             :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
                             :keyword "%U"
                             :file +org-capture-project-notes-file))))))

  ;; (add-hook 'org-capture-mode-hook 'delete-other-windows)
  )
