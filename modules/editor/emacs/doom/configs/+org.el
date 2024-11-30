;;; +org.el -*- lexical-binding: t; -*-

(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory)
      +org-capture-notes-file "Inbox.org"
      +org-capture-journal-file "Journal.org"
      )

(after! org
  (load! "+org-modern.el")
  (setq org-startup-folded nil ; do not start folded
        org-link-frame-setup '((file . find-file));; Opens links to other org file in same frame (rather than splitting) org-tags-column 80 ; the column to the right to align tags
        org-log-done 'time ; record the time when an element was marked done/checked
        org-ellipsis " "
        org-pretty-entities t
        org-fold-catch-invisible-edits 'show-and-error
        org-babel-min-lines-for-block-output 5 ; when to wrap results in #begin_example
        org-return-follows-link nil  ; RET doesn't follow links
        org-hide-emphasis-markers nil ; do show format markers
        org-startup-with-inline-images t ; open buffers show inline images
        org-babel-default-header-args:sh '((:results . "verbatim"))
        org-todo-repeat-to-state t
        pdf-annot-activate-created-annotations nil ; do not open annotations after creating them
        org-duration-format (quote h:mm)) ; display clock times as hours only
  )

(use-package! org-journal
  :defer t
  :init
  ;; org journal
  (setq org-journal-dir (expand-file-name "journal" org-directory))
  (setq org-journal-file-type 'daily)
  (setq org-journal-file-format "%Y%m%d.org")
  (setq org-journal-date-format "%A, %B %d %Y")
  (setq org-extend-today-until 4)
  :config
  (setq org-journal-carryover-items ""))

(use-package! org-appear
  :hook
  (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t)
  (setq org-appear-autosubmarkers t)
  (setq org-appear-autolinks t))

(use-package! visual-fill-column
  :config
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 100)
  (setq visual-fill-column-center-text t))

(use-package! writeroom-mode
  :config
  (setq writeroom-maximize-window nil
        writeroom-mode-line nil
        writeroom-global-effects nil ;; No need to have Writeroom do any of that silly stuff
        writeroom-extra-line-spacing 3)
  (setq writeroom-width visual-fill-column-width))

(defun +aiz-org-mode-setup ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
        display-fill-column-indicator nil
        display-line-numbers nil)
  (writeroom-mode t)
  (visual-line-mode +1)
  (auto-fill-mode 0)
  (variable-pitch-mode))

(add-hook 'org-mode-hook #'+aiz-org-mode-setup)

(custom-set-faces!
  '(org-document-title :height 1.5)
  '(org-ellipsis :foreground "DimGray" :height 0.6)
  '(org-level-1 :inherit (outline-1 variable-pitch) :extend t :weight extra-bold :height 1.5)
  '(org-level-2 :inherit (outline-2 variable-pitch) :extend t :weight bold :height 1.3)
  '(org-level-3 :inherit (outline-3 variable-pitch) :extend t :weight bold :height 1.2)
  '(org-level-4 :inherit (outline-4 variable-pitch) :extend t :weight bold :height 1.1)
  '(org-level-5 :inherit (outline-5 variable-pitch) :extend t :weight semi-bold :height 1.1)
  '(org-level-6 :inherit (outline-6 variable-pitch) :extend t :weight semi-bold :height 1.05)
  '(org-level-7 :inherit (outline-7 variable-pitch) :extend t :weight semi-bold)
  '(org-level-8 :inherit (outline-8 variable-pitch) :extend t :weight semi-bold)
  '(org-block-begin-line :inherit fixed-pitch :height 0.8 :slant italic :background "unspecified")
  ;; Ensure that anything that should be fixed-pitch in org buffers appears that
  ;; way
  '(org-block :inherit fixed-pitch)
  '(org-code :inherit (shadow fixed-pitch)))
