;;; +org-capture.el -*- lexical-binding: t; -*-
(defun +org-capture/replace-brackets (link)
  (mapconcat
   (lambda (c)
     (pcase (key-description (vector c))
       ("[" "(")
       ("]" ")")
       (_ (key-description (vector c)))))
   link))

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

(defun +aiz-on-org-capture ()
  ;; Don't show the confirmation header text
  (setq header-line-format nil)

  ;; Control how some buffers are handled
  (let ((template (org-capture-get :key t)))
    (pcase template
      ("jj" (delete-other-windows)))))

(setq org-capture-templates
      (doct `(
              ("Todo" :keys "t"
               :file "Home.org"
               :icon ("nf-fa-building" :set "faicon" :color "yellow")
               :headline "Home"
               :type entry
               :prepend t
               :children
               (
                ("Phone Call" :keys "p"
                 :template ("* TODO Phone call with %?"
                            "SCHEDULED: %^{Schedule:}t"
                            ))
                ("Meeting"    :keys "m"
                 :template ("* TODO Phone call with %?"
                            "SCHEDULED: %^{Schedule:}t"
                            ))
                ("Url"    :keys "u"
                 :template ("* TODO %? @ %U"
                            "[[%(simpleclip-get-contents)][%(+aiz-www-get-page-title (simpleclip-get-contents))]] @ %U"
                            ))
                ("Clipboard paste" :keys "c"
                 :template ("* TODO %? @ %U"
                            "%(simpleclip-get-contents)"
                            ))
                ("Todo Generic" :keys "t"
                 :template "* TODO %? @ %U")
                ("Link" :keys "l"
                 :template ("* TODO %? @ %U"
                            "%i %a"))))

              ;; ("Notes" :keys "n"
              ;;  :icon ("nf-fa-calendar" :set "faicon" :color "pink")
              ;;  :file "Notes.org"
              ;;  :function (lambda ()
              ;;              (org-journal-new-entry t)
              ;;              (unless (eq org-journal-file-type 'daily)
              ;;                (org-narrow-to-subtree))
              ;;              (goto-char (point-max)))
              ;;  :template "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
              ;;  :jump-to-captured t
              ;;  :immediate-finish t)

              ("Interesting" :keys "i"
               :icon ("nf-fa-eye" :set "faicon" :color "lcyan")
               :file "Inbox.org"
               :prepend t
               :headline "Interesting"
               :type entry
               :template ("* %? @ %U :%{i-type}:"
                          "%{desc}")
               :children (("Webpage" :keys "w"
                           :icon ("nf-fa-globe" :set "faicon" :color "green")
                           :desc "[[%(simpleclip-get-contents)][%(+aiz-www-get-page-title (simpleclip-get-contents))]]"
                           :i-type "read:web")
                          ("Article" :keys "a"
                           :icon ("nf-fa-file_text_o" :set "faicon" :color "yellow")
                           :desc "[[%(simpleclip-get-contents)][%(+aiz-www-get-page-title (simpleclip-get-contents))]]"
                           :i-type "read:reaserch")
                          ("Information" :keys "i"
                           :icon ("nf-fa-info_circle" :set "faicon" :color "blue")
                           :desc ""
                           :i-type "read:info")
                          ("Idea" :keys "I"
                           :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                           :desc ""
                           :i-type "idea")))
              ("Project" :keys "p"
               :icon ("nf-oct-repo" :set "octicon" :color "silver")
               :prepend t
               :type entry
               :headline "Inbox"
               :template ("* %{keyword} %?"
                          "%i"
                          "%a")
               :file ""
               :custom (:keyword "")
               :children (("Task" :keys "t"
                           :icon ("nf-cod-checklist" :set "codicon" :color "green")
                           :keyword "TODO"
                           :file +org-capture-project-todo-file)
                          ("Note" :keys "n"
                           :icon ("nf-fa-sticky_note" :set "faicon" :color "yellow")
                           :keyword "%U"
                           :file +org-capture-project-notes-file))))))

(add-hook 'org-capture-mode-hook 'delete-other-windows)
