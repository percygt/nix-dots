;;; +org-agenda.el -*- lexical-binding: t; -*-
(require 'org)
(require 'org-agenda)
(require 'org-ql)
(require 'org-super-agenda)
(org-super-agenda-mode +1)
(setq org-tag-alist
      '(;; Places
        ("@home" . ?H)
        ("@work" . ?W)

        ;; Devices
        ("@computer" . ?C)
        ("@phone" . ?P)

        ;; Activities
        ("@note" . ?n)
        ("@study" . ?s)
        ("@read" . ?r)
        ("@project" . ?p)
        ("@people" . ?P)
        ("@email" . ?e)
        ("@calls" . ?c)
        ("@errands" . ?r)))
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
        )
      )

(setq org-log-done 'time)
(setq org-agenda-start-with-log-mode t)
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



(setq org-agenda-custom-commands
      '(("p" "Planning"
         ((tags-todo "+@planning"
                     ((org-agenda-overriding-header "Planning Tasks")))
          (tags-todo "-{.*}"
                     ((org-agenda-overriding-header "Untagged Tasks")))
          (todo ".*" ((org-agenda-files (file-name-concat org-directory "/Inbox.org"))
                      (org-agenda-overriding-header "Unprocessed Inbox Items")))))

        ("d" "Daily Agenda"
         ((agenda "" ((org-agenda-span 'day)
                      (org-deadline-warning-days 7)))
          (tags-todo "+PRIORITY=\"A\""
                     ((org-agenda-overriding-header "High Priority Tasks")))))

        ("w" "Weekly Review"
         ((agenda ""
                  ((org-agenda-overriding-header "Completed Tasks")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo 'done))
                   (org-agenda-span 'week)))

          (agenda ""
                  ((org-agenda-overriding-header "Unfinished Scheduled Tasks")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-span 'week)))))))
