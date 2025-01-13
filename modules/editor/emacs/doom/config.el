;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir t)
(load! "nix" doom-user-dir t)

(add-to-list 'term-file-aliases '("foot" . "xterm"))

(setq doom-theme 'doom-city-lights
      doom-font (font-spec :family "VictorMono NFP" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 20 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(setq evil-emacs-state-cursor   `("white" bar)
      evil-insert-state-cursor  `("Cyan" bar)
      evil-normal-state-cursor  `("white" box)
      evil-visual-state-cursor  `("PaleGoldenrod" box))


(if (display-graphic-p)
    (custom-theme-set-faces! 'doom-city-lights `(default :background "#00051a")
      (set-frame-parameter nil 'alpha-background 80) ; For current frame
      (add-to-list 'default-frame-alist '(alpha-background . 80)) )
  (custom-theme-set-faces! 'doom-city-lights `(default :background nil)))

(custom-set-faces!
  `(mode-line-inactive :background "#00051a")
  `(fringe :background nil)
  `(vertical-border :background "#081028")
  `(line-number :background nil)
  `(mode-line-active :background "#081028")
  `(hl-line :background "#081028")
  `(header-line :background "#081028")
  `(org-modern-tag :foreground "gray40" :background "black" :height 0.9))

(setq shell-file-name (executable-find "nu"))
(setq display-line-numbers-type 'relative)
(setq confirm-kill-emacs nil)
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)
(global-subword-mode 1)                           ; Iterate through CamelCase words
(pixel-scroll-precision-mode t)
(plist-put +popup-defaults :quit t)

(load! "configs/init.el")

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
