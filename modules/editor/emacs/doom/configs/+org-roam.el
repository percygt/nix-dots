;;; +org-roam.el -*- lexical-binding: t; -*-
(setq org-roam-directory org-directory
      org-roam-db-location (file-name-concat org-directory ".org-roam.db")
      org-roam-dailies-directory "journal/")

(setq org-roam-node-display-template
      "${title:65}📝${tags:*}")


(load! "+org-roam-capture.el")
