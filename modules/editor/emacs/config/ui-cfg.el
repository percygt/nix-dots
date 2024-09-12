;;; ui-cfg.el --- UI setup -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (use-package dashboard
;;   :after nerd-icons
;;   :custom
;;   (dashboard-items '((recents  .  5)
;; 		     (projects .  5)
;; 		     (agenda   . 10)))
;;   (dashboard-set-footer nil)
;;   (dashboard-set-init-info t)
;;   (dashboard-center-content t)
;;   (dashboard-set-file-icons t)
;;   (dashboard-set-heading-icons t)
;;   (dashboard-startup-banner 'logo)
;;   (dashboard-projects-backend 'project-el)
;;   :config
;;   (dashboard-setup-startup-hook)
;;   (evil-set-initial-state 'dashboard-mode 'normal)
;;   (setq initial-buffer-choice (lambda ()
;; 				(get-buffer-create "*dashboard*")
;; 				(dashboard-refresh-buffer))))

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
  (org-agenda-mode . centaur-tabs-local-mode)
  (after-init . doom-modeline-mode))

(use-package centaur-tabs
  :demand
  :init
  (setq centaur-tabs-enable-key-bindings t)
  :bind ( :map evil-normal-state-map
          ("D" . centaur-tabs--kill-this-buffer-dont-ask)
          ("g l" . centaur-tabs-forward)
          ("g h" . centaur-tabs-backward))
  :custom
  ;; (centaur-tabs-height 32)
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
  (centaur-tabs-mode t)
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.
     Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
     All buffer name start with * will group to \"Emacs\".
     Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode
                              )))
       "Emacs")
      ((derived-mode-p 'prog-mode)
       "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))
  )


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

(use-package golden-ratio
  :hook (after-init . golden-ratio-mode)
  :custom
  (golden-ratio-auto-scale t)
  (golden-ratio-exclude-modes '(treemacs-mode occur-mode)))

(use-package keycast
  :defer
  :custom
  (keycast-mode-line-format "%k%c%R ")
  (keycast-substitute-alist
   '((keycast-log-erase-buffer nil nil)
     (transient-update         nil nil)
     (self-insert-command "." "Typing…")
     (org-self-insert-command "." "Typing…")
     (mwheel-scroll nil nil)
     (mouse-movement-p nil nil)
     (mouse-event-p nil nil))))

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
