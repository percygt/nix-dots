;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)
  (defun +org-capture/replace-brackets (link)
    (mapconcat
     (lambda (c)
       (pcase (key-description (vector c))
         ("[" "(")
         ("]" ")")
         (_ (key-description (vector c)))))
     link))

  (defun +org-capture/www-get-page-title (url)
    (let ((title))
      (with-current-buffer (url-retrieve-synchronously url)
        (goto-char (point-min))
        (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
        (setq title (match-string 1))
        (goto-char (point-min))
        (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
        (decode-coding-string title (intern (match-string 1))))))

  ;;; from: https://abelstern.nl/posts/emacs-quick-capture/
  (defun +org-capture/quick-capture ()
    (defun +org-capture/place-template-dont-delete-windows (oldfun args)
      (cl-letf (((symbol-function 'org-switch-to-buffer-other-window) 'switch-to-buffer))
        (apply oldfun args)))
    (defun +org-capture/delete-frame-after-capture ()
      (delete-frame)
      (remove-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
      )
    (set-frame-name "emacs org capture")
    (add-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
    (+org-capture/place-template-dont-delete-windows 'org-capture nil))

  (setq org-tag-alist '(("dev"            . ?d)
                        ("quick"          . ?q)

                        (:startgroup      . nil)
                        ("email"          . ?m)
                        ("parents"        . ?p)
                        ("errands"        . ?e)
                        ("watch"          . ?w)
                        ("read"           . ?r)
                        ("idea"           . ?i)
                        (:endgroup        . nil)

                        (:startgroup      . nil)
                        ("youtube"        . ?y)
                        ("video"          . ?v)
                        ("article"        . ?t)
                        ("web"            . ?n)
                        ("repo"           . ?g)
                        ("book"           . ?b)
                        (:endgroup        . nil)

                        (:startgrouptag   . nil)
                        ("watch")
                        (:grouptags)
                        ("video")
                        ("youtube")
                        (:endgrouptag     . nil)

                        (:startgrouptag   . nil)
                        ("read")
                        (:grouptags)
                        ("article")
                        ("repo")
                        ("web")
                        ("book")
                        (:endgrouptag     . nil)))

  (add-hook! 'org-capture-after-finalize-hook (delete-frame))
  (setq org-capture-templates
        (doct `(
                ("Tasks" :keys "t"
                 :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
                 :file +org-capture-todo-file
                 :headline "Tasks"
                 :type entry
                 :prepend t
                 :hook +org-capture/created-property
                 :prepare-finalize (lambda ()
                                     (progn (org-priority)
                                            (org-set-tags-command)))
                 :template ("* TODO %? "
                            "%{extra}")
                 :children (("Default" :keys "t"
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow")
                             :extra  "")
                            ("Url" :keys "u"
                             :icon ("nf-md-web" :set "mdicon" :color "blue")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]")
                            ("Clipboard paste" :keys "c"
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan")
                             :extra "%a")
                            ("Linked Task" :keys "l"
                             :icon ("nf-fa-link" :set "faicon" :color "magenta")
                             :extra "%i %a")
                            ("Task with deadline" :keys "d"
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1)
                             :extra "DEADLINE: %^{Deadline:}t")
                            ("Scheduled Task" :keys "s"
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange")
                             :extra "SCHEDULED: %^{Start time:}t")))

                ("Interesting" :keys "i"
                 :icon ("nf-fa-eye" :set "faicon" :color "cyan")
                 :file +org-capture-notes-file
                 :prepend t
                 :type entry
                 :template ("* %{i-type}:"
                            "** %? :%{i-type}:"
                            "%{extra}"
                            ":PROPERTIES:"
                            ":CREATED: %U"
                            ":END:")
                 :children (("Webpage" :keys "w"
                             :icon ("nf-fa-globe" :set "faicon" :color "green")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :i-type "read:web:%^{Type|dev|general}")
                            ("Video" :keys "v"
                             :icon ("nf-oct-video" :set "octicon" :color "red")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :i-type "watch:video:%^{Type|dev|general}")
                            ("Repo" :keys "r"
                             :icon ("nf-fa-git" :set "faicon" :color "orange")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :i-type "repo:dev")
                            ("Article" :keys "a"
                             :icon ("nf-fa-file_text_o" :set "faicon" :color "yellow")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :i-type "read:article:%^{Type|dev|general}")
                            ("Book" :keys "b"
                             :icon ("nf-fa-book" :set "faicon" :color "green")
                             :extra "%i %a"
                             :i-type "read:book:%^{Type|dev|general}")
                            ("Information" :keys "i"
                             :icon ("nf-fa-info_circle" :set "faicon" :color "blue")
                             :extra "%a"
                             :i-type "read:info:%^{Type|dev|general}")
                            ("Idea" :keys "I"
                             :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                             :extra ""
                             :i-type "idea:%^{Type|dev|general}")))

                )))
  )
