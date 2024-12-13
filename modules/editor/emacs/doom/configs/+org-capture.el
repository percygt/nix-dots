;;; +org-capture.el -*- lexical-binding: t; -*-
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
              ("Journal" :keys "j"
               :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
               :file "Inbox.org"
               :template "\n* %<%I:%M %p> - %^{Title} \n\n%?\n\n"
               :clock-in t
               :tree-type week
               :clock-resume t
               :datetree t
               :jump-to-captured t
               :immediate-finish t
               )
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
              ("Interesting" :keys "i"
               :icon ("nf-fa-eye" :set "faicon" :color "lcyan")
               :file +org-capture-todo-file
               :prepend t
               :headline "Interesting"
               :type entry
               :template ("* TODO %{desc}%? :%{i-type}:"
                          "%i %a")
               :children (("Webpage" :keys "w"
                           :icon ("nf-fa-globe" :set "faicon" :color "green")
                           :desc "%(org-cliplink-capture) "
                           :i-type "read:web")
                          ("Article" :keys "a"
                           :icon ("nf-fa-file_text_o" :set "faicon" :color "yellow")
                           :desc ""
                           :i-type "read:reaserch")
                          ("Information" :keys "i"
                           :icon ("nf-fa-info_circle" :set "faicon" :color "blue")
                           :desc ""
                           :i-type "read:info")
                          ("Idea" :keys "I"
                           :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                           :desc ""
                           :i-type "idea")))
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
