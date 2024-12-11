;;; +org-journal.el -*- lexical-binding: t; -*-
(after! org-journal
  (setq org-journal-find-file #'find-file-other-window)

  (map! :leader :desc "Open today's journal" "j" #'org-journal-open-current-journal-file))
