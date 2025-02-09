;;; +org-capture.el -*- lexical-binding: t; -*-

(after! org
  (require 'doct)
  (require 'org-protocol-capture-html)
  (defcustom org-capture/project-file (expand-file-name +org-capture-projects-file org-directory)
    "The path to the file in which project Note will be stored."
    :type '(string)
    )
  (defun +org-capture/templates-json ()
    "Extract an alist with doct-names as keys and capture keys as values from org-capture-templates and return it as JSON."
    (let (
          (keys-and-names '())
          )  ;; List to store the alist pairs
      (dolist (template org-capture-templates)
        (let* (
               (key (car template))  ;; Extract the capture key
               (name (replace-regexp-in-string "^[^\t]+\\\t" "" (car (cdr template))))
               (doct-entry (plist-get (cdr template) :doct))
               )
          (if (not doct-entry)
              (push `( ,key . (( name . ,name)( key . ,key))) keys-and-names)
            (let* (
                   (pkey (char-to-string (aref key 0)))
                   (entry (assoc pkey keys-and-names))
                   (value (assoc 'value entry))
                   )
              (if entry
                  (if value
                      (setf (cdr value) (setcdr value (append (cdr value) `((( name . ,name)( key . ,key))))))
                    (setf (cdr entry) (setcdr entry (append (cdr entry) `(( value . ((( name . ,name)( key . ,key))))))))
                    )
                ))
            )
          )
        )
      (json-encode keys-and-names)
      )
    )
  (defun +org-capture/created-property ()
    (org-set-property "CREATED" (format-time-string (org-time-stamp-format :long :inactive)))
    (insert " ")
    (insert " ")
    (backward-char)
    )

  (defun +org-capture/ensure-heading (args &optional initial-level)
    (if (not args)
        (widen)
      (let* (
             (initial-level (or initial-level 1))
             (headings (if (= initial-level 1) (cdr args) args))
             )
        (if (and (re-search-forward (format org-complex-heading-regexp-format
                                            (regexp-quote (car headings)))
                                    nil t)
                 (= (org-current-level) initial-level))
            (progn
              (beginning-of-line)
              (org-narrow-to-subtree))
          (goto-char (point-max))
          (unless (and (bolp) (eolp)) (insert "\n"))
          (insert (make-string initial-level ?*)
                  " " (car headings) "\n")
          (when (= initial-level 1)
            (org-set-property "CATEGORY" (car args)))
          (beginning-of-line 0))

        (+org-capture/ensure-heading (cdr headings) (1+ initial-level))
        )))

  (defun +org-capture/open-project (project-root)
    (if (require 'projectile nil 'noerror)
        (projectile-switch-project-by-name project-root)
      (project-switch-project project-root)
      )
    )
  (defun +org-capture/project-file ()
    (let* (
           (doct (org-capture-get :doct))
           (file (expand-file-name +org-capture-projects-file org-directory))
           (project-root
            (projectile-completing-read "Project: " (projectile-relevant-known-projects))
            )
           (project-name
            (file-name-nondirectory (directory-file-name project-root))
            )
           (project-link (org-link-make-string
                          (format "elisp:(+org-capture/open-project \"%s\")" project-root)
                          project-name))
           )
      (set-buffer (org-capture-target-buffer file))
      (org-capture-put-target-region-and-position)
      (widen)
      (goto-char (point-min))
      ;; Find or create the project headling
      (+org-capture/ensure-heading
       (append (org-capture-get :parents)
               (list project-name project-link
                     (if doct
                         (let ((heading (plist-get doct :heading))) heading)
                       (org-capture-get :heading)
                       )
                     )))
      ))

  (defun +org-capture/project-projectile()
    (progn
      (require 'org-project-capture)
      (let* ((category
              (org-projectile-completing-read
               "Select which project:"))
             (category-location
              (apply 'occ-get-category-heading-location '(category)))
             )
        (if category-location
            (progn
              (goto-char category-location)
              )
          (occ-insert-at-end-of-file)
          (org-set-property "CATEGORY" category)
          (insert (org-project-capture-build-heading category))
          )))
    )
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
                        ("url"            . ?u)

                        ("email"          . ?m)
                        ("parents"        . ?p)
                        ("errands"        . ?e)
                        ("watch"          . ?w)
                        ("read"           . ?r)
                        ("idea"           . ?i)

                        ("youtube"        . ?y)
                        ("video"          . ?v)
                        ("article"        . ?t)
                        ("web"            . ?n)
                        ("repo"           . ?g)
                        ("book"           . ?b)
                        ))

  (add-hook! 'org-capture-after-finalize-hook (delete-frame))

  (setq org-capture-templates
        (doct `(
                ("Default" :keys "d"
                 :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
                 :file +org-capture-todo-file
                 :headline "Tasks"
                 :type entry
                 :prepend t
                 :prepare-finalize (lambda () (progn (org-priority) (org-set-tags-command)))
                 :template ("* TODO %? " "%{extra}")
                 :children (("Task" :keys "d"
                             :extra  ""
                             :hook +org-capture/created-property
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                            ("Url" :keys "u"
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                             :icon ("nf-md-web" :set "mdicon" :color "blue"))
                            ("Clipboard paste" :keys "c"
                             :extra "%a"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                            ("Linked Task" :keys "l"
                             :extra "%i %a"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                            ("Task with deadline" :keys "d"
                             :extra "DEADLINE: %^{Deadline:}t"
                             :hook +org-capture/created-property
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1))
                            ("Scheduled Task" :keys "s"
                             :extra "SCHEDULED: %^{Start time:}t"
                             :hook +org-capture/created-property
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange"))))

                ("References" :keys "r"
                 :icon ("nf-fa-eye" :set "faicon" :color "cyan")
                 :file +org-capture-notes-file
                 :prepend t
                 :prepare-finalize (lambda () (org-set-tags-command))
                 :type entry
                 :template ("* %?" "%{extra}")
                 :children (("Webpage Url" :keys "w"
                             :icon ("nf-fa-globe" :set "faicon" :color "green")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "web") (+org-capture/created-property))))
                            ("Video Url" :keys "v"
                             :icon ("nf-oct-video" :set "octicon" :color "red")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "video") (+org-capture/created-property))))
                            ("Repo Url" :keys "r"
                             :icon ("nf-fa-git" :set "faicon" :color "orange")
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :hook (lambda ()(progn (org-set-tags "repo") (+org-capture/created-property))))
                            ("Book" :keys "b"
                             :icon ("nf-fa-book" :set "faicon" :color "green")
                             :extra "%i %a"
                             :hook (lambda ()(progn (org-set-tags "book") (+org-capture/created-property))))
                            ("Idea" :keys "I"
                             :icon ("nf-md-chart_bubble" :set "mdicon" :color "silver")
                             :extra ""
                             :hook (lambda ()(progn (org-set-tags "idea") (+org-capture/created-property))))
                            ))

                ("Project templates"
                 :keys "p"
                 :type entry
                 :prepend t
                 :icon ("nf-fa-laptop_code" :set "faicon" :color "blue")
                 :function +org-capture/project-file
                 :heading "Project"
                 :template ("* %{time-or-todo} %?" "%{extra}")
                 :children (("Todo" :keys "t"
                             :extra ""
                             :time-or-todo "TODO"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                            ("Todo Url" :keys "u"
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :time-or-todo "TODO"
                             :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                             :icon ("nf-md-web" :set "mdicon" :color "blue"))
                            ("Todo clip" :keys "c"
                             :extra "%a"
                             :time-or-todo "TODO"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                            ("Todo link" :keys "l"
                             :extra "%i %a"
                             :time-or-todo "TODO"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                            ("Todo with deadline" :keys "d"
                             :extra "DEADLINE: %^{Deadline:}t"
                             :time-or-todo "TODO"
                             :hook +org-capture/created-property
                             :icon ("nf-md-timer" :set "mdicon" :color "orange" :v-adjust -0.1))
                            ("Todo scheduled" :keys "s"
                             :extra "SCHEDULED: %^{Start time:}t"
                             :time-or-todo "TODO"
                             :hook +org-capture/created-property
                             :icon ("nf-oct-calendar" :set "octicon" :color "orange"))
                            ("Note" :keys "n"
                             :extra  ""
                             :time-or-todo "%U"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-tasks" :set "faicon" :color "yellow"))
                            ("Note url" :keys "U"
                             :extra "[[%:link][%(+org-capture/www-get-page-title \"%:link\")]]"
                             :time-or-todo "%U"
                             :hook (lambda () (progn (org-set-tags "url") (+org-capture/created-property)))
                             :icon ("nf-md-web" :set "mdicon" :color "blue"))
                            ("Note clip" :keys "C"
                             :extra "%a"
                             :time-or-todo "%U"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-paste" :set "faicon" :color "cyan"))
                            ("Note link" :keys "L"
                             :extra "%i %a"
                             :time-or-todo "%U"
                             :hook +org-capture/created-property
                             :icon ("nf-fa-link" :set "faicon" :color "magenta"))
                            )
                 )
                )
              )

        )

  )
