(use-package treemacs
  :custom
  (treemacs-is-never-other-window t)
  :hook
  (treemacs-mode . treemacs-project-follow-mode)
  :evil-bind ((:map (leader-map)
		    ("tt" . treemacs)
		    ("tf" . treemacs-find-file))))

(provide 'filetree-cfg)
