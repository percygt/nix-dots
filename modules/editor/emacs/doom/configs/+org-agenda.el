(use-package! org-super-agenda
  :commands org-super-agenda-mode
  :init
  (let ((inhibit-message t))
    (org-super-agenda-mode))
  )

(setq org-agenda-start-with-log-mode t)
(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)
(setq org-agenda-prefix-format '((agenda . " %-12:T%?-12t% s")
                                 (todo . " %i %-12:c")
                                 (tags . " %i %-12:c")
                                 (search . " %i %-12:c")))

(setq org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: "))
(setq org-time-stamp-custom-formats '("<%A, %B %d, %Y" . "<%m/%d/%y %a %I:%M %p>"))
(setq org-agenda-block-separator ?-)
(setq org-agenda-time-grid nil)
(setq org-agenda-timegrid-use-ampm t)

(map! :map org-agenda-keymap "j" #'org-agenda-next-line)
(map! :map org-agenda-mode-map "j" #'org-agenda-next-line)
(map! :map org-super-agenda-header-map "j" #'org-agenda-next-line)
(map! :map org-agenda-keymap "k" #'org-agenda-previous-line)
(map! :map org-agenda-mode-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)
(map! :map org-super-agenda-header-map "k" #'org-agenda-previous-line)

(setq org-agenda-custom-commands
      '(("p" "Planning" tags "read")))
