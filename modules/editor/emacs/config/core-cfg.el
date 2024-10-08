;;; core-cfg.el --- Core Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defvar user-emacs-data-directory
  (concat (getenv "XDG_DATA_HOME") "/emacs")
  "Emacs local home directory.")
(defvar user-emacs-cache-directory
  (concat (getenv "XDG_CACHE_HOME") "/emacs")
  "Home directory.")
(defvar notes-directory
  (concat (getenv "HOME") "/data/notes")
  "My notes.")

;; Vanilla config
(use-package emacs
  :ensure nil
  :preface
  (defun indicate-buffer-boundaries-left ()
    (setq indicate-buffer-boundaries 'left))
  :custom
  (initial-scratch-message               nil)
  (inhibit-startup-screen                t) ;; Don't show the welcome splash screen.
  (tab-width                             4) ;; Set tab-size to 4 spaces
  (delete-by-moving-to-trash             t)
  (visible-bell                          t)
  (x-stretch-cursor                      t)
  (mouse-yank-at-point                   t)
  (use-short-answers                     t)
  (column-number-mode                    t)
  (indent-tabs-mode                      nil) ;; Always indent with spaces
  (even-window-sizes                     nil)
  (confirm-kill-processes                nil)
  (fill-column                           100)
  (tab-always-indent                     'complete)
  (large-file-warning-threshold          nil)
  (byte-compile-warnings                 '(ck-functions))
  (cursor-in-non-selected-windows        nil)
  (completion-cycle-threshold            3)
  (completion-ignore-case                t)
  (read-buffer-completion-ignore-case    t)
  (read-file-name-completion-ignore-case t)
  (max-lisp-eval-depth                   10000)
  (scroll-margin                         0)
  (fast-but-imprecise-scrolling          t)
  (scroll-preserve-screen-position       t)
  (debug-on-error                        nil)
  (auto-window-vscroll                   nil)
  (warning-minimum-level                 :emergency)
  (ad-redefinition-action                'accept)
  (auto-revert-check-vc-info             t)
  (echo-keystrokes                       0.2)
  (font-lock-maximum-decoration          t)
  (highlight-nonselected-windows         t)
  (kill-buffer-query-functions           nil) ;; Dont ask for closing spawned processes
  (use-dialog-box                        nil)
  (word-wrap                             nil)
  (auto-mode-case-fold                   nil)
  (undo-limit                            (* 16 1024 1024)) ;; 64mb
  (undo-strong-limit                     (* 24 1024 1024)) ;; x 1.5 (96mb)
  (undo-outer-limit                      (* 24 1024 1024)) ;; x 10 (960mb), (Emacs uses x100), but this seems too high.
  (jit-lock-defer-time                   0)
  (text-mode-ispell-word-completion      nil)
  (read-extended-command-predicate       #'command-completion-default-include-p)
  :hook ((prog-mode . display-fill-column-indicator-mode)
         ((prog-mode text-mode) . indicate-buffer-boundaries-left)))

(use-package no-littering
  :demand
  :init
  (setq no-littering-etc-directory user-emacs-data-directory)
  (setq no-littering-var-directory user-emacs-cache-directory)
  (no-littering-theme-backups))


(use-package files
  :ensure nil
  :preface
  (defvar files/common (expand-file-name "common.el" user-emacs-directory)
    "Common file.")
  (defvar files/private (expand-file-name "private.el" user-emacs-directory)
    "Private file.")
  (defvar files/custom (expand-file-name "custom.el" user-emacs-directory)
    "Custom file.")
  :init
  (when (file-exists-p files/common) (load files/common))
  (when (file-exists-p files/private) (load files/private))
  (when (file-exists-p files/custom) (load files/custom))
  :config
  (global-hl-line-mode 1)           ; Highlight the current line to make it more visible
  :custom
  (create-lockfiles                 nil)
  (make-backup-files                nil)
  (custom-file                      files/custom)
  (auto-save-no-message             t)
  (auto-save-interval               100)
  (find-file-visit-truename          t)
  (backup-by-copying                t)    ; Always use copying to create backup files
  (delete-old-versions              t)    ; Delete excess backup versions
  (kept-new-versions                6)    ; Number of newest versions to keep when a new backup is made
  (kept-old-versions                2)    ; Number of oldest versions to keep when a new backup is made
  (version-control                  t)    ; Make numeric backup versions unconditionally
  (delete-by-moving-to-trash        t)    ; Move deleted files to the trash
  (mode-require-final-newline       nil))  ; Don't add newlines at the end of files

(use-package window
  :ensure nil
  :after (evil)
  :bind
  :custom
  (display-buffer-alist
   '(("\\*Async Shell Command\\*"
      (display-buffer-no-window))
     ("\\*Faces\\|[Hh]elp\\*"
      (display-buffer-in-side-window)
      (body-function . select-window)
      (window-width . 0.4)
      (side . right)
      (slot . 1))
     ("\\*e?shell\\|*ellama\\|\\*vterm\\*"
      (display-buffer-in-side-window)
      (body-function . select-window)
      (window-height . 0.13)
      (window-parameters . ((mode-line-format . none)))
      (side . bottom)
      (slot . 10))
     ("\\*Flycheck\\|[Cc]olors\\*\\|Warnings"
      (display-buffer-in-side-window display-buffer-reuse-window)
      (body-function . select-window)
      (display-buffer-at-bottom)
      (window-height . 0.15)
      (side . bottom)
      (slot . 3))))
  :init
  (defvar splitscreen/mode-map (make-sparse-keymap))
  (define-prefix-command 'splitscreen/prefix)
  (define-key splitscreen/mode-map (kbd "C-w") 'splitscreen/prefix)

  (defun splitscreen/window-left () (interactive) (evil-window-left 1))
  (defun splitscreen/window-right () (interactive) (evil-window-right 1))
  (defun splitscreen/window-up () (interactive) (evil-window-up 1))
  (defun splitscreen/window-down () (interactive) (evil-window-down 1))

  (defun splitscreen/increase-width () (interactive) (evil-window-increase-width 10))
  (defun splitscreen/decrease-width () (interactive) (evil-window-decrease-width 10))
  (defun splitscreen/increase-height () (interactive) (evil-window-increase-height 10))
  (defun splitscreen/decrease-height () (interactive) (evil-window-decrease-height 10))

  ;; We override these. Just declare them as part of the splitscreen map, not
  ;; evil-window-map.
  (define-key evil-window-map (kbd "h") nil)
  (define-key evil-window-map (kbd "j") nil)
  (define-key evil-window-map (kbd "k") nil)
  (define-key evil-window-map (kbd "l") nil)
  (define-key evil-window-map (kbd "n") nil)
  (define-key evil-window-map (kbd "p") nil)
  (define-key evil-window-map (kbd "c") nil)
  (define-key evil-window-map (kbd "C-h") nil)
  (define-key evil-window-map (kbd "C-j") nil)
  (define-key evil-window-map (kbd "C-k") nil)
  (define-key evil-window-map (kbd "C-l") nil)
  (define-key evil-window-map (kbd "l") nil)
  (define-key evil-window-map (kbd "o") nil)
  (define-key evil-window-map (kbd "v") nil)
  (define-key evil-window-map (kbd "s") nil)
  (define-key evil-window-map (kbd "q") nil)
  (define-key evil-window-map (kbd "w") nil)

  (define-key splitscreen/prefix (kbd "h") 'splitscreen/window-left)
  (define-key splitscreen/prefix (kbd "j") 'splitscreen/window-down)
  (define-key splitscreen/prefix (kbd "k") 'splitscreen/window-up)
  (define-key splitscreen/prefix (kbd "l") 'splitscreen/window-right)

  (define-key splitscreen/prefix (kbd "C-h") 'splitscreen/decrease-width)
  (define-key splitscreen/prefix (kbd "C-j") 'splitscreen/decrease-height)
  (define-key splitscreen/prefix (kbd "C-k") 'splitscreen/increase-height)
  (define-key splitscreen/prefix (kbd "C-l") 'splitscreen/increase-width)
  (define-key splitscreen/prefix (kbd "s-h") 'splitscreen/decrease-width)
  (define-key splitscreen/prefix (kbd "s-j") 'splitscreen/decrease-height)
  (define-key splitscreen/prefix (kbd "s-k") 'splitscreen/increase-height)
  (define-key splitscreen/prefix (kbd "s-l") 'splitscreen/increase-width)

  (define-key splitscreen/prefix (kbd "v") 'split-window-right)
  (define-key splitscreen/prefix (kbd "s") 'split-window-below)
  (define-key splitscreen/prefix (kbd "q") 'delete-window)
  (define-key splitscreen/prefix (kbd "w") 'window-toggle-side-windows)
  (define-key splitscreen/prefix (kbd "Q") 'kill-buffer-and-window)
  (define-key splitscreen/prefix (kbd "SPC") 'balance-windows)

  (define-minor-mode splitscreen-mode
    "Provides tmux-like bindings for managing windows and buffers.
                 See https://github.com/mattduck/splitscreen"
    :init-value 1 ; enable by default
    :global 1
    :keymap splitscreen/mode-map))

(use-package diminish :after use-package) ;; if you use :diminish

(use-package display-line-numbers
  :ensure nil
  :custom
  (display-line-numbers-grow-only   t)
  (display-line-numbers-width-start t)
  (display-line-numbers-type        'relative)
  :hook (((text-mode prog-mode conf-mode) . display-line-numbers-mode)
	     (org-mode . (lambda () (display-line-numbers-mode -1)))))


(use-package autorevert
  :ensure nil
  :defer 2
  :custom (auto-revert-verbose nil)
  :diminish auto-revert-mode)

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package recentf
  :ensure nil
  :defer 2
  :custom
  (recentf-max-saved-items 1000)
  (recentf-exclude `("/tmp/" "/ssh:" "/nix/store"
		             ,(concat user-emacs-data-directory "lib/.*-autoloads\\.el\\'")))
  :config
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-etc-directory))
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-var-directory))
  (recentf-mode))

(use-package eldoc
  :ensure nil
  :diminish eldoc-mode)

(use-package undo-fu
  :after evil
  :config
  (setq undo-fu-allow-undo-in-region t))

(use-package undo-fu-session
  :hook (after-init . undo-fu-session-global-mode)
  :custom
  (undo-fu-session-directory (expand-file-name  "undo-fu-session/" user-emacs-data-directory))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(provide 'core-cfg)
;;; core-cfg.el ends here
