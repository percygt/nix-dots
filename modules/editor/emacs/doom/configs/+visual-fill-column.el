;;; +visual-fill-column.el -*- lexical-binding: t; -*-
(use-package! visual-fill-column
  :hook (org-mode . visual-line-mode)
  :config
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 100)
  (setq visual-fill-column-center-text t))
