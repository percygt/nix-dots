

;;; ui-cfg.el --- UI setup -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package visual-fill-column
  :defer t
  :config
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 80)
  (setq visual-fill-column-center-text t))

(use-package writeroom-mode
  :defer t
  :config
  (setq writeroom-maximize-window nil
        writeroom-mode-line nil
        writeroom-global-effects nil ;; No need to have Writeroom do any of that silly stuff
        writeroom-extra-line-spacing 3)
  (setq writeroom-width visual-fill-column-width))

(use-package font
  :ensure nil
  :demand
  :preface
  (defun font-installed-p (font-name)
    "Check if a font with FONT-NAME is available."
    (find-font (font-spec :name font-name)))
  (defun setup-default-fonts ()
    (message "Setting faces!")
    (when (font-installed-p "VictorMono NFP Medium")
      (dolist (face '(default fixed-pitch))
	    (set-face-attribute `,face nil :font "VictorMono NFP Medium" :height 130)))
    (when (font-installed-p "Libertinus Serif")
      (set-face-attribute 'fixed-pitch-serif nil :font "Libertinus Serif"))
    (when (font-installed-p "Work Sans Light")
      (set-face-attribute 'variable-pitch nil :family "Work Sans Light" :height 1.0))
    )
  (if (daemonp)
      (add-hook 'after-make-frame-functions
		        (lambda (frame)
                  (with-selected-frame frame
                    (setup-default-fonts))))
    (setup-default-fonts))
  (provide 'font))

(use-package modus-themes
  :hook
  (server-after-make-frame . (lambda () (load-theme 'modus-vivendi-tinted t)))
  :config
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil)
  (setq modus-themes-headings
        '(
          (1 . (bold 1.3))
          (2 . (bold 1.2))
          (3 . (bold 1.1))
          (t . (bold 1.05))
          ))
  (setq modus-themes-common-palette-overrides
        '((fringe unspecified)))
  (load-theme 'modus-vivendi-tinted t))

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
  (dashboard-startup-banner (concat user-emacs-directory "/xemacs_color.svg"))
  (dashboard-projects-backend 'project-el)
  :config
  (dashboard-setup-startup-hook)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (setq initial-buffer-choice (lambda ()
				                (get-buffer-create "*dashboard*")
				                (dashboard-refresh-buffer))))


(use-package doom-modeline
  :custom
  (doom-modeline-icon t)
  :demand
  :hook
  (after-init . doom-modeline-mode))

(use-package keycast
  :commands toggle-keycast
  :config
  (defun toggle-keycast()
    (interactive)
    (if (member '("" keycast-mode-line " ") global-mode-string)
        (progn (setq global-mode-string (delete '("" keycast-mode-line " ") global-mode-string))
               (remove-hook 'pre-command-hook 'keycast--update)
               (message "Keycast OFF"))
      (add-to-list 'global-mode-string '("" keycast-mode-line " "))
      (add-hook 'pre-command-hook 'keycast--update t)
      (message "Keycast ON"))))

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font"))

;; (use-package nerd-icons-dired
;;   :hook (dired-mode . nerd-icons-dired-mode))

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
  (set-face-foreground 'highlight-indent-guides-top-character-face "SteelBlue")
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
