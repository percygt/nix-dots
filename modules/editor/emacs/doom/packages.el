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
(package! writeroom-mode)
(package! highlight-indent-guides)
(package! page-break-lines)
(package! spacious-padding)

;;; org
(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "5cab660dab653ad88c07b0493360252f6ed1d898")
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
