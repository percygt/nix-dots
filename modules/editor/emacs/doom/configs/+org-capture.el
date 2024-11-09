;;; +org-capture.el -*- lexical-binding: t; -*-
(require 'org)

(map! :leader
      "t" #'org-capture-task
      "q" #'org-capture-quick-paste
      )

(defun org-capture-task ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "it"))

(defun org-capture-quick-paste ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "rq"))

(setq org-capture-templates
      `(
        ("i" "Inbox")
        ("it" "Task" entry  (file "Inbox.org")
         "* TODO %?\n")
        ("ip" "org-protocol" entry (file "Inbox.org")
         "* TODO Review %c\n%U\n" :immediate-finish t)

        ("m" "Meeting" entry  (file+headline "Agenda.org" "Future")
         ,(concat "* %? :meeting:\n"
                  "<%<%Y-%m-%d %a %H:00>>"))

        ("r" "Refile")
        ("rq" "Quick Paste" entry
         (file+headline "Stash.org" "Stash")
         "** NOTE %(simpleclip-get-contents)"
         :empty-lines-after 1
         ;; :immediate-finish t
         )
        ("rs" "Default" entry
         (file+headline "Stash.org" "Stash")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?"
         :empty-lines-after 1
         )
        ("rc" "Paste Clipboard" entry
         (file+headline "Stash.org" "Stash")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n%(simpleclip-get-contents)"
         :empty-lines-after 1
         )
        ("rl" "Create link and fetch title" entry
         (file+headline "Stash.org" "Stash")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n[[%(simpleclip-get-contents)][%(p67/www-get-page-title (simpleclip-get-contents))]]"
         :empty-lines-after 1
         )
        ))

(add-hook 'org-capture-mode-hook 'delete-other-windows)
