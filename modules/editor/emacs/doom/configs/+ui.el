;;; +ui.el -*- lexical-binding: t; -*-

(setq doom-theme 'base16-nix-custom
      doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(use-package! base16-theme)
(custom-theme-set-faces! 'base16-nix-custom
  `(font-lock-comment-delimiter-face :foreground "DarkGrey" :slant italic)
  `(font-lock-comment-face :foreground "DarkGrey" :slant italic)
  `(show-paren-match :foreground "yellow" :bold t)
  )

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
