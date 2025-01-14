;;; +org-roam.el -*- lexical-binding: t; -*-
(after! org-roam
  (setq org-roam-directory org-directory
        org-roam-db-location (file-name-concat org-directory ".org-roam.db")
        org-roam-dailies-directory "journal/"
        org-roam-node-display-template "${title:65}📝${tags:*}"
        org-roam-completion-system 'default)
  )
