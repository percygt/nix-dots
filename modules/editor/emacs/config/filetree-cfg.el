(use-package treemacs
  :after (evil)
  :custom
  (treemacs-is-never-other-window t)
  :hook
  (treemacs-mode . treemacs-project-follow-mode)
  :general
  (global-definer
        "t" '(nil :which-key "Treemacs")
		    "tt" 'treemacs
		    "tf" 'treemacs-find-file
    ))

(provide 'filetree-cfg)
