;;; org-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package org-roam
  :config
  (org-roam-setup)
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory notes-directory)
  (org-roam-dailies-directory "journals/")
  (org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$")
  (org-roam-capture-templates
   `(("s" "standard" plain "%?"
      :if-new
      (file+head
       "%<%Y%m%d_%H%M%S>_${slug}.org"
       "#+title: ${title}\n
        #+date: %<%Y-%m-%d>\n
        #+filetags: \n\n "
       )
      :unnarrowed t)
     ("d" "definition" plain "%?"
      :if-new
      (file+head
       "${slug}.org"
       "#+title: ${title}\n
        #+filetags: definition \n\n
        * Definition\n\n\n
        * Examples\n")
      :unnarrowed t)
     ("r" "ref" plain "%?"
      :if-new
      (file+head
       "${citekey}.org"
       "#+title: ${slug}: ${title}\n\n
        #+filetags: reference ${keywords} \n\n* ${title}\n\n\n* Summary\n\n\n* Rough note space\n")
      :unnarrowed t)
     ("p" "person" plain "%?"
      :if-new
      (file+head
       "${slug}.org"
       "%^{relation|some guy|family|friend|colleague}p %^{birthday}p %^{address}p#+title:${slug}\n#+filetags: :person: \n"
       :unnarrowed t))))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head
	       "%<%Y-%m-%d>.org"
	       "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-mode-sections '(org-roam-backlinks-section
                            org-roam-reflinks-section
                            org-roam-unlinked-references-section))
  :bind (:map evil-normal-state-map
	      ;; ("<leader>ob" . org-roam-buffer-toggle)
	      ;; ("<leader>of" . org-roam-node-find)
	      ;; ("<leader>og" . org-roam-graph)
	      ("<leader>l" . org-roam-node-insert)
	      ("<leader>c" . org-roam-capture)
	      ;; Dailies
	      ("<leader>d" . org-roam-dailies-capture-today)))

(use-package org
  :ensure nil
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
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-ellipsis " ")
  (org-hide-emphasis-markers t)
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
  (org-startup-folded nil)
  (org-cycle-separator-lines 2)
  (org-hide-leading-stars t)
  (org-highlight-latex-and-related '(native))
  (org-goto-auto-isearch nil)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-todo-keywords '((sequence "TODO(t)" "IDEA(i)" "DOING(n!)" "START(s!)" "HOLD(h!)" "|" "DONE(d!)" "KILL(k!)")))
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
  (org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(use-package evil-org
  :diminish evil-org-mode
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda () (evil-org-set-key-theme))))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

(use-package org-roam-review
  :commands (org-roam-review
             org-roam-review-list-by-maturity
             org-roam-review-list-recently-added)

  ;; ;; Optional - tag all newly-created notes as seedlings.
  ;; :hook (org-roam-capture-new-node . org-roam-review-set-seedling)

  ;; ;; Optional - keybindings for applying Evergreen note properties.
  ;; :general
  ;; (:keymaps 'org-mode-map
  ;; "C-c r r" '(org-roam-review-accept :wk "accept")
  ;; "C-c r u" '(org-roam-review-bury :wk "bury")
  ;; "C-c r x" '(org-roam-review-set-excluded :wk "set excluded")
  ;; "C-c r b" '(org-roam-review-set-budding :wk "set budding")
  ;; "C-c r s" '(org-roam-review-set-seedling :wk "set seedling")
  ;; "C-c r e" '(org-roam-review-set-evergreen :wk "set evergreen"))

  ;; ;; Optional - bindings for evil-mode compatability.
  ;; :general
  ;; (:states '(normal) :keymaps 'org-roam-review-mode-map
  ;; "TAB" 'magit-section-cycle
  ;; "g r" 'org-roam-review-refresh)
  )

(use-package org-roam-search
  :commands (org-roam-search))

(use-package org-roam-links
  :commands (org-roam-links))

(use-package org-roam-dblocks
  :hook (org-mode . org-roam-dblocks-autoupdate-mode))

(use-package org-roam-rewrite
  :commands (org-roam-rewrite-rename
             org-roam-rewrite-remove
             org-roam-rewrite-inline
             org-roam-rewrite-extract))

(use-package org-roam-slipbox
  :after org-roam
  :demand t
  :config
  (org-roam-slipbox-buffer-identification-mode +1)
  (org-roam-slipbox-tag-mode +1))

(use-package org-modern
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

(use-package org-brain
  :custom
  (org-brain-path notes-directory)
  (org-brain-visualize-default-choices 'all)
  (org-brain-title-max-length 12)
  (org-brain-include-file-entries nil)
  (org-brain-file-entries-use-title nil)
  ;; For Evil users
  :init
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (bind-key "C-c b" 'org-brain-prefix-map org-mode-map))
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


(use-package org-timeblock)

;; (use-package org-super-agenda)

;; (use-package org-transclusion :after org)

;; (use-package org-ql)


(provide 'org-cfg)
;;; org-cfg.el ends here
