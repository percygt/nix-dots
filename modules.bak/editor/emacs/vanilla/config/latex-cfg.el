;;; latex-cfg.el --- Latex -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (use-package tex-mode
;;   :ensure nil
;;   :defer t
;;   :config
;;   (setq tex-start-commands nil))

(use-package auctex
  :defer t)

(use-package latex ;; This is a weird one. Package is auctex but needs to be managed like this.
  :ensure nil
  :defer t
  :init
  (setq TeX-engine 'xetex ;; Use XeTeX
        latex-run-command "xetex")

  (setq TeX-parse-self t ; parse on load
        TeX-auto-save t  ; parse on save
        ;; Use directories in a hidden away folder for AUCTeX files.
        TeX-auto-local (concat user-emacs-directory "auctex/auto/")
        TeX-style-local (concat user-emacs-directory "auctex/style/")

        TeX-source-correlate-mode t
        TeX-source-correlate-method 'synctex

        TeX-show-compilation nil

        ;; Don't start the Emacs server when correlating sources.
        TeX-source-correlate-start-server nil

        ;; Automatically insert braces after sub/superscript in `LaTeX-math-mode'.
        TeX-electric-sub-and-superscript t
        ;; Just save, don't ask before each compilation.
        TeX-save-query nil)

  ;; To use pdfview with auctex:
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
        TeX-source-correlate-start-server t)
  :custom
  (org-latex-listings t) ;; Uses listings package for code exports
  (org-latex-compiler "xelatex") ;; XeLaTex rather than pdflatex

  :config
  ;; not sure what this is, look into it
  ;; '(org-latex-active-timestamp-format "\\texttt{%s}")
  ;; '(org-latex-inactive-timestamp-format "\\texttt{%s}")

  ;; LaTeX Classes
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("org-plain-latex" ;; I use this in base class in all of my org exports.
                   "\\documentclass{extarticle}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    )
  :general
  (local-definer
    "l"  '(nil :wk "Latex")
    "la" '(TeX-command-run-all :which-key "TeX run all")
    "lc" '(TeX-command-master :which-key "TeX-command-master")
    "le" '(LaTeX-environment :which-key "Insert environment")
    "ls" '(LaTeX-section :which-key "Insert section")
    "lm" '(TeX-insert-macro :which-key "Insert macro"))
  )

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ;; Standard way

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode)
  :config
  (setq org-latex-create-formula-image-program 'dvisvgm) ;; sharper
  (plist-put org-format-latex-options :scale 1.5) ;; bigger
  (setq org-latex-preview-ltxpng-directory (concat (temporary-file-directory) "ltxpng/"))
  )

;; (setq org-export-with-broken-links t
;;       org-export-with-smart-quotes t
;;       org-export-allow-bind-keywords t)

;; ;; From https://stackoverflow.com/questions/23297422/org-mode-timestamp-format-when-exported
;; (defun org-export-filter-timestamp-remove-brackets (timestamp backend info)
;;   "removes relevant brackets from a timestamp"
;;   (cond
;;    ((org-export-derived-backend-p backend 'latex)
;;     (replace-regexp-in-string "[<>]\\|[][]" "" timestamp))
;;    ((org-export-derived-backend-p backend 'html)
;;     (replace-regexp-in-string "&[lg]t;\\|[][]" "" timestamp))))


;; ;; HTML-specific
;; (setq org-html-validation-link nil) ;; No validation button on HTML exports

;; ;; LaTeX Specific
;; (eval-after-load 'ox '(add-to-list
;;                        'org-export-filter-timestamp-functions
;;                        'org-export-filter-timestamp-remove-brackets))

;; (use-package ox-hugo
;;   :defer 2
;;   :after ox
;;   :config
;;   (setq org-hugo-base-dir "~/Dropbox/Projects/cpb"))

;; (use-package ox-moderncv
;;   :ensure nil
;;   :init (require 'ox-moderncv))
(provide 'latex-cfg)
;;; latex-cfg.el ends here
