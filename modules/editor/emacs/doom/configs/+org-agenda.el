(use-package! org-super-agenda
  :commands org-super-agenda-mode
  :init
  (let ((inhibit-message t))
    (org-super-agenda-mode))
  )
(use-package org-ql)
(setq org-agenda-deadline-faces
      '((1.001 . error)
        (1.0 . org-warning)
        (0.5 . org-upcoming-deadline)
        (0.0 . org-upcoming-distant-deadline)))

(setq org-agenda-start-with-log-mode t
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-dim-blocked-tasks 'invisible
      org-agenda-start-on-weekday nil
      org-agenda-prefix-format '((agenda . " %-12:T%?-12t% s")
                                 (todo . " %i %-12:c")
                                 (tags . " %i %-12:c")
                                 (search . " %i %-12:c"))
      org-agenda-timegrid-use-ampm t
      org-agenda-window-setup 'only-window
      org-agenda-restore-windows-after-quit t
      org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: ")
      org-agenda-block-separator ?-)

(map! :map org-agenda-keymap "j" #'org-agenda-next-line)
(map! :map org-agenda-mode-map "j" #'org-agenda-next-line)
(map! :map org-super-agenda-header-map "j" #'org-agenda-next-line)
(map! :map org-agenda-keymap "k" #'org-agenda-previous-line)
(map! :map org-agenda-mode-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)

(defvar jib-org-columbia-productivity-ql-query
  '(tags "read"))

(setq org-agenda-custom-commands
      '(
        ("m" "Main"
         (
          (agenda "" ((org-agenda-span 'day)
                      (org-agenda-sorting-strategy '(scheduled-up deadline-up priority-down))
                      (org-super-agenda-groups '(
                                                 (:name "Today"
                                                  :scheduled t
                                                  :order 2)
                                                 (:name "Due Soon"
                                                  :deadline future
                                                  :order 3)
                                                 (:name "Today's Schedule:"
                                                  :time-grid t
                                                  :discard (:deadline t)
                                                  :order 4)))))

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
          (org-ql-block '(tags "interest")
                        ((org-ql-block-header "Interesting")
                         (org-super-agenda-groups
                          '(
                            (:name "Read"
                             :tag "read"
                             :order 1)
                            (:name "Idea"
                             :tag "idea"
                             :order 2)
                            )
                          )))
          ))))
