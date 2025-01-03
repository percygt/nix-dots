;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir t)
(load! "nix" doom-user-dir t)
(load! "configs/init.el")

(setq doom-theme 'base16-tokyo-city-dark
      doom-font (font-spec :family "VictorMono NFP" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 20 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(defun set-background-for-terminal (&optional frame)
  (or frame (setq frame (selected-frame)))
  "unsets the background color in terminal mode"
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'set-background-for-terminal)
(add-hook 'window-setup-hook 'set-background-for-terminal)

(setq shell-file-name (executable-find "bash"))
(setq display-line-numbers-type 'relative)
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)
(global-subword-mode 1)                           ; Iterate through CamelCase words
(pixel-scroll-precision-mode t)
(plist-put +popup-defaults :quit t)

(pushnew! vc-directory-exclusion-list
          "node_modules"
          "cdk.out"
          "target"
          ".direnv")

(pushnew! completion-ignored-extensions
          ".DS_Store"
          ".eln"
          ".drv"
          ".direnv/"
          ".git/")
