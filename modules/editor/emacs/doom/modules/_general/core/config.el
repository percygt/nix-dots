;;; _general/core/config.el -*- lexical-binding: t; -*-

(push '(ns-use-native-fullscreen . t) default-frame-alist)
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(ns-appearance . dark) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(mode-line-format . 0) default-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(alpha-background . 70) default-frame-alist)

(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      frame-title-format nil
      truncate-lines nil
      truncate-partial-width-windows t
      indicate-buffer-boundaries '((bottom . right))
      inhibit-splash-screen t
      inhibit-startup-buffer-menu t
      initial-major-mode 'fundamental-mode
      load-prefer-newer noninteractive
      auto-mode-case-fold nil
      fringes-outside-margins nil
      indicate-buffer-boundaries nil ;; Otherwise shows a corner icon on the edge
      indicate-empty-lines nil ;; Otherwise there are weird fringes on blank lines
      line-spacing                          2
      initial-scratch-message               nil
      inhibit-startup-screen                t ;; Don't show the welcome splash screen.
      tab-width                             4 ;; Set tab-size to 4 spaces
      delete-by-moving-to-trash             t
      visible-bell                          t
      x-stretch-cursor                      t
      mouse-yank-at-point                   t
      use-short-answers                     t
      column-number-mode                    t
      indent-tabs-mode                      nil ;; Always indent with spaces
      even-window-sizes                     nil
      confirm-kill-processes                nil
      fill-column                           100
      tab-always-indent                     'complete
      large-file-warning-threshold          nil
      byte-compile-warnings                 '(ck-functions)
      cursor-in-non-selected-windows        nil
      completion-cycle-threshold            3
      completion-ignore-case                t
      read-buffer-completion-ignore-case    t
      read-file-name-completion-ignore-case t
      max-lisp-eval-depth                   10000
      scroll-margin                         0
      fast-but-imprecise-scrolling          t
      scroll-preserve-screen-position       t
      debug-on-error                        nil
      auto-window-vscroll                   nil
      warning-minimum-level                 :emergency
      ad-redefinition-action                'accept
      auto-revert-check-vc-info             t
      echo-keystrokes                       0.2
      font-lock-maximum-decoration          t
      highlight-nonselected-windows         t
      kill-buffer-query-functions           nil ;; Dont ask for closing spawned processes
      use-dialog-box                        nil
      word-wrap                             nil
      auto-mode-case-fold                   nil
      undo-limit                            (* 16 1024 1024) ;; 64mb
      undo-strong-limit                     (* 24 1024 1024) ;; x 1.5 (96mb)
      undo-outer-limit                      (* 24 1024 1024) ;; x 10 (960mb), (Emacs uses x100), but this seems too high.
      text-mode-ispell-word-completion      nil
      read-extended-command-predicate       #'command-completion-default-include-p)
