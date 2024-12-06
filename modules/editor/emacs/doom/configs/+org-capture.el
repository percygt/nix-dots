;;; +org-capture.el -*- lexical-binding: t; -*-
(setq org-capture-templates
      (doct `(("Personal todo" :keys "t"
               :icon ("nf-oct-checklist" :set "octicon" :color "green")
               :file +org-capture-todo-file
               :prepend t
               :headline "Inbox"
               :type entry
               :template ("* TODO %?"
                          "%i %a"))
              ("Personal note" :keys "n"
               :icon ("nf-fa-sticky_note_o" :set "faicon" :color "green")
               :file +org-capture-todo-file
               :prepend t
               :headline "Inbox"
               :type entry
               :template ("* %?"
                          "%i %a"))
              )
            )
      )

(add-hook 'org-capture-mode-hook 'delete-other-windows)
