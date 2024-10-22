;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; See: https://github.com/radian-software/straight.el#the-recipe-format

;;; treesit-lang
(package! nix-ts-mode)

;;; eglot
(package! eglot-booster
  :recipe
  (:type git
   :host github
   :repo "jdtsmith/eglot-booster"))

;;; tools
(package! simpleclip)

;;; ui

(package! beacon)
(package! base16-theme)
(package! hide-mode-line)
(package! modus-themes)
(package! mixed-pitch)
(package! page-break-lines)
(package! spacious-padding)

;;; org
(package! org-appear)
(package! org-cliplink)
(package! org-ql)
(package! orgtbl-aggregate)
(package! page-break-lines)
(package! poporg)
(package! gnuplot)
(package! citar)
(package! all-the-icons)
(package! citar-org-roam)
(package! nursery
  :recipe (:host github :repo "chrisbarrett/nursery"
           :files ("lisp/*.el")))
(package! ox-gfm)
(package! org-modern)

;;; completion
(package! affe)

;;; extra
(package! lorem-ipsum)

;;; disbaled
;; (package! doom-themes :disable t)
(package! company-sourcekit :disable t)
(package! flycheck-plantuml :disable t)
(package! flymake-popon :disable t)
(package! lsp-mode :disable t)
(package! lsp-sourcekit :disable t)
(package! smartparens-python :disable t)

;; (package! org :built-in t)
