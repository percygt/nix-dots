;;; +org.el -*- lexical-binding: t; -*-

(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory)
      +org-capture-notes-file "Inbox.org"
      +org-capture-todo-file "Home.org"
      +org-capture-projects-file "Projects.org"
      +org-capture-journal-file "Inbox.org")

(map!
 :leader
 :prefix-map ("o" . "Org")
 :desc "Org Capture" "c" #'org-capture)

(map! :map org-mode-map
      :ie [tab] #'corfu-next)

(custom-set-faces!
  '(org-document-title :height 1.5)
  '(org-ellipsis :foreground "DimGray" :height 0.6)
  '(org-level-1 :inherit (outline-1 variable-pitch) :extend t :weight bold :height 1.5)
  '(org-level-2 :inherit (outline-2 variable-pitch) :extend t :height 1.1)
  '(org-level-3 :inherit (outline-3 variable-pitch) :extend t :height 1.05)
  '(org-level-4 :inherit (outline-4 variable-pitch) :extend t :height 1.0)
  '(org-level-5 :inherit (outline-5 variable-pitch) :extend t :height 1.0)
  '(org-level-6 :inherit (outline-6 variable-pitch) :extend t :height 1.0)
  '(org-level-7 :inherit (outline-7 variable-pitch) :extend t)
  '(org-level-8 :inherit (outline-8 variable-pitch) :extend t)
  '(org-block-begin-line :inherit fixed-pitch :height 0.8 :slant italic :background "unspecified")
  ;; Ensure that anything that should be fixed-pitch in org buffers appears that
  ;; way
  '(org-block :inherit fixed-pitch)
  '(org-code :inherit (shadow fixed-pitch)))

(defun +aiz-org-mode-setup ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
        display-fill-column-indicator nil
        display-line-numbers nil)
  (writeroom-mode t)
  ;; (visual-line-mode +1)
  (auto-fill-mode 0)
  (variable-pitch-mode)
  )

(defun org-id-complete-link (&optional arg)
  "Create an id: link using completion"
  (concat "id:" (org-id-get-with-outline-path-completion)))

(after! org
  (load! "+org-modern.el")
  (load! "+writeroom-mode.el")
  (load! "+org-keywords.el")
  (load! "+org-variables.el")
  (load! "+org-capture-doct.el")
  (load! "+org-capture-prettify.el")
  (load! "+org-capture.el")
  (load! "+org-agenda.el")
  (add-hook 'org-mode-hook #'+aiz-org-mode-setup)
  (org-link-set-parameters "id" :complete 'org-id-complete-link)
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
        pdf-annot-activate-created-annotations nil ; do not open annotations after creating them
        org-journal-find-file #'find-file-other-window
        org-startup-with-inline-images t
        org-image-actual-width 600
        org-babel-default-header-args:sh '((:results . "verbatim"))
        org-duration-format (quote h:mm)) ; display clock times as hours only
  )
