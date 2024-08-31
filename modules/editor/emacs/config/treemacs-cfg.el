(use-package neotree
  :ensure t
  :bind ("<leader>0" . neotree-toggle)
  :custom
  (neo-theme 'icons)
  (neo-smart-open t)
  (neo-autorefresh t)
  (neo-window-width 40) ;; Around ~12% of screen space on my ultra wide
  ;; takes too long to update on first try
  ;; (neo-vc-integration '(face char))
  (neo-show-hidden-files t))
