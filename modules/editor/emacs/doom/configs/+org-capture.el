;;; +org-capture.el -*- lexical-binding: t; -*-
(after! org
  (setq org-capture-templates
        (quote (
                )))
  (setq org-capture-templates
        '(

          ;; ("t" "Task")
          ;; ("tp" "No Time" entry
          ;;  (file "Inbox.org")
          ;;  "** TODO %U"
          ;;  :empty-lines-after 1
          ;;  )
          ("t" "todo" entry (file "Refile.org")
           "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
          ("r" "respond" entry (file "Refile.org")
           "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
          ("n" "note" entry (file "Refile.org")
           "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
          ("j" "Journal" entry (file+datetree "Journal.org")
           "* %?\n%U\n" :clock-in t :clock-resume t)
          ("w" "org-protocol" entry (file "Refile.org")
           "* TODO Review %c\n%U\n" :immediate-finish t)
          ("m" "Meeting" entry (file "Refile.org")
           "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
          ("p" "Phone call" entry (file "Refile.org")
           "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
          ("h" "Habit" entry (file "Refile.org")
           "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
          ("s" "Stash Default" entry
           (file+headline "Inbox.org" "Stash")
           "** %^{Type|IDEA|STUDY|READ|WORK|PROJECT|PEOPLE} %U %?"
           :empty-lines-after 1
           )
          ("c" "Stash Clipboard")
          ("cp" "Paste Clipboard" entry
           (file+headline "Stash.org" "Stash")
           "** %^{Type|IDEA|STUDY|READ|WORK|PROJECT|PEOPLE} %U %?\n%(simpleclip-get-contents)"
           :empty-lines-after 1
           )
          ("cl" "Create link and fetch title" entry
           (file+headline "Stash.org" "Stash")
           "** %^{Type|IDEA|STUDY|READ|WORK|PROJECT|PEOPLE} %U %?\n[[%(simpleclip-get-contents)][%(p67/www-get-page-title (simpleclip-get-contents))]]"
           :empty-lines-after 1
           )
          )
        )
  )
