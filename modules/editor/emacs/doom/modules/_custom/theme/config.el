;;; _general/modus/config.el -*- lexical-binding: t; -*-

(setq-hook! (dired-mode org-mode treemacs-mode) display-line-numbers nil)

(use-package! page-break-lines
  :hook (doom-first-input . global-page-break-lines-mode)
  :config
  (setq page-break-lines-modes '(prog-mode
                                 org-mode
                                 org-agenda-mode
                                 latex-mode
                                 help-mode
                                 special-mode)))

(map! "C-c SPC" 'emojify-insert-emoji
      "C-x SPC" 'insert-char
      :map (global-map) [remap make-frame] #'ignore)

(use-package! spacious-padding
  :defer
  :hook (after-init . spacious-padding-mode))

(use-package! modus-themes
  :init
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
          (t . (1.1)))))


(defun +display-buffer-fallback (buffer &rest _)
  (when-let* ((win (split-window-sensibly)))
    (with-selected-window win
      (switch-to-buffer buffer)
      (help-window-setup (selected-window))))
  t)

(setq display-buffer-fallback-action
      '((display-buffer--maybe-same-window
         display-buffer-reuse-window
         display-buffer--maybe-pop-up-window
         display-buffer-in-previous-window
         display-buffer-use-some-window
         display-buffer-pop-up-window
         +display-buffer-fallback)))
(after! compile
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  (remove-hook 'compilation-filter-hook #'doom-apply-ansi-color-to-compilation-buffer-h))


