;;; +ui.el -*- lexical-binding: t; -*-

(setq doom-theme 'base16-tokyo-city-dark
      doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

;; (defvar p67/base16-colors base16-tokyo-city-dark-theme-colors)

;; (setq evil-emacs-state-cursor   `(,(plist-get p67/base16-colors :base0D) box)
;;       evil-insert-state-cursor  `(,(plist-get p67/base16-colors :base0D) bar)
;;       evil-motion-state-cursor  `(,(plist-get p67/base16-colors :base0E) box)
;;       evil-normal-state-cursor  `(,(plist-get p67/base16-colors :base05) box)
;;       evil-replace-state-cursor `(,(plist-get p67/base16-colors :base08) bar)
;;       evil-visual-state-cursor  `(,(plist-get p67/base16-colors :base09) box))


(defvar base16-syft-theme-colors
  '(:base00 "#00051a"
    :base01 "#081028"
    :base02 "#08103a"
    :base03 "#292538"
    :base04 "#6e738d"
    :base05 "#71e3d1"
    :base06 "#fffae5"
    :base07 "#939ab7"
    :base08 "#4e2a1b"
    :base09 "#f1a573"
    :base0A "#f9e2af"
    :base0B "#439448"
    :base0C "#81c8be"
    :base0D "#8caaee"
    :base0E "#d279ff"
    :base0F "#3f0a0a")
  "All colors for Base16 Syft are defined here.")
(defvar base16-tokyo-city-dark-theme-colors
  '(:base00 "#171d23"
    :base01 "#1d252c"
    :base02 "#28323a"
    :base03 "#526270"
    :base04 "#b7c5d3"
    :base05 "#d8e2ec"
    :base06 "#f6f6f8"
    :base07 "#fbfbfd"
    :base08 "#f7768e"
    :base09 "#ff9e64"
    :base0A "#b7c5d3"
    :base0B "#9ece6a"
    :base0C "#89ddff"
    :base0D "#7aa2f7"
    :base0E "#bb9af7"
    :base0F "#bb9af7")
  "All colors for Base16 Tokyo City Dark are defined here.")

(defun p67/base16-colors (id)
  (plist-get base16-syft-theme-colors id))
;; (add-to-list 'default-frame-alist '(background-color . (p67/base16-colors :base00)))
(custom-set-faces!
  `(default :background ,(p67/base16-colors ':base00) :foreground ,(p67/base16-colors ':base05))
  `(gui-element :background ,(p67/base16-colors ':base01))
  `(doom-modeline-bar :background ,(p67/base16-colors ':base0D))
  `(mode-line :background ,(p67/base16-colors ':base02))
  `(mode-line-inactive :background ,(p67/base16-colors ':base01))
  )


(use-package! base16-theme)

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
(push '(alpha-background . 70) default-frame-alist)
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
