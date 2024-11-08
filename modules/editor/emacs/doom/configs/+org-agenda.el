;;; +org-agenda.el -*- lexical-binding: t; -*-
(require 'org)
(require 'org-agenda)
(use-package! org-super-agenda
  :after org
  :config
  (setq org-super-agenda-header-map nil) ;; takes over 'j'
  ;; (setq org-super-agenda-header-prefix " ◦ ") ;; There are some unicode "THIN SPACE"s after the ◦
  ;; Hide the thin width char glyph. This is dramatic but lets me not be annoyed
  (add-hook 'org-agenda-mode-hook
            #'(lambda () (setq-local nobreak-char-display nil)))
  (org-super-agenda-mode))

(setq org-agenda-files (list org-directory))
(setq org-agenda-todo-ignore-states '("SOMEDAY" "CANCELLED"))


;; custom time stamp format. I don't use this.
(setq org-time-stamp-custom-formats '("<%A, %B %d, %Y" . "<%m/%d/%y %a %I:%M %p>"))

(setq org-agenda-restore-windows-after-quit t)

(setq org-agenda-window-setup 'current-window)

;; Only show upcoming deadlines for the next X days. By default it shows
;; 14 days into the future, which seems excessive.
(setq org-deadline-warning-days 3)
;; If something is done, don't show its deadline
(setq org-agenda-skip-deadline-if-done t)
;; If something is done, don't show when it's scheduled for
(setq org-agenda-skip-scheduled-if-done t)
;; If something is scheduled, don't tell me it is due soon
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)

;; use AM-PM and not 24-hour time
(setq org-agenda-timegrid-use-ampm t)

;; A new day is 3am (I work late into the night)
;; (setq org-extend-today-until 3)

;; (setq org-agenda-time-grid '((daily today require-timed)
;;                              (1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200)
;;                              "        " "----------------"))

(setq org-agenda-time-grid nil)

;; (setq org-agenda-span 'day)

(setq org-agenda-block-separator ?-)
;; (setq org-agenda-current-time-string "<----------------- Now")

;; ;; (setq org-agenda-block-separator nil)

;; (setq org-agenda-scheduled-leaders '("Plan | " "Sched.%2dx: ") ; ⇛
;;       org-agenda-deadline-leaders '("Due: " "(in %1d d.) " "Due %1d d. ago: "))

;; (setq org-agenda-prefix-format '((agenda . "  %-6:T %t%s")
;;                                  (todo . "  %-6:T %t%s")
;;                                  (tags . " %i %-12:c")
;;                                  (search . " %i %-12:c")))

;;;;; more true to defaults

(setq org-agenda-prefix-format '((agenda . " %-12:T%?-12t% s")
                                 (todo . " %i %-12:c")
                                 (tags . " %i %-12:c")
                                 (search . " %i %-12:c")))

(setq org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: "))

(add-hook 'org-agenda-mode-hook
          #'(lambda () (setq-local line-spacing 3)))

(add-hook 'org-agenda-mode-hook
          #'(lambda () (hide-mode-line-mode)))
(setq org-agenda-custom-commands nil)

;; (setq org-agenda-hide-tags-regexp "\\(ec\\|lit\\|sci\\|edu\\|ds\\|calc3\\)")

(defvar jib-org-agenda-columbia-productivity-super-groups
  '((:name "Personal Items" :tag "p" :order 10)
    (:name "Extracurricular" :tag "ec" :order 5)
    (:name "Todo" :todo ("TODO") :order 3)
    (:name "Heads Up!"
     :todo ("PROJ" "WORK" "STUDY") :tag "lt" :order 4)
    (:discard (:todo t))))

(defvar jib-org-columbia-productivity-ql-query
  '(and (not (tags "defer"))
        (not (scheduled)) ;; rationale --- if it's scheduled I don't need the heads-up
        (or (effort 1)
            (todo "TODO" "PROJ" "STUDY")
            (and (todo)
                 (tags "p" "ec" "lt")))))

;; Day View
(add-to-list 'org-agenda-custom-commands
             '("c" "Columbia Day View"
               ((agenda "" ((org-agenda-overriding-header "Columbia Productivity View")
                            (org-agenda-span 'day)
                            (org-agenda-sorting-strategy '(scheduled-up deadline-up priority-down))
                            (org-super-agenda-groups '(
                                                       (:name "Today:"
                                                        :scheduled t
                                                        :order 2)
                                                       (:name "Deadlines:"
                                                        :deadline t
                                                        :order 3)
                                                       (:name "Today's Schedule:"
                                                        :time-grid t
                                                        :discard (:deadline t)
                                                        :order 1)))))

                (org-ql-block jib-org-columbia-productivity-ql-query
                              ((org-ql-block-header "Productivity Overview:")
                               (org-super-agenda-groups jib-org-agenda-columbia-productivity-super-groups))))))

;; Day View No Agenda
(add-to-list 'org-agenda-custom-commands
             '("v" "Columbia Day View No Agenda"
               ((org-ql-block '(todo)
                              ((org-super-agenda-groups (push '(:name "Today's Tasks" ;; jib-org-super-agenda-school-groups, with this added on
                                                                :scheduled today
                                                                :deadline today) jib-org-agenda-columbia-productivity-super-groups)

                                                        ;; '((:name "Today's Tasks"
                                                        ;;                                  :scheduled today
                                                        ;;                                  :deadline today)
                                                        ;;                           (:discard (:tag "defer"))
                                                        ;;                           (:name "Extracurricular:"
                                                        ;;                                  :tag "ec"
                                                        ;;                                  :order 10)
                                                        ;;                           (:name "Personal:"
                                                        ;;                                  :tag "p"
                                                        ;;                                  :order 5)
                                                        ;;                           (:name "Projects"
                                                        ;;                                  :todo ("STUDY" "PROJ")
                                                        ;;                                  :tag "lt")
                                                        ;;                           (:discard (:todo t)))
                                                        ))))))

;; Three-day view
(add-to-list 'org-agenda-custom-commands
             '("w" "Columbia Four-Day View"
               ((agenda "" ((org-agenda-span 4)
                            (org-agenda-entry-types '(:deadline :scheduled))
                            (org-agenda-start-on-weekday nil)
                            (org-deadline-warning-days 0)))

                (org-ql-block jib-org-columbia-productivity-ql-query
                              ((org-ql-block-header "Productivity Overview:")
                               (org-super-agenda-groups jib-org-agenda-columbia-productivity-super-groups))))))

;; Six-day view
(add-to-list 'org-agenda-custom-commands
             '("q" "Columbia Ten-Day View"
               ((agenda "" ((org-agenda-span 10)
                            (org-agenda-entry-types '(:deadline :scheduled))
                            (org-agenda-start-on-weekday nil)
                            (org-deadline-warning-days 0))))))
;; ;; Setup org-agenda for that jawn
;; ;; Agenda
;; (setq org-agenda-custom-commands
;;       '(("g" "Get Things Done (GTD)"
;;          ((agenda ""
;;                   ((org-agenda-skip-function
;;                     '(org-agenda-skip-entry-if 'deadline))
;;                    (org-deadline-warning-days 0)))
;;           (todo "NEXT"
;;                 ((org-agenda-skip-function
;;                   '(org-agenda-skip-entry-if 'deadline))
;;                  (org-agenda-prefix-format "  %i %-12:c [%e] ")
;;                  (org-agenda-overriding-header "\nTasks\n")))
;;           (agenda nil
;;                   ((org-agenda-entry-types '(:deadline))
;;                    (org-agenda-format-date "")
;;                    (org-deadline-warning-days 7)
;;                    (org-agenda-skip-function
;;                     '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
;;                    (org-agenda-overriding-header "\nDeadlines")))
;;           (tags-todo "inbox"
;;                      ((org-agenda-prefix-format "  %?-12t% s")
;;                       (org-agenda-overriding-header "\nInbox\n")))
;;           (tags "CLOSED>=\"<today>\""
;;                 ((org-agenda-overriding-header "\nCompleted today\n")))))))
