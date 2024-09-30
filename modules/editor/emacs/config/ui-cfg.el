;;; ui-cfg.el --- UI setup -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package dashboard
  :after (nerd-icons evil)
  :custom
  (dashboard-items '((recents  .  5)
		     (projects .  5)
		     (agenda   . 10)))
  (dashboard-set-footer nil)
  (dashboard-set-init-info t)
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-startup-banner 'logo)
  (dashboard-projects-backend 'project-el)
  :config
  (dashboard-setup-startup-hook)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (setq initial-buffer-choice (lambda ()
				(get-buffer-create "*dashboard*")
				(dashboard-refresh-buffer))))

(use-package doom-themes
  :demand
  :config
  (load-theme 'doom-moonlight t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :demand
  :hook
  (after-init . doom-modeline-mode))

(use-package centaur-tabs
  :demand
  :hook
  (org-agenda-mode . centaur-tabs-local-mode)
  (org-mode . centaur-tabs-local-mode)
  :init
  (setq centaur-tabs-enable-key-bindings t)
  :general
  (normal-definer
    ("D" 'centaur-tabs--kill-this-buffer-dont-ask)
    ("gl" 'centaur-tabs-forward)
    ("gh" 'centaur-tabs-backward))
  :custom
  (centaur-tabs-set-icons t)
  (centaur-tabs-show-new-tab-button t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-show-navigation-buttons t)
  (centaur-tabs-set-bar 'over)
  (centaur-tabs-show-count nil)
  (centaur-tabs-style "bar")
  (centaur-tabs-adjust-buffer-order t)
  (centaur-tabs-adjust-buffer-order 'left)
  (x-underline-at-descent-line t)
  (centaur-tabs-left-edge-margin nil)
  :config
  (centaur-tabs-change-fonts (face-attribute 'variable-pitch :font) 130)
  (centaur-tabs-enable-buffer-reordering)
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t))


(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font"))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package beacon ;; This applies a beacon effect to the highlighted line
  :config (beacon-mode 1))

(use-package solaire-mode
  :hook (after-init . solaire-global-mode)
  :config
  (push '(treemacs-window-background-face . solaire-default-face) solaire-mode-remap-alist)
  (push '(treemacs-hl-line-face . solaire-hl-line-face) solaire-mode-remap-alist))

(use-package hide-mode-line
  :defer
  :hook (org-mode . hide-mode-line-mode))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (set-face-foreground 'highlight-indent-guides-top-character-face "steel blue")
  (set-face-foreground 'highlight-indent-guides-character-face "gray20")
  :custom
  (highlight-indent-guides-auto-enabled  nil)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method 'character))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)

(provide 'ui-cfg)
;;; ui-cfg.el ends here
