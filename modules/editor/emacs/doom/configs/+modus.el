;;; +modus.el -*- lexical-binding: t; -*-
(use-package! modus-themes
  :config
  (setq modus-themes-bold-constructs t)
  (setq modus-themes-italic-constructs nil)
  (setq modus-themes-mixed-fonts t)
  ;; (setq modus-vivendi-palette-overrides
  ;;       '((bg-main "#222222")))
  (setq modus-themes-headings
        '((0 . (variable-pitch 1.8))
          (1 . (1.5))
          (2 . (1.3))
          (3 . (1.2))
          (agenda-date . (1.3))
          (agenda-structure . (variable-pitch light 1.8))
          (t . (1.1))))
  )
