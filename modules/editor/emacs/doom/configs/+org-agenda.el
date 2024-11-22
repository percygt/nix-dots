;;; +org-agenda.el -*- lexical-binding: t; -*-
(require 'org)
(require 'org-agenda)
(require 'org-ql)
(require 'org-super-agenda)
(org-super-agenda-mode +1)

(setq org-todo-keywords
      '(
        (sequence
         "TODO(t)" ; doing later
         "NEXT(n!)" ; doing now or soon
         "|"
         "DONE(d!)" ; done
         )
        (sequence
         "WAIT(w@/!)" ; waiting for some external change (event)
         "HOLD(h@/!)" ; waiting for some internal change (of mind)
         "|"
         "KILL(C@/!)"
         )
        (type
         "IDEA(i)" ; maybe someday
         "NOTE(N)"
         "STUDY(s)"
         "READ(r)"
         "WORK(w)"
         "PROJECT(p)"
         "PEOPLE(h)"
         "|"
         )
        )
      )

(setq org-agenda-todo-ignore-states '("SOMEDAY" "CANCELLED"))
(setq org-habit-show-habits-only-for-today t)
(setq org-agenda-include-deadlines t)
(setq org-agenda-inhibit-startup t)
(setq org-agenda-dim-blocked-tasks "invisible")
(setq org-agenda-span 14)
(setq org-agenda-timegrid-use-ampm t)
(setq org-deadline-warning-days 3)
(setq org-agenda-skip-deadline-if-done t)
;; If something is done, don't show when it's scheduled for
(setq org-agenda-skip-scheduled-if-done t)
;; If something is scheduled, don't tell me it is due soon
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-time-grid nil)
(setq org-agenda-block-separator ?-)
;; custom time stamp format. I don't use this.
(setq org-time-stamp-custom-formats '("<%A, %B %d, %Y" . "<%m/%d/%y %a %I:%M %p>"))
(setq org-agenda-start-with-log-mode t)
(setq org-agenda-log-mode-items '(closed clock state))
(setq org-agenda-restore-windows-after-quit t)

(setq org-agenda-window-setup 'current-window)
(map! :map org-agenda-keymap "j" #'org-agenda-next-line)
(map! :map org-agenda-mode-map "j" #'org-agenda-next-line)
(map! :map org-super-agenda-header-map "j" #'org-agenda-next-line)
(map! :map org-agenda-keymap "k" #'org-agenda-previous-line)
(map! :map org-agenda-mode-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)

(defvar +aiz-org-ql-query
  '(property "ACTIVATED"))
(defvar +aiz-org-agenda-super-groups
  '(:name "Personal Items" :property "ACTIVATED"))
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
                                                    (:name "Today:"
                                                     :scheduled t
                                                     :order 2)
                                                    (:name "Deadlines:"
                                                     :deadline t
                                                     :order 3)
                                                    (:name "Today's Schedule:"
                                                     :time-grid t
                                                     :date today
                                                     :scheduled today)))))
                                     (org-ql-block '(or (todo "TODO"))
                                                   ((org-ql-block-header "SOMEDAY :Emacs: High-priority")
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
