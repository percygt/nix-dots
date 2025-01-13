(use-package! org-gtd
  :after (org org-ql)
  ;; TODO this isn't being set properly using :custom, need to debug why when I have a chance
  ;;:custom
  ;;(+patch/org-gtd-tasks-file (concat (file-name-as-directory org-gtd-directory) "org-gtd-tasks.org"))
  :init
  (setq org-gtd-directory "~/.local/share/notes/gtd/")
  (setq org-gtd-process-item-hooks '(org-set-tags-command))
  (setq org-edna-use-inheritance t)
  (org-edna-mode 1)
  (defun +patch/gen-org-refile-rfloc (file headline)
    "Format a specified file/heading for passing to org-refile and org-agenda-refile.

   FILE is the file to refile into.

   HEADLINE is the headline (inside FILE) to refile into."
    (let ((pos (save-excursion
                 (find-file file)
                 (org-find-exact-headline-in-buffer headline))))
      (list headline file nil pos)))

  (defun +patch/refile-to-node (arg file headline)
    (org-agenda-refile arg (+patch/gen-org-refile-rfloc file headline)))

  (defun +patch/org-agenda-refile (file headline)
    "Refile item at point to a particular place via org-agenda-refile, but
   with a simpler interface.

   FILE is the file to refile into.

   HEADLINE is the headline (inside FILE) to refile into."
    (save-window-excursion
      (org-agenda-refile nil (+patch/gen-org-refile-rfloc file headline))))

  ;; FIXME setting here instead of in :custom becuase it's not working in :custom (see note above)
  (setq +patch/org-gtd-tasks-file (concat (file-name-as-directory org-gtd-directory) "org-gtd-tasks.org"))
  (defvar +patch/refine-project-map (make-sparse-keymap)
    "Keymap for command `+patch/refine-project-mode', a minor mode.")

  (define-minor-mode +patch/refine-project-mode
    "Minor mode for org-gtd."
    nil " +prp" +patch/refine-project-map
    :global nil
    (if +patch/refine-project-mode
        (setq-local
         header-line-format
         (substitute-command-keys
          "\\<+patch/refine-project-mode>Refine project, add subtasks, then press `C-c C-c' to complete."))
      (setq-local header-line-format nil)))

  (defun +patch/convert-to-project ()
    (interactive)
    (org-tree-to-indirect-buffer)
    (+patch/refine-project-mode t))

  (defun +patch/create-new-project ()
    (interactive)
    (let* ((org-refile-targets `((,+patch/org-gtd-tasks-file :regexp . "*")))
           (rfloc (org-refile-get-location "Parent location for new project")))
      (org-refile t nil rfloc)
      (+org/insert-item-below 1)
      (org-cycle)
      (org-tree-to-indirect-buffer)
      (+patch/refine-project-mode t)))

  (defun +patch/refile-to-project ()
    (interactive)
    (let* ((org-refile-targets `((,+patch/org-gtd-tasks-file :regexp . "*")))
           (rfloc (org-refile-get-location "Project to move this task into")))
      (org-refile nil nil rfloc)))

  (setq +patch--widen-hooks '())

  (defun +patch/widen ()
    (interactive)
    (widen)
    (+patch/refine-project-mode -1)
    (dolist (hook +patch--widen-hooks)
      (save-excursion
        (save-restriction
          (funcall hook)))))
  (map! (:map evil-normal-state-map
              (:prefix-map ("DEL" . "GTD")
               :desc "Archive"             "a" #'org-archive-to-archive-sibling
               :desc "Views"               "V" #'org-ql-view
               :desc "Process Item"        "DEL" #'+patch-gtd/process-inbox-item
               (:prefix ("r" . "Projects")
                :desc "Convert to project" "c" #'+patch/convert-to-project
                :desc "Create new project" "n" #'+patch/create-new-project)))
        (:map +patch/refine-project-map       "C-c C-c" #'+patch/widen)))
