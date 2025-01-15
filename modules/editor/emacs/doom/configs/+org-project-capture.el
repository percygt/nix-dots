;;; +org-project-capture.el -*- lexical-binding: t; -*-
(use-package! org-project-capture
  :config
  (progn
    (if (require 'projectile nil 'noerror)
        (progn
          (require 'org-projectile)
          (setq org-project-capture-default-backend (make-instance 'org-project-capture-projectile-backend))))
    (setq org-project-capture-strategy
          (make-instance 'org-project-capture-combine-strategies
                         :strategies (list (make-instance 'org-project-capture-single-file-strategy)
                                           (make-instance 'org-project-capture-per-project-strategy))))
    (setq org-project-capture-projects-file (expand-file-name "Project.org" org-directory)
          org-project-capture-capture-template (format "%s%s" "* TODO %?" +org-capture-created-property-string)
          occ-auto-insert-category-heading t)
    (add-to-list 'org-capture-templates
                 (org-project-capture-project-todo-entry
                  :capture-character "l"
                  :capture-heading "Project Note"
                  ))
    (add-to-list 'org-capture-templates
                 (org-project-capture-project-todo-entry
                  :capture-character "p"))
    (setq org-confirm-elisp-link-function nil)
    )
  )
