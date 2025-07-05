;;; autoload/org.el -*- lexical-binding: t; -*-
(defun +aiz-org-done-keep-todo ()
  "Mark an org todo item as done while keeping its former keyword intact, and archive.
For example, * TODO This item    becomes    * DONE TODO This item."
  (interactive)
  (let ((state (org-get-todo-state)) (tag (org-get-tags)) (todo (org-entry-get (point) "TODO"))
        post-command-hook)
    (if (not (eq state nil))
        (progn (org-back-to-heading)
	       (org-todo "DONE")
	       (org-set-tags tag)
	       (beginning-of-line)
	       (forward-word)
	       (insert (concat " " todo)))
      (user-error "Not a TODO."))
    (run-hooks 'post-command-hook)))

(defun +aiz-org-done-keep-todo-and-archive ()
  "Same as `jib/org-done-keep-todo' but archives heading as well."
  (interactive)
  (let ((state (org-get-todo-state)) (tag (org-get-tags)) (todo (org-entry-get (point) "TODO"))
        post-command-hook)
    (if (not (eq state nil))
        (progn (org-back-to-heading)
	       (org-todo "DONE")
	       (org-set-tags tag)
	       (beginning-of-line)
	       (forward-word)
	       (insert (concat " " todo))
	       (org-archive-subtree-default))
      (user-error "Not a TODO."))
    (run-hooks 'post-command-hook)))

(defun +aiz-org-archive-ql-search ()
  "Input or select a tag to search in my archive files."
  (interactive)
  (let* ((choices '("bv" "sp" "ch" "cl" "es" "Robotics ec" "Weekly ec")) ;; TODO get these with org-current-tag-alist
	 (tag (completing-read "Tag: " choices)))
    (org-ql-search
      ;; Recursively get all .org_archive files from my archive directory
      (directory-files-recursively
       (expand-file-name "org-archive" org-directory) ".org_archive")
      ;; Has the matching tags (can be a property or just a tag) and is a todo - done or not
      `(and (or (property "ARCHIVE_ITAGS" ,tag) (tags ,tag)) (or (todo) (done))))))
