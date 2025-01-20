;;; +org-modern.el -*- lexical-binding: t; -*-
(use-package! org-modern
  :after org
  :preface
  (defun modify-org-done-face ()
    (setq org-fontify-done-headline t)
    (set-face-attribute 'org-modern-done nil
                        :foreground "Gray15")
    (set-face-attribute 'org-headline-done nil
                        :foreground "Gray15"))
  :hook (org-mode . org-modern-mode)
  :custom-face
  (org-modern-todo ((nil (:inherit fixed-pitch :weight bold))))
  (org-modern-tag ((nil (:foreground "gray40" :background "black" :height 0.9))))
  :config
  (setq org-modern-todo-faces
        `(
          ("TODO"     :inherit org-modern-todo :foreground "lightslateblue")
          ("NEXT"     :inherit org-modern-todo :foreground "yellow")
          ("DONE"     :inherit org-modern-todo :foreground "dimgray")
          ("WAIT"     :inherit org-modern-todo :foreground "palegreen")
          ("KILL"     :inherit org-modern-todo :foreground "dimgray")
          ))

  (eval-after-load "org"
    (add-hook 'org-add-hook 'modify-org-done-face))
  )
