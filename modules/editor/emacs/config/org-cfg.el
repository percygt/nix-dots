;;; org-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package org
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '((derived-mode . org-capture-mode)
                 (display-buffer-full-frame)))
  (add-to-list 'display-buffer-alist
               '("\\*Org Select\\*"
                 (display-buffer-full-frame)))
  :preface
  (defun org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode)
    (auto-fill-mode 0)
    (visual-line-mode 1)
    (setq evil-auto-indent nil))
  :hook
  (org-mode . org-mode-setup)
  :custom
  (org-capture-templates
   '(("t" "todo" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\n%i\n%a"
      :prepend t)
     ("d" "deadline" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\nDEADLINE: <%(org-read-date)>\n\n%i\n%a"
      :prepend t)
     ("s" "schedule" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a"
      :prepend t)
     ("c" "check out later" entry (file+headline "todo.org" "Check out later")
      "* [ ] %?\n%i\n%a"
      :prepend t)))
  (org-highlight-latex-and-related '(native)) ;; Highlight inline LaTeX
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-list-indent-offset 1)
  (org-cycle-separator-lines 1)
  (org-ellipsis " ")
  (org-pretty-entities t)
  (org-special-ctrl-a/e '(t . nil))
  (org-special-ctrl-k t)
  (org-src-fontify-natively t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-edit-src-content-indentation 2)
  (org-hide-block-startup nil)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation nil)
  (org-startup-folded 'showeverything)
  (org-image-actual-width 300)
  (org-cycle-separator-lines 2)
  (org-hide-leading-stars t)
  (org-highlight-latex-and-related '(native))
  (org-goto-auto-isearch nil)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
  (org-catch-invisible-edits 'show-and-error) ;; 'smart
  (org-todo-keywords '((type "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c@)")))
  (org-checkbox-hierarchical-statistics t)
  (org-list-demote-modify-bullet '(("+" . "*") ("*" . "-") ("-" . "+")))
  (org-enforce-todo-dependencies t)
  (org-hierarchical-todo-statistics nil)
  (org-use-property-inheritance t)
  :custom-face
  (outline-1 ((t (:height 1.2))))
  (outline-2 ((t (:height 1.1))))
  (outline-3 ((t (:height 1.05))))
  (outline-4 ((t (:height 1.0))))
  (outline-5 ((t (:height 1.1))))
  (outline-6 ((t (:height 1.1))))
  (outline-7 ((t (:height 1.1))))
  (outline-8 ((t (:height 1.1))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit (shadow fixed-pitch)))))
  (org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  (org-indent ((t (:inherit (org-hide fixed-pitch)))))
  (org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  (org-property-value ((t (:inherit fixed-pitch))) t)
  (org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 1.0))))
  (org-tags-column -1)
  (org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  (org-lowest-priority ?F)  ;; Gives us priorities A through F
  (org-default-priority ?E) ;; If an item has no priority, it is considered [#E].
  (org-priority-faces
      '((65 . "red2")
        (66 . "Gold1")
        (67 . "Goldenrod2")
        (68 . "PaleTurquoise3")
        (69 . "DarkSlateGray4")
        (70 . "PaleTurquoise4"))))

(use-package evil-org
  :diminish evil-org-mode
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	        (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-modern
  :ensure t
  :hook ((org-mode                 . org-modern-mode)
         (org-agenda-finalize-hook . org-modern-agenda))
  :custom ((org-modern-table nil)
	       (org-modern-list'((?+ . "✦") (?- . "‣") (?* . "◉")))
	       (org-modern-variable-pitch t))
  :commands (org-modern-mode org-modern-agenda)
  :init (global-org-modern-mode))

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t		;; A default setting that needs to be t for org-appear
        org-appear-autoemphasis t		;; Enable org-appear on emphasis (bold, italics, etc)
        org-appear-autolinks nil		;; Don't enable on links
        org-appear-autosubmarkers t))	;; Enable on subscript and superscript

(use-package org-ql
  :defer t
  :general
  (:states '(normal) :keymaps 'org-ql-view-map
           "q" 'kill-buffer-and-window))
;; (use-package org-brain
;;   :custom
;;   (org-brain-path notes-directory)
;;   (org-brain-visualize-default-choices 'all)
;;   (org-brain-title-max-length 12)
;;   (org-brain-include-file-entries nil)
;;   (org-brain-file-entries-use-title nil)
;;   ;; For Evil users
;;   :init
;;   (with-eval-after-load 'evil
;;     (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
;;   :config
;;   (bind-key "C-c b" 'org-brain-prefix-map org-mode-map))
;; (setq org-id-track-globally t)
;; (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
;; (push '("b" "Brain" plain (function org-brain-goto-end)
;;         "* %i%?" :empty-lines 1)
;;       org-capture-templates)

;; Allows you to edit entries directly from org-brain-visualize
;; (use-package polymode
;;   :config
;;   (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))


;;;; Templates
;; (use-package org-tempo
;;   :ensure nil
;;   :after org
;;   :config
;;   (let ((templates '(("sh"  . "src sh")
;;                      ("el"  . "src emacs-lisp")
;;                      ("vim" . "src vim")
;;                      ("cpp" . "src C++ :includes <iostream> :namespaces std"))))
;;     (dolist (template templates)
;;       (push template org-structure-template-alist))))


;; (use-package org-timeblock)

;; (use-package org-transclusion :after org)

;; (use-package org-ql)


(provide 'org-cfg)
;;; org-cfg.el ends here
