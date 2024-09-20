;;; agenda-cfg.el --- Agenda -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package org-agenda
  :ensure nil
  :custom
  (org-time-stamp-custom-formats '("<%A, %B %d, %Y" . "<%m/%d/%y %a %I:%M %p>"))
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-window-setup 'current-window)
  ;; Only show upcoming deadlines for the next X days. By default it shows
  ;; 14 days into the future, which seems excessive.
  (org-deadline-warning-days 3)
  ;; If something is done, don't show its deadline
  (org-agenda-skip-deadline-if-done t)
  ;; If something is done, don't show when it's scheduled for
  (org-agenda-skip-scheduled-if-done t)
  ;; If something is scheduled, don't tell me it is due soon
  (org-agenda-skip-deadline-prewarning-if-scheduled t)
  ;; use AM-PM and not 24-hour time
  (org-agenda-timegrid-use-ampm t)
  ;; A new day is 3am (I work late into the night)
  ;; (setq org-extend-today-until 3)
  ;; (setq org-agenda-time-grid '((daily today require-timed)
  ;;                              (1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200)
  ;;                              "        " "----------------"))
  (org-agenda-time-grid nil)
  ;; (setq org-agenda-span 'day)
  (org-agenda-block-separator ?-)
  ;; (setq org-agenda-current-time-string "<----------------- Now")
  ;; ;; (setq org-agenda-block-separator nil)
  ;; (setq org-agenda-scheduled-leaders '("Plan | " "Sched.%2dx: ") ; ⇛
  ;;       org-agenda-deadline-leaders '("Due: " "(in %1d d.) " "Due %1d d. ago: "))
  ;; (setq org-agenda-prefix-format '((agenda . "  %-6:T %t%s")
  ;;                                  (todo . "  %-6:T %t%s")
  ;;                                  (tags . " %i %-12:c")
  ;;                                  (search . " %i %-12:c")))

  (org-agenda-prefix-format '((agenda . " %-12:T%?-12t% s")
                              (todo . " %i %-12:c")
                              (tags . " %i %-12:c")
                              (search . " %i %-12:c")))

  (org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: "))
  (org-agenda-files '(notes-directory)))

(use-package org-super-agenda
  :after org
  :config
  (setq org-super-agenda-header-map nil) ;; takes over 'j'
  ;; (setq org-super-agenda-header-prefix " ◦ ") ;; There are some unicode "THIN SPACE"s after the ◦
  ;; Hide the thin width char glyph. This is dramatic but lets me not be annoyed
  (add-hook 'org-agenda-mode-hook
            #'(lambda () (setq-local nobreak-char-display nil)))
  (org-super-agenda-mode))

(provide 'agenda-cfg)
;;; agenda-cfg.el ends here