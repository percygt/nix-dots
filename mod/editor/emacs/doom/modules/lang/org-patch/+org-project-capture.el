;;; +org-project-capture.el -*- lexical-binding: t; -*-

(defvar +org-capture/created-property-string "
:PROPERTIES:
:CREATED: %U
:END:")

(use-package! org-project-capture
  :defer 2
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
          occ-auto-insert-category-heading t)
    ;; (add-to-list 'org-capture-templates
    ;;              (org-project-capture-project-todo-entry
    ;;               :capture-character "l"
    ;;               :capture-template (format "%s%s" "* %?" +org-capture/created-property-string)
    ;;               :capture-heading "   Project Note"
    ;;               ))
    ;; (add-to-list 'org-capture-templates
    ;;              (org-project-capture-project-todo-entry
    ;;               :capture-heading "   Project Todo"
    ;;               :capture-template (format "%s%s" "* TODO %?" +org-capture/created-property-string)
    ;;               :capture-character "p"))
    (setq org-confirm-elisp-link-function nil)
    )
  )
