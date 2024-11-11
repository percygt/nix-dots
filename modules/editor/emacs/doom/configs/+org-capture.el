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

(setq org-capture-templates
      `(
        ("t" "Task" entry  (file "Inbox.org")
         "* TODO %?\n"
         :empty-lines-after 1)
        ("r" "Review" entry (file "Inbox.org")
         "* TODO Review %c\n%U\n"
         :immediate-finish t
         :empty-lines-after 1)
        ("m" "Meeting" entry  (file+headline "Agenda.org" "Future")
         ,(concat "* %? :meeting:\n"
                  "SCHEDULED: <%<%Y-%m-%d %a %^{Time}>>")
         :empty-lines-after 1
         :time-prompt t
         )
        ("q" "Quick Paste" entry
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
