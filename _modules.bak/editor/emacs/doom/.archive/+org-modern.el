;;; +org-modern.el -*- lexical-binding: t; -*-

(use-package! org-modern
  :preface
  (defun getColor (id) (plist-get base24-nix-custom-theme-colors id))
  (defun modify-org-done-face ()
    (setq org-fontify-done-headline t)
    (set-face-attribute 'org-modern-done nil
                        :foreground "Gray15")
    (set-face-attribute 'org-headline-done nil
                        :foreground "Gray15"))
  :hook (org-mode . org-modern-mode)
  :custom-face
  (org-modern-todo ((nil (:inherit fixed-pitch :weight bold))))
  :config
  (setq org-modern-todo-faces
        `(
          ("TODO"     :inherit org-modern-todo :foreground ,(getColor :base0A))
          ("NEXT"     :inherit org-modern-todo :foreground ,(getColor :base0B))
          ("DONE"     :inherit org-modern-todo :foreground "Gray15")
          ("WAIT"     :inherit org-modern-todo :foreground ,(getColor :base0C))
          ("HOLD"     :inherit org-modern-todo :foreground ,(getColor :base0D))
          ("KILL"     :inherit org-modern-todo :foreground "Gray15")
          ("IDEA"     :inherit org-modern-todo :foreground ,(getColor :base08))
          ("NOTE"     :inherit org-modern-todo :foreground ,(getColor :base09))
          ("STUDY"    :inherit org-modern-todo :foreground ,(getColor :base0A))
          ("READ"     :inherit org-modern-todo :foreground ,(getColor :base0B))
          ("WORK"     :inherit org-modern-todo :foreground ,(getColor :base0C))
          ("PROJECT"  :inherit org-modern-todo :foreground ,(getColor :base0D))
          ("PEOPLE"   :inherit org-modern-todo :foreground ,(getColor :base0E))
          ("DISABLED" :inherit org-modern-todo :foreground ,(getColor :base02))
          ))

  (eval-after-load "org"
    (add-hook 'org-add-hook 'modify-org-done-face))
  )
