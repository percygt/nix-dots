;;; +org.el -*- lexical-binding: t; -*-
(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::"))

(map! :after org
      :leader
      :prefix ("o" . "Org")
      "c" #'org-capture
      )

(use-package! mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

(use-package! org-appear
  :hook
  (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t)
  (setq org-appear-autosubmarkers t)
  (setq org-appear-autolinks t)
  )

(defun p67/org-mode-setup ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
        display-fill-column-indicator nil
        display-line-numbers nil)
  (visual-fill-column-mode 1)
  (visual-line-mode +1)
  (org-indent-mode +1)
  (hide-mode-line-mode +1)
  (auto-fill-mode 0)
  (variable-pitch-mode)
  )

(add-hook 'org-mode-hook #'p67/org-mode-setup)

(after! org
  (custom-set-faces!
    '(org-document-title :height 1.5)
    '(outline-1 :weight extra-bold :height 1.5)
    '(outline-2 :weight bold :height 1.3)
    '(outline-3 :weight bold :height 1.2)
    '(outline-4 :weight bold :height 1.1)
    '(outline-5 :weight semi-bold :height 1.1)
    '(outline-6 :weight semi-bold :height 1.05)
    '(outline-7 :weight semi-bold)
    '(outline-8 :weight semi-bold)
    ;; Ensure that anything that should be fixed-pitch in org buffers appears that
    ;; way
    '(org-block nil :inherit 'fixed-pitch)
    '(org-code nil :inherit '(shadow fixed-pitch))
    '(org-table nil :inherit '(shadow fixed-pitch))
    '(org-verbatim nil :inherit '(shadow fixed-pitch))
    '(org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    '(org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    '(org-checkbox nil :inherit 'fixed-pitch)))


;; ;; Completing all child TODOs will change the parent TODO to DONE.
(add-hook! 'org-after-todo-statistics-hook
  (fn! (let (org-log-done) ; turn off logging
         (org-todo (if (zerop %2) "DONE" "TODO")))))

(after! org
;;; Visual settings
  (setq org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
  (setq org-startup-folded 'show2levels)
  (setq org-list-indent-offset 1)
  (setq org-cycle-separator-lines 1)
  (setq org-indent-indentation-per-level 2)
  (setq org-ellipsis " ")
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
  (setq org-loop-over-headlines-in-active-region 'start-level)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  )

(after! org
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

  )
