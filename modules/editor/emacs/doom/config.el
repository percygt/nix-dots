;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir)
(load! "nix" doom-user-dir)

(setq shell-file-name (executable-find "bash"))
(setq display-line-numbers-type 'relative)
;; do both in `lisp-interaction-mode'.
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

;; Local leader keys
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      scroll-preserve-screen-position 'always
      )

(global-subword-mode 1)                           ; Iterate through CamelCase words
(pixel-scroll-precision-mode t)

(plist-put +popup-defaults :quit t)

(map! :mn "WW" #'save-buffer
      :mn "D" #'doom/save-and-kill-buffer
      :mn "M-<backspace>" #'doom/kill-buried-buffers)

(map! :leader
      :desc "Load config files" "l" #'load-file
      :desc "Switch to recent buffer" "." #'(lambda ()
                                              (interactive)
                                              (switch-to-buffer (other-buffer (current-buffer))))
      :desc "Open buffer menu" "," #'switch-to-buffer
      :desc "Files" "f" #'dirvish)

(map! :leader
      "r" #'org-roam-review)

(load! "configs/+evil.el")
(load! "configs/+ui.el")
(load! "configs/+modus.el")
(load! "configs/+dired.el")
(load! "configs/+completion.el")
(load! "configs/+minibuffer.el")
(load! "configs/+treesit.el")
(load! "configs/+treesit-lang.el")
(load! "configs/+eglot.el")
(load! "configs/+org.el")
(load! "configs/+org-agenda.el")
(load! "configs/+org-modern.el")
(load! "configs/+org-roam.el")

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
