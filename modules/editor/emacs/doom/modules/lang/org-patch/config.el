;;; lang/org-patch/config.el -*- lexical-binding: t; -*-

(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory)
      +org-capture-notes-file "Inbox.org"
      +org-capture-todo-file "Tasks.org"
      +org-capture-projects-file "Projects.org")


(defvar +org-capture-calendar-file "Calendar.org"
  "Default target for calendar entries.")
(defun +org-capture-calendar-file ()
  "Expand `+org-capture-calendar-file' from `org-directory'.
If it is an absolute path return `+org-capture-calendar-file' verbatim."
  (expand-file-name +org-capture-calendar-file org-directory))

(custom-set-faces!
  '(org-document-title :height 1.5)
  '(org-ellipsis :foreground "DimGray" :height 0.6)
  '(org-level-1 :inherit (outline-1 variable-pitch) :extend t :weight bold :height 1.5)
  '(org-level-2 :inherit (outline-2 variable-pitch) :extend t :weight light :height 1.1)
  '(org-level-3 :inherit (outline-3 variable-pitch) :extend t :weight light :height 1.05)
  '(org-level-4 :inherit (outline-4 variable-pitch) :extend t :weight light :height 1.0)
  '(org-level-5 :inherit (outline-5 variable-pitch) :extend t :weight light :height 1.0)
  '(org-level-6 :inherit (outline-6 variable-pitch) :extend t :weight light :height 1.0)
  '(org-level-7 :inherit (outline-7 variable-pitch) :extend t :weight light)
  '(org-level-8 :inherit (outline-8 variable-pitch) :extend t :weight light)
  '(org-block-begin-line :inherit fixed-pitch :height 0.8 :slant italic :background "unspecified")
  ;; Ensure that anything that should be fixed-pitch in org buffers appears that
  ;; way
  '(org-block :inherit fixed-pitch)
  '(org-code :inherit (shadow fixed-pitch)))

(load! "+org-capture.el")
(load! "+org-agenda.el")
(load! "+org-modern.el")
(load! "+org-capture-doct.el")
(load! "+org-capture-prettify.el")
(load! "+org-project-capture.el")
(load! "+org-roam.el")
(load! "+org-roam-capture.el")
(load! "+visual-fill-column.el")
(load! "+writeroom-mode.el")
(add-hook! 'org-mode-hook
  (setq display-fill-column-indicator nil
        display-line-numbers nil)
  (auto-fill-mode 0)
  (variable-pitch-mode))

;; ;; https://www.reddit.com/r/orgmode/comments/14bx0v4/open_orgcapture_frame_maximized_to_the_window/
;; ;; needs to be inside after! org block
;; (defun stag-misanthropic-capture (&rest r)
;;   (delete-other-windows))
;; (advice-add  #'org-capture-place-template :after 'stag-misanthropic-capture)

(defun org-id-complete-link (&optional arg)
  "Create an id: link using completion"
  (concat "id:" (org-id-get-with-outline-path-completion)))
(org-link-set-parameters "id" :complete 'org-id-complete-link)

(setq org-emphasis-alist
      '(("*" (bold))
        ("_" underline)
        ("=" (:foreground "#8bd49c"))
        ("~" (:foreground "#5ec4ff"))
        ("+" (:strike-through t))))
(setq org-startup-folded nil ; do not start folded
      org-link-frame-setup '((file . find-file));; Opens links to other org file in same frame (rather than splitting) org-tags-column 80 ; the column to the right to align tags
      org-ellipsis " "
      org-pretty-entities t
      org-fold-catch-invisible-edits 'show-and-error
      org-babel-min-lines-for-block-output 5 ; when to wrap results in #begin_example
      org-return-follows-link nil  ; RET doesn't follow links
      org-hide-emphasis-markers nil ; do show format markers
      org-startup-with-inline-images t ; open buffers show inline images
      org-use-property-inheritance t
      org-log-done 'time ; record the time when an element was marked done/checked
      org-log-into-drawer t
      org-src-tab-acts-natively t
      org-auto-align-tags nil
      org-tags-column -1
      org-cycle-emulate-tab nil
      org-startup-folded 'content
      org-todo-repeat-to-state t
      org-startup-with-inline-images t
      org-image-actual-width 600)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d@/!)" "KILL(k@/!)"))
      ;; The triggers break down to the following rules:

      ;; - Moving a task to =KILLED= adds a =killed= tag
      ;; - Moving a task to =WAIT= adds a =waiting= tag
      ;; - Moving a task to a done state removes =WAIT= and =HOLD= tags
      ;; - Moving a task to =TODO= removes all tags
      ;; - Moving a task to =NEXT= removes all tags
      ;; - Moving a task to =DONE= removes all tags
      org-todo-state-tags-triggers
      '(("KILL" ("killed" . t))
        ("HOLD" ("hold" . t))
        ("WAIT" ("waiting" . t))
        (done ("waiting") ("hold"))
        ("TODO" ("waiting") ("cancelled") ("hold"))
        ("NEXT" ("waiting") ("cancelled") ("hold"))
        ("DONE" ("waiting") ("cancelled") ("hold")))

      ;; This settings allows to fixup the state of a todo item without
      ;; triggering notes or log.
      org-treat-S-cursor-todo-selection-as-state-change nil)
