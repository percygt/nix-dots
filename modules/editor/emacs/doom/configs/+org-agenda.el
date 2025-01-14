;;; +org-agenda.el -*- lexical-binding: t; -*-
(after! org-agenda
  (require 'org-super-agenda)
  (require 'org-ql)
  (add-hook! 'org-agenda-mode-hook
    (org-super-agenda-mode))
  (setq org-agenda-deadline-faces
        '((1.001 . error)
          (1.0 . org-warning)
          (0.5 . org-upcoming-deadline)
          (0.0 . org-upcoming-distant-deadline)))
  (setq org-agenda-prefix-format
        '((agenda . "  %?-12t")
          (todo   . " ")
          (tags   . " %i %-12:c")
          (search . " %i %-12:c")))
  (setq
   org-agenda-start-with-log-mode t
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-include-deadlines t
   org-agenda-block-separator nil
   org-agenda-dim-blocked-tasks 'invisible
   org-agenda-timegrid-use-ampm t
   org-agenda-window-setup 'only-window
   org-agenda-restore-windows-after-quit t
   org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: ")
   org-agenda-block-separator ?_)

  (setq org-agenda-custom-commands
        '(
          ("," "Today"
           ((agenda ""(
                       (org-agenda-overriding-header "Today")
                       (org-agenda-use-time-grid t)
                       (org-agenda-clockreport-parameter-plist '(:compact t
                                                                 :link t
                                                                 :maxlevel 3
                                                                 :fileskip0 t
                                                                 :filetitle t)))
                    )))
          ("m" "Main"
           (
            (agenda "" ((org-agenda-span 'day)
                        (org-agenda-start-day "+0d")  ;; don't include overdue entries in the time grid
                        (org-agenda-entry-types '(:scheduled :deadline)) ;; don't include tasks in the time grid just because they're opened today
                        (org-super-agenda-groups
                         '((:name "Agenda"
                            :time-grid t
                            :and (:scheduled today
                                  :regexp ,org-ql-regexp-scheduled-with-time
                                  :not (:todo ("DONE" "WAIT"))))
                           (:name "Remove anything else"
                            :discard (:anything t))))))

            ;; (org-super-agenda-groups
            ;;  '(
            ;;    (:name "Agenda"
            ;;     :time-grid t
            ;;     :and (:scheduled today
            ;;           :regexp ,org-ql-regexp-scheduled-with-time
            ;;           :not (:todo ("DONE" "WAIT"))))
            ;;    (:name "Remove anything else"
            ;;     :discard (:anything t))
            ;;    (:name "Today"
            ;;     :scheduled t
            ;;     :order 2)
            ;;    (:name "Due Soon"
            ;;     :deadline future
            ;;     :order 3)
            ;;    (:name "Today's Schedule:"
            ;;     :time-grid t
            ;;     :discard (:deadline t)
            ;;     :order 4)))))

            (org-ql-block '(todo)
                          ((org-ql-block-header "Todos")
                           (org-super-agenda-groups
                            '(
                              (:name "Overdue"
                               :deadline past
                               :scheduled past
                               :face error
                               :order 1)
                              (:name "Next to do"
                               :todo "NEXT"
                               :order 2)
                              (:name "Important"
                               :tag "Important"
                               :priority "A"
                               :order 3)
                              (:name "Todo"
                               :todo "TODO"
                               :order 4)
                              (:name "Issues"
                               :tag "issue"
                               :order 12)
                              (:name "Waiting"
                               :todo "WAITING"
                               :order 20)
                              (:name "Trivial"
                               :priority<= "E"
                               :tag ("Trivial" "Unimportant")
                               :todo ("SOMEDAY" )
                               :order 90)
                              (:discard (:tag ("Chore" "Routine" "Daily")))
                              ))))
            (org-ql-block '(tags "idea")
                          ((org-ql-block-header "Ideas")
                           (org-super-agenda-groups
                            '(
                              (:name "Dev"
                               :tag ("idea" "dev")
                               )
                              (:name "General"
                               :tag ("idea" "general")
                               )
                              )
                            )))
            (org-ql-block '(tags "dev")
                          ((org-ql-block-header "Interesting in Dev")
                           (org-super-agenda-groups
                            '(
                              (:name "Repo"
                               :tag "repo"
                               :order 1)
                              (:name "Information"
                               :tag "info"
                               :order 3)
                              (:name "Article"
                               :tag "article"
                               :order 4)
                              (:name "Web"
                               :tag "web"
                               :order 5)
                              (:name "Video"
                               :tag "video"
                               :order 6)
                              (:name "Book"
                               :tag "book"
                               :order 7)
                              )
                            )))
            ))))
  )

(after! evil-org-agenda
  (setq org-super-agenda-header-map (copy-keymap evil-org-agenda-mode-map))
  (map!
   (:map org-agenda-keymap "j" #'evil-next-line)
   (:map org-agenda-mode-map "j" #'evil-next-line)
   (:map org-agenda-keymap "k" #'evil-previous-line)
   (:map org-agenda-mode-map "k" #'evil-previous-line)))
