;;; +ui.el -*- lexical-binding: t; -*-

(use-package! base16-theme)

(setq evil-emacs-state-cursor   `("white" bar)
      evil-insert-state-cursor  `("Cyan" bar)
      evil-normal-state-cursor  `("white" box)
      evil-visual-state-cursor  `("PaleGoldenrod" box))

; (custom-theme-set-faces! 'base16-nix-custom
;   `(font-lock-comment-delimiter-face :foreground "DarkGrey" :slant italic)
;   `(font-lock-comment-face :foreground "DarkGrey" :slant italic)
;   `(show-paren-match :foreground "yellow" :bold t)
;   `(org-block-begin-line :inherit fixed-pitch :height 0.8 :slant italic :background "unspecified")
;   )

(use-package! highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (set-face-foreground 'highlight-indent-guides-top-character-face "SteelBlue")
  (set-face-foreground 'highlight-indent-guides-character-face "gray20")
  :custom
  (highlight-indent-guides-auto-enabled nil)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method 'character))

(use-package! beacon
  :config (beacon-mode 1))

(use-package! spacious-padding
  :hook (doom-after-init . spacious-padding-mode))

(use-package! page-break-lines
  :hook (doom-first-input . global-page-break-lines-mode)
  :config
  (setq page-break-lines-modes '(prog-mode
                                 org-mode
                                 org-agenda-mode
                                 latex-mode
                                 help-mode
                                 special-mode)))
;;
;; Auto adjust window size
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)
;;
;; Transparent background
(push '(alpha-background . 80) default-frame-alist)
;;
;; Prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(setq-hook! (dired-mode org-mode treemacs-mode) display-line-numbers nil)


(map! "C-c SPC" 'emojify-insert-emoji
      "C-x SPC" 'insert-char
      :map (global-map) [remap make-frame] #'ignore)

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
