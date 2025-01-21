;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;;; treesit-lang
(package! nix-ts-mode)
(package! clojure-ts-mode)

;;; eglot
(package! eglot-booster
  :recipe
  (:type git
   :host github
   :repo "jdtsmith/eglot-booster"))

;;; ui
(package! base16-theme)
(package! highlight-indent-guides)
(package! page-break-lines)
(package! spacious-padding)

;;; disabled
(package! solaire-mode :disable t)
(package! company-sourcekit :disable t)
(package! avy :disable t)
(package! smartparens-python :disable t)
(package! flycheck-plantuml :disable t)
(package! flymake-popon :disable t)
(package! lsp-mode :disable t)
(package! lsp-sourcekit :disable t)
(package! treemacs :disable t)
(package! treemacs-projectile :disable t)
(package! treemacs-evil :disable t)
(package! treemacs-magit :disable t)
(package! treemacs-nerd-icons :disable t)
(package! smartparens-python :disable t)
