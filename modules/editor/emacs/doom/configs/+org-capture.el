;;; +org-capture.el -*- lexical-binding: t; -*-
(add-to-list 'org-capture-templates
             '("e" "Emacs Config Notes"
               entry
               (file+headline "emacs.org" "Notes")
               "* %u %?\n %i\n %a"
               :prepend t :kill-buffer t))
(add-to-list 'org-capture-templates
             '("w" "Work Templates"))
(add-to-list 'org-capture-templates
             '("wn" "Notes"
               entry
               (file "refile.org")
               "* %? :NOTE:\n%U"
               :prepend t :kill-buffer t))
(add-to-list 'org-capture-templates
             '("wt" "Todo"
               entry  ; type
               (file "refile.org") ; target
               "* TODO %?\n%U" ; template
               :prepend t :kill-buffer t)) ; properties
;; (setq org-capture-templates
;;       `(
;;         ("t" "Task" entry  (file "Inbox.org")
;;          "* TODO %?\n %U\n  %a\n  %i"
;;          :empty-lines-after 1)
;;         ("s" "Clocked Entry Subtask" entry (clock)
;;          "* TODO %?\n  %U\n  %a\n  %i"
;;          :empty-lines 1)
;;         ("j" "Journal Entries")
;;         ("je" "General Entry" entry
;;          (file+olp+datetree (file "Journal.org"))
;;          "\n* %<%I:%M %p> - %^{Title} \n\n%?\n\n"
;;          :tree-type week
;;          :clock-in :clock-resume
;;          :empty-lines 1)
;;         ("jt" "Task Entry" entry
;;          (file+olp+datetree (file "Journal.org"))
;;          "\n* %<%I:%M %p> - Task Notes: %a\n\n%?\n\n"
;;          :tree-type week
;;          :clock-in :clock-resume
;;          :empty-lines 1)
;;         ("jj" "Journal" entry
;;          (file+olp+datetree (file "Journal.org"))
;;          "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
;;          :tree-type week
;;          :clock-in :clock-resume
;;          :empty-lines 1)        ("q" "Quick Paste" entry
;;          (file+headline "Refile.org" "Refile")
;;          "** NOTE %(simpleclip-get-contents)"
;;          :empty-lines-after 1
;;          ;; :immediate-finish t
;;          )
;;         ("s" "Stash" entry
;;          (file+headline "Refile.org" "Refile")
;;          "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?"
;;          :empty-lines-after 1
;;          )
;;         ("c" "Paste Clipboard" entry
;;          (file+headline "Refile.org" "Refile")
;;          "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n%(simpleclip-get-contents)"
;;          :empty-lines-after 1
;;          )
;;         ("l" "Create link and fetch title" entry
;;          (file+headline "Refile.org" "Refile")
;;          "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n[[%(simpleclip-get-contents)][%(+aiz-www-get-page-title (simpleclip-get-contents))]]"
;;          :empty-lines-after 1
;;          )
;;         ))

(add-hook 'org-capture-mode-hook 'delete-other-windows)
