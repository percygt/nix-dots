;;; org-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package org
  :ensure nil
  :commands org-babel-do-load-languages
  :diminish org-indent-mode
  :diminish visual-line-mode
  :hook
  (org-mode . org-mode-setup)
  ;; (org-mode . org-prettify-symbols-setup)
  (org-capture-mode . evil-insert-state) ;; Start org-capture in Insert state by default
  (org-mode-hook . (lambda ()
                     (fset 'tex-font-lock-suscript 'ignore)
                     (org-babel-do-load-languages
                      'org-babel-load-languages
                      '((python . t)
                        (shell . t)
                        (elisp . t)
                        ))))
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*Capture\\*$"
                 (display-buffer-full-frame)))
  (add-to-list 'display-buffer-alist
               '("\\*Org Select\\*"
                 (display-buffer-full-frame)))

  :preface
  (defun org-mode-setup ()
    (org-indent-mode)
    (auto-fill-mode 0)
    (variable-pitch-mode)
    (visual-line-mode 1)
    ;; (valign-mode)
    )
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
  (org-src-preserve-indentation nil)
  (org-src-fontify-natively t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-hide-block-startup nil)
  (org-special-ctrl-a/e t)
  (org-src-tab-acts-natively t)
  (org-startup-folded t)
  (org-image-actual-width nil)
  (org-cycle-separator-lines 1)
  (org-hide-leading-stars t)
  (org-goto-auto-isearch nil)
  (org-log-done 'time)
  (org-log-into-drawer t)
  ;; M-Ret can split lines on items and tables but not headlines and not on anything else (unconfigured)
  (org-M-RET-may-split-line '((headline) (item . t) (table . t) (default)))
  (org-loop-over-headlines-in-active-region nil)

  (org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
  (org-catch-invisible-edits 'show-and-error) ;; 'smart
  (org-todo-keywords '((type "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c@)")))
  (org-checkbox-hierarchical-statistics t)
  (org-list-demote-modify-bullet '(("+" . "*") ("*" . "-") ("-" . "+")))
  (org-enforce-todo-dependencies t)
  (org-hierarchical-todo-statistics nil)
  (org-use-property-inheritance t)
  (org-tags-column -1)
  (org-highest-priority ?A)
  (org-default-priority ?D)
  (org-lowest-priority ?E)
  :custom-face
  (outline-1 ((t (:height 1.2))))
  (outline-2 ((t (:height 1.1))))
  (outline-3 ((t (:height 1.05))))
  (outline-4 ((t (:height 1.025))))
  (outline-5 ((t (:height 1.0))))
  (outline-6 ((t (:height 1.0))))
  (outline-7 ((t (:height 1.0))))
  (outline-8 ((t (:height 1.0))))
  (org-code ((t (:inherit fixed-pitch))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-document-title ((t (:inherit (fixed-pitch) :foreground "LightGray"))))
  (org-document-info ((t (:inherit (fixed-pitch) :foreground "LightGray" :height 0.8))))
  (org-document-info-keyword ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-drawer ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-indent ((t (:inherit (org-hide fixed-pitch)))))
  (org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-property-value ((t (:inherit fixed-pitch))))
  (org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-tag ((t (:inherit fixed-pitch :weight bold))))
  (org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  )

(use-package evil-org
  :diminish evil-org-mode
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	        (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package valign :defer t)

(use-package org-modern
  :custom
  (org-modern-table nil)
  (org-modern-hide-stars nil)		; adds extra indentation
  (org-modern-list'((?+ . "✦") (?- . "‣") (?* . "◉")))
  (org-modern-block-name '("" . "")) ; or other chars; so top bracket is drawn promptly
  (org-modern-variable-pitch t)
  :commands (org-modern-mode org-modern-agenda)
  :init (global-org-modern-mode)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-modern-indent
  :ensure nil
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

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

;; ;; allows you to edit entries directly from org-brain-visualize
;; (use-package polymode
;;   :general
;;   (local-definer
;;     :states '(normal visual)
;;     :keymaps 'polymode-mode-map
;;     "j" 'polymode-next-chunk
;;     "k" 'polymode-previous-chunk
;;     "i" 'polymode-insert-new-chunk
;;     "u" 'polymode-insert-new-chunk-code-only
;;     "U" 'polymode-insert-new-chunk-output-only
;;     "p" 'polymode-insert-new-plot
;;     "o" 'polymode-insert-yaml
;;     "d" 'polymode-kill-chunk
;;     "e" 'polymode-export
;;     "E" 'polymode-set-exporter
;;     "w" 'polymode-weave
;;     "W" 'polymode-set-weaver
;;     "$" 'polymode-show-process-buffer
;;     "n" 'polymode-eval-region-or-chunk
;;     "," 'polymode-eval-region-or-chunk
;;     "N" 'polymode-eval-buffer
;;     "1" 'polymode-eval-buffer-from-beg-to-point
;;     "0" 'polymode-eval-buffer-from-point-to-end)
;;   :config
;;   (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))


;; Templates
(use-package org-tempo
  :ensure nil
  :after org
  :config
  (let ((templates '(("sh"  . "src sh")
                     ("el"  . "src emacs-lisp")
                     ("vim" . "src vim")
                     ("cpp" . "src C++ :includes <iostream> :namespaces std"))))
    (dolist (template templates)
      (push template org-structure-template-alist))))


;; (use-package org-timeblock)

;; (use-package org-transclusion :after org)

(provide 'org-cfg)
;;; org-cfg.el ends here
