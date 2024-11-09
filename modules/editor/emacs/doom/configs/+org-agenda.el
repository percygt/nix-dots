;;; +org-agenda.el -*- lexical-binding: t; -*-
(require 'org)
(require 'org-agenda)
(require 'org-super-agenda)
(org-super-agenda-mode +1)
(setq org-agenda-todo-ignore-states '("SOMEDAY" "CANCELLED"))

(setq org-habit-show-habits-only-for-today t)
(setq org-agenda-include-deadlines t)
(setq org-agenda-inhibit-startup t)
(setq org-agenda-dim-blocked-tasks "invisible")
(setq org-agenda-span 14)
(map! :map org-agenda-keymap "j" #'org-agenda-next-line)
(map! :map org-agenda-mode-map "j" #'org-agenda-next-line)
(map! :map org-super-agenda-header-map "j" #'org-agenda-next-line)
(map! :map org-agenda-keymap "k" #'org-agenda-previous-line)
(map! :map org-agenda-mode-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(setq org-agenda-custom-commands '(
                                   ("r" "Main View"
                                    ((agenda "" ((org-agenda-span 'day)
                                                 (org-agenda-start-day "+0d")
                                                 (org-agenda-overriding-header "")
                                                 (org-super-agenda-groups
                                                  '(
                                                    (:name "Past Habits"
                                                     :tag "habit"
                                                     :scheduled past)
                                                    (:name "Leftover Habits"
                                                     :tag "habit")
                                                    (:name "Today"
                                                     :time-grid t
                                                     :date today
                                                     :scheduled today)))))
                                     (alltodo "" ((org-agenda-overriding-header "")
                                                  (org-super-agenda-groups
                                                   '(
                                                     (:todo "NEXT")
                                                     (:todo "WAIT")
                                                     (:name "Important" :priority "A")
                                                     (:name "Todos" :and (:todo "TODO" :deadline nil :scheduled nil))
                                                     (:name "Deadlines" :and (:todo "TODO" :deadline t))
                                                     (:discard (:habit))
                                                     (:discard (:todo "TODO"))
                                                     (:discard (:todo "IDEA"))
                                                     (:discard (:todo "SOMEDAY"))
                                                     )))))
                                    )

                                   ("w" "Someday and Idea"
                                    ((alltodo "" ((org-agenda-overriding-header "")
                                                  (org-super-agenda-groups
                                                   '(
                                                     (:todo "IDEA")
                                                     (:todo "SOMEDAY")
                                                     (:discard (:not "IDEA"))
                                                     )
                                                   )))))

                                   ("R" "Today's" ((agenda "" ((org-agenda-span 'day)
                                                               (org-agenda-start-day "+0d")
                                                               (org-agenda-overriding-header "")
                                                               (org-super-agenda-groups
                                                                '((:name "Today"
                                                                   :date today
                                                                   :scheduled today
                                                                   :todo "TODAY"
                                                                   :discard (:not (:deadline today))))))))
                                    nil (concat org-file-path "phone_folder/Tasker/today.txt"))
                                   ))
