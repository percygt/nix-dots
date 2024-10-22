;;; +org-modern.el -*- lexical-binding: t; -*-

(use-package! org-modern
  :preface
  (defun getColor (id) (plist-get base16-nix-custom-theme-colors id))
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-todo-faces
        `(
          ("TODO"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base06))
          ("NEXT"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base07))
          ("WAIT"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0B))
          ("HOLD"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0B))
          ("DONE"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base05) :background ,(getColor :base03) :weight bold)
          ("NOTE"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base08) :background ,(getColor :base03) :weight bold)
          ("DUPE"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground "tomato" :background ,(getColor :base02))
          ("KILL"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground "tomato" :background ,(getColor :base02))
          ("DISABLED" :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground "tomato" :background ,(getColor :base02))
          ("IDEA"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base07))
          ("STUDY"    :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base09))
          ("READ"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0A))
          ("WORK"     :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0C))
          ("PROJECT"  :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0D))
          ("PEOPLE"   :inherit variable-pitch :distant-foreground ,(getColor :base05) :foreground ,(getColor :base01) :background ,(getColor :base0E))
          ))
  (setq org-modern-fold-stars '(("◉" . "○") ("▷" . "▽") ("⯈" . "⯆") ("▹" . "▿") ("▸" . "▾")))
  )
