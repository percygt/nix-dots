;;; +org-capture.el -*- lexical-binding: t; -*-
(after! org
  (setq org-capture-templates
        '(

          ("tt" "Todo Task" entry
           (file+headline "Inbox.org" "Tasks")
           "** %^{Type|HW|READ|TODO|PROJ} %^{Todo title} %?"
           :prepend t
           :empty-lines-before 0
           :tree-type week
           :clock-in t
           :clock-resume t))
        ("t" "Tasks" entry
         (file+headline "" "Inbox")
         "* TODO %?\n %U")
        ("c" "Phone Call" entry
         (file+headline "" "Inbox")
         "* TODO Call %?\n %U")
        ("m" "Meeting" entry
         (file+headline "" "Meetings")
         "* %?\n %U")
        ("j" "Journal Entry" entry
         (file+datetree "journal.org")
         "* %U\n%?")))
(setq org-capture-templates
      '(
        ("n" "CPB Note" entry (file+headline "Inbox.org" "Refile")
         "** NOTE: %? @ %U"        :empty-lines 0 :refile-targets (("Inbox.org" :maxlevel . 8)))

        ("i" "CPB Idea" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
         "** IDEA: %? @ %U :idea:" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))

        ("m" "CPB Note Clipboard")

        ("mm" "Paste clipboard" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
         "** NOTE: %(simpleclip-get-contents) %? @ %U" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))

        ("ml" "Create link and fetch title" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
         "** [[%(simpleclip-get-contents)][%(jib/www-get-page-title (simpleclip-get-contents))]] @ %U" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))

        ("w" "Work Todo Entries")
        ("we" "No Time" entry (file "~/Dropbox/org/work.org")
         "** %^{Type|HW|READ|TODO|PROJ} %^{Todo title} %?" :prepend t :empty-lines-before 0
         :refile-targets (("~/Dropbox/org/work.org" :maxlevel . 2)))

        ("ws" "Scheduled" entry (file "~/Dropbox/org/work.org")
         "** %^{Type|HW|READ|TODO|PROJ} %^{Todo title}\nSCHEDULED: %^t%?" :prepend t :empty-lines-before 0
         :refile-targets (("~/Dropbox/org/work.org" :maxlevel . 2)))

        ("wd" "Deadline" entry (file "~/Dropbox/org/work.org")
         "** %^{Type|HW|READ|TODO|PROJ} %^{Todo title}\nDEADLINE: %^t%?" :prepend t :empty-lines-before 0
         :refile-targets (("~/Dropbox/org/work.org" :maxlevel . 2)))

        ("ww" "Scheduled & deadline" entry (file "~/Dropbox/org/work.org")
         "** %^{Type|HW|READ|TODO|PROJ} %^{Todo title}\nSCHEDULED: %^t DEADLINE: %^t %?" :prepend t :empty-lines-before 0
         :refile-targets (("~/Dropbox/org/work.org" :maxlevel . 2)))

        ("t" "Temp file entry" entry (file "~/Dropbox/.tmp.org")
         "** %^{Heading} @ %u \n%?" :prepend t)

        ))
)
