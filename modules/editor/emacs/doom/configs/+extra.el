;;; +extra.el -*- lexical-binding: t; -*-
(use-package! simpleclip :config (simpleclip-mode 1))
(use-package! highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (set-face-foreground 'highlight-indent-guides-top-character-face "SteelBlue")
  (set-face-foreground 'highlight-indent-guides-character-face "gray20")
  :custom
  (highlight-indent-guides-auto-enabled nil)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method 'character))

(use-package! spacious-padding
  :if (display-graphic-p)
  :config
  (spacious-padding-mode))

(use-package! page-break-lines
  :hook (doom-first-input . global-page-break-lines-mode)
  :config
  (setq page-break-lines-modes '(prog-mode
                                 org-mode
                                 org-agenda-mode
                                 latex-mode
                                 help-mode
                                 special-mode)))
;; ;; ;;
;; Auto adjust window size
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)
;; Prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

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
