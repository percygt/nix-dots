;;; +org.el -*- lexical-binding: t; -*-
(require 'org)
(after! org
  (load! "+org-modern.el")
  (load! "+org-capture.el")
  (load! "+org-agenda.el")
  (load! "+org-roam.el")
  )


(map! :after org
      :leader
      :desc "Org Capture" "c" #'org-capture
      )

(use-package! org-journal
  :defer t
  :init
  ;; org journal
  (setq org-journal-dir (concat orgDirectory "journal/"))
  (setq org-journal-file-type 'daily)
  (setq org-journal-file-format "%Y%m%d.org")
  (setq org-journal-date-format "%A, %B %d %Y")
  (setq org-extend-today-until 4)
  :config
  (setq org-journal-carryover-items "")
  )

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

;; (defun +aiz-log-todo-state-properties (&rest ignore)
;;   "Log creation time in the property drawer"
;;   (when (and (org-get-todo-state)
;;              (not (org-entry-get nil "CREATED")))
;;     (org-entry-put nil "CREATED" (format-time-string "<%Y-%m-%d %a %R>")))

;;   (when (string= (org-get-todo-state) "TODO")
;;     (when (org-entry-get nil "ACTIVATED")
;;       (org-entry-delete nil "ACTIVATED"))
;;     (when (org-entry-get nil "COMPLETED")
;;       (org-entry-delete nil "COMPLETED")))

;;   (when (string= (org-get-todo-state) "NEXT")
;;     (when (not (org-entry-get nil "CREATED"))
;;       (org-entry-put nil "CREATED" (format-time-string "<%Y-%m-%d %a %R>")))
;;     (when (org-entry-get nil "COMPLETED")
;;       (org-entry-delete nil "COMPLETED"))
;;     (when (not (org-entry-get nil "ACTIVATED"))
;;       (org-entry-put nil "ACTIVATED" (format-time-string "<%Y-%m-%d %a %R>"))))

;;   (when (string= (org-get-todo-state) "DONE")
;;     (when (not (org-entry-get nil "CREATED"))
;;       (org-entry-put nil "CREATED" (format-time-string "<%Y-%m-%d %a %R>")))
;;     (when (not (org-entry-get nil "ACTIVATED"))
;;       (org-entry-put nil "ACTIVATED" (format-time-string "<%Y-%m-%d %a %R>")))
;;     (when (not (org-entry-get nil "COMPLETED"))
;;       (org-entry-put nil "COMPLETED" (format-time-string "<%Y-%m-%d %a %R>")))))

;; (advice-add 'org-insert-todo-heading :after #'+aiz-log-todo-creation-date)
;; (advice-add 'org-insert-todo-heading-respect-content :after #'+aiz-log-todo-creation-date)
;; (advice-add 'org-insert-todo-subheading :after #'+aiz-log-todo-creation-date)

;; (add-hook 'org-after-todo-state-change-hook #'+aiz-log-todo-state-properties)
;; (add-hook 'org-capture-before-finalize-hook #'+aiz-log-todo-state-properties)

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets
      '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

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
  '(org-code :inherit (shadow fixed-pitch))
  )


(add-hook! 'org-after-todo-statistics-hook
  (fn! (let (org-log-done) ; turn off logging
         (org-todo (if (zerop %2) "DONE" "TODO")))))

;;; Visual settings
(setq org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
(setq org-startup-folded 'show2levels)
(setq org-list-indent-offset 1)
(setq org-cycle-separator-lines 1)
(setq org-indent-indentation-per-level 2)
(setq org-ellipsis " ")
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-hide-emphasis-markers t)
(setq org-indent-mode-turns-on-hiding-stars t)
(setq org-pretty-entities t)
(setq org-startup-indented t)
(setq org-startup-shrink-all-tables t)
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview nil)
;;; TODOs, checkboxes, stats, properties.
(setq org-hierarchical-todo-statistics nil)
(setq org-use-property-inheritance t)
(setq org-enforce-todo-dependencies t)

  ;;; Interactive behaviour

(setq org-bookmark-names-plist nil)
(setq org-M-RET-may-split-line nil)
;; (setq org-adapt-indentation nil)
(setq org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
(setq org-fold-catch-invisible-edits 'smart)
(setq org-footnote-auto-adjust t)
(setq org-insert-heading-respect-content t)
;; (setq org-loop-over-headlines-in-active-region 'start-level)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-keywords
      '(
        (sequence
         "TODO(t)" ; doing later
         "NEXT(n)" ; doing now or soon
         "|"
         "DONE(d)" ; done
         )
        (sequence
         "WAIT(w@/!)" ; waiting for some external change (event)
         "HOLD(h@/!)" ; waiting for some internal change (of mind)
         "|"
         "KILL(C@/!)"
         )
        (type
         "IDEA(i)" ; maybe someday
         "NOTE(N)"
         "STUDY(s)"
         "READ(r)"
         "WORK(w)"
         "PROJECT(p)"
         "PEOPLE(h)"
         "|"
         )
        )
      )
