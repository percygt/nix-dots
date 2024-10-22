;;; +org-agenda.el -*- lexical-binding: t; -*-

(after! org
  (setq org-agenda-files (list org-directory))
  (setq org-agenda-todo-ignore-states '("SOMEDAY" "CANCELLED"))
  ;; Setup org-agenda for that jawn
  (setq org-agenda-custom-commands
        '(
          ("N" "Notes" tags "NOTE"
           ((org-agenda-overriding-header "Notes")
            (org-tags-match-list-sublevels t)))

          ("c" "Simple agenda view"
           ((agenda "")
            (todo "TODO")
            (todo "WAITING")
            (todo "SOMEDAY")))

          ;; ("p" "Special states"
          ;;  ((todo "SOMEDAY|CANCELLED"
          ;;         ((org-agenda-overriding-header "Someday/Maybe and Cancelled items:"))))
          ;;  ("s" "Someday items"
          ;;   ((todo "SOMEDAY"
          ;;          ((org-agenda-overriding-header "Someday/Maybe items:")))))
          ;;  ("c" "Cancelled items"
          ;;   ((todo "CANCELLED"
          ;;          ((org-agenda-overriding-header "Cancelled items:")))))
          ;;  ("a" "Active TODOs (exclude SOMEDAY and CANCELLED)"
          ;;   ((todo ""
          ;;          ((org-agenda-todo-ignore-states '("SOMEDAY" "CANCELLED"))
          ;;           (org-agenda-overriding-header "Active TODOs (excluding SOMEDAY and CANCELLED):"))))))))

          ;; Setup Org agenda to by default exclude cancelled stuff
          )
        ))
