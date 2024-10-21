;;; +org.el -*- lexical-binding: t; -*-
(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::"))

(add-hook! 'org-mode-hook #'abbrev-mode #'auto-fill-mode #'variable-pitch-mode)
(add-hook! 'org-mode-hook #'org-appear-mode #'hide-mode-line-mode)

;; Completing all child TODOs will change the parent TODO to DONE.
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

  (setq org-enforce-todo-dependencies t)
  (setq org-hierarchical-todo-statistics nil)
  (setq org-use-property-inheritance t)
  ;; Custom todo states
  (setq org-todo-keywords '((type
                             "TODO(t)" "NEXT(x)" "WAITING(w)"
                             "IDEA(i)" "NOTE(n)" "STUDY(s)" "READ(r)"
                             "WORK(w)" "PROJECT(p)" "CONTACT(c)" "SOMEDAY"
                             "|" "DONE(d)" "CANCELLED(C@)")))
  (setq org-todo-keyword-faces
        '(("TODO"  :inherit (org-todo region ) :foreground "yellow"   :weight bold)
          ("WORK"  :inherit (org-todo region) :foreground "DarkOrange1"   :weight bold)
          ("READ"  :inherit (org-todo region) :foreground "MediumPurple2" :weight bold)
          ("PROJECT"  :inherit (org-todo region) :foreground "orange3"     :weight bold)
          ("STUDY" :inherit (region org-todo) :foreground "plum3"       :weight bold)
          ("NOTE" :inherit (region org-todo) :foreground "SteelBlue"       :weight bold)
          ("DONE" . "SeaGreen4")))

;;; Interactive behaviour

  (setq org-bookmark-names-plist nil)
  (setq org-M-RET-may-split-line nil)
  ;; (setq org-adapt-indentation nil)
  (setq org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
  (setq org-fold-catch-invisible-edits 'smart)
  (setq org-footnote-auto-adjust t)
  (setq org-insert-heading-respect-content t)
  (setq org-loop-over-headlines-in-active-region 'start-level)

  (setq org-capture-templates
        '(
          ("s" "Stash")
          ("st" "Stash" entry
           (file "Stash.org")
           "* %^{Type|STUDY|READ|PROJECT|WORK|NOTE} %^{Todo title}\n** %?" :empty-lines-before 0)
          ("n" "CPB Note" entry (file+headline "Inbox.org" "Refile")
           "** NOTE: %? @ %U"        :empty-lines 0 :refile-targets (("Inbox.org" :maxlevel . 8)))

          ("i" "CPB Idea" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
           "** IDEA: %? @ %U :idea:" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))

          ("m" "CPB Note Clipboard")

          ("mm" "Paste clipboard" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
           "** NOTE: %(simpleclip-get-contents) %? @ %U" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))

          ("ml" "Create link and fetch title" entry (file+headline "~/Dropbox/org/cpb.org" "Refile")
           "** [[%(simpleclip-get-contents)][%(jib/www-get-page-title (simpleclip-get-contents))]] @ %U" :empty-lines 0 :refile-targets (("~/Dropbox/org/cpb.org" :maxlevel . 8)))
          )))
;; (after! org
;;   (add-to-list 'warning-suppress-types '(org-element-cache))
;;   (add-to-list 'warning-suppress-log-types '(org-element-cache)))

