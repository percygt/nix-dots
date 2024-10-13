;;; _general/extra/config.el -*- lexical-binding: t; -*-

(use-package! spacious-padding
  :defer
  :hook (after-init . spacious-padding-mode))
;;
;; (use-package! aggressive-indent
;;   :hook ((emacs-lisp-mode . aggressive-indent-mode)
;;          (cc-ts-mode . aggressive-indent-mode)))
