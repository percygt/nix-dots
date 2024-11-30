;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir t)
(load! "nix" doom-user-dir t)
(load! "configs/init.el")

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