;; (map! "C-c a" 'org-agenda)

;; (map! :after org
;;       :map org-mode-map
;;       :ni "C-c l" #'+ol-insert-link
;;       :ni "C-c f" 'org-footnote-new
;;       :ni "C-c C-k" (general-predicate-dispatch 'org-cut-subtree
;;                       (bound-and-true-p org-capture-mode) 'org-capture-kill
;;                       (string-prefix-p "*Org" (buffer-name)) 'org-kill-note-or-show-branches)
;;       :ni "C-c RET" (general-predicate-dispatch 'org-insert-todo-heading
;;                       (org-at-table-p) 'org-table-hline-and-move)
;;       :i "<tab>" (general-predicate-dispatch 'org-cycle
;;                    (and (modulep! :editor snippets)
;;                         (featurep 'yasnippet)
;;                         (yas--templates-for-key-at-point)) #'yas-expand)

;;       :n "<backtab>" 'org-global-cycle
;;       :n "<tab>" 'org-cycle
;;       :n "C-c c" 'org-columns
;;       :n "C-c d" 'org-dynamic-block-insert-dblock
;;       :n "C-c n" 'org-next-link
;;       :n "C-c p" 'org-previous-link
;;       :n "M-n" 'org-metadown
;;       :n "M-p" 'org-metaup
;;       :n "RET" 'org-open-at-point
;;       :n "t"   'org-todo

;;       :ni "M-+" 'org-table-insert-column
;;       :ni "M--" 'org-table-delete-column
;;       :ni "C-c C-." 'org-time-stamp-inactive
;;       :ni "C-c ." 'org-time-stamp
;;       :ni "C-c o" 'org-table-toggle-coordinate-overlays)

;; (map! :after org :localleader :map org-mode-map
;;       :desc "Copy subtree" "y" #'org-copy-subtree
;;       :desc "Cut subtree" "x" #'org-cut-subtree
;;       :desc "Paste tree" "p" #'org-paste-subtree
;;       :desc "Todo tree" "t" #'org-show-todo-tree)

;; (when (modulep! +nursery)
;;   (map! "<f12>" (general-predicate-dispatch 'timekeep-start
;;                   (and (fboundp 'org-clocking-p) (org-clocking-p)) 'timekeep-stop)))


;; KLUDGE: Doom is attempting to set bindings on this mode, but evil-org appears
;; to have removed it.
;; (after! org
;;   (defalias 'evil-org-agenda-mode 'ignore)
;;   (defvar evil-org-agenda-mode-map (make-sparse-keymap)))

;; Remove doom's default capture templates.
;; (remove-hook 'org-load-hook #'+org-init-capture-defaults-h)

;; (after! evil-org
;;   (setq evil-org-special-o/O '(table-row item)))

;; (after! evil
;;   (setq evil-org-key-theme '(todo navigation insert textobjects additional calendar)))

;; ;; Prefer inserting headings with M-RET

;; (after! org
;;   (add-hook! 'org-metareturn-hook
;;     (when (org-in-item-p)
;;       (org-insert-heading current-prefix-arg)
;;       (evil-append-line 1)
;;       t)))

;; Automatically enter insert state when inserting new headings, logbook notes
;; or when using `org-capture'.

;; (after! evil
;;   (defadvice! +enter-evil-insert-state (&rest _)
;;     :after '(org-insert-heading
;;              org-insert-heading-respect-content
;;              org-insert-todo-heading-respect-content
;;              org-insert-todo-heading)
;;     (when (and (bound-and-true-p evil-mode)
;;                (called-interactively-p nil))
;;       (evil-insert-state)))

;;   (define-advice org-capture (:after (&rest _) insert-state)
;;     (when (and (bound-and-true-p evil-mode)
;;                (called-interactively-p nil)
;;                (bound-and-true-p org-capture-mode))
;;       (evil-insert-state)))

;;   (add-hook 'org-log-buffer-setup-hook #'evil-insert-state))

;; (autoload 'org-capture-detect "org-capture-detect")

;; (after! ws-butler
;;   (define-advice ws-butler-before-save (:around (fn &rest args) inhibit-during-capture)
;;     (unless (org-capture-detect)
;;       (apply fn args)))

;;   (define-advice ws-butler-after-save (:around (fn &rest args) inhibit-during-capture)
;;     (unless (org-capture-detect)
;;       (apply fn args))))

;; (define-advice org-reveal (:around (fn &rest args) org-buffers-only)
;;   "Work around Doom errors attempting to use org-reveal in scratch buffer."
;;   (when (derived-mode-p 'org-mode)
;;     (apply fn args)))

;; (define-advice org-align-tags (:around (fn &rest args) ignore-errors)
;;   "Fix issue in `org-roam-promote-entire-buffer'."
;;   (ignore-errors
;;     (apply fn args)))
