(use-package! org-gtd
  :after (org org-ql)
  :init
  (setq org-gtd-directory org-directory)
  (setq org-gtd-process-item-hooks '(org-set-tags-command))
  (setq org-gtd-inbox "GTD")
  (setq org-edna-use-inheritance t)
  (org-edna-mode 1)
  )
