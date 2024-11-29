;;; +org-capture.el -*- lexical-binding: t; -*-
(require 'org)

(map! :leader
      "t" #'+aiz-org-capture-task
      "q" #'+aiz-org-capture-quick-paste
      )

(defun +aiz-www-get-page-title (url)
  (let ((title))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char (point-min))
      (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
      (setq title (match-string 1))
      (goto-char (point-min))
      (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
      (decode-coding-string title (intern (match-string 1))))))

(defun +aiz-org-capture-task ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "it"))

(defun +aiz-org-capture-quick-paste ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "rq"))

(add-hook 'org-timer-set-hook #'org-clock-in)
(setq org-capture-templates
      `(
        ("t" "Task" entry  (file "Inbox.org")
         "* TODO %?\n %U\n  %a\n  %i"
         :empty-lines-after 1)
        ("s" "Clocked Entry Subtask" entry (clock)
         "* TODO %?\n  %U\n  %a\n  %i"
         :empty-lines 1)
        ("j" "Journal Entries")
        ("je" "General Entry" entry
         (file+olp+datetree (file "Journal.org"))
         "\n* %<%I:%M %p> - %^{Title} \n\n%?\n\n"
         :tree-type week
         :clock-in :clock-resume
         :empty-lines 1)
        ("jt" "Task Entry" entry
         (file+olp+datetree (file "Journal.org"))
         "\n* %<%I:%M %p> - Task Notes: %a\n\n%?\n\n"
         :tree-type week
         :clock-in :clock-resume
         :empty-lines 1)
        ("jj" "Journal" entry
         (file+olp+datetree (file "Journal.org"))
         "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         :tree-type week
         :clock-in :clock-resume
         :empty-lines 1)        ("q" "Quick Paste" entry
         (file+headline "Refile.org" "Refile")
         "** NOTE %(simpleclip-get-contents)"
         :empty-lines-after 1
         ;; :immediate-finish t
         )
        ("s" "Stash" entry
         (file+headline "Refile.org" "Refile")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?"
         :empty-lines-after 1
         )
        ("c" "Paste Clipboard" entry
         (file+headline "Refile.org" "Refile")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n%(simpleclip-get-contents)"
         :empty-lines-after 1
         )
        ("l" "Create link and fetch title" entry
         (file+headline "Refile.org" "Refile")
         "** %^{Type|IDEA|NOTE|STUDY|READ|WORK|PROJECT|PEOPLE} %?\n[[%(simpleclip-get-contents)][%(+aiz-www-get-page-title (simpleclip-get-contents))]]"
         :empty-lines-after 1
         )
        ))

(add-hook 'org-capture-mode-hook 'delete-other-windows)
