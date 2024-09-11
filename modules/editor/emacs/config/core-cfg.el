;;; core-cfg.el --- Core Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; Vanilla config
(use-package emacs
  :ensure nil
  :demand
  :preface
  (defun indicate-buffer-boundaries-left ()
    (setq indicate-buffer-boundaries 'left))
  :custom
  (delete-by-moving-to-trash        t)
  (visible-bell                     t)
  (x-stretch-cursor                 t)
  (mouse-yank-at-point              t)
  (use-short-answers                t)
  (column-number-mode               t)
  (confirm-kill-processes           nil)
  (visible-bell                     nil)
  (fill-column                      100)
  (tab-always-indent                'complete)
  (initial-major-mode               'fundamental-mode)
  (user-emacs-directory             user-emacs-data-directory)
  (read-extended-command-predicate  #'command-completion-default-include-p)
  :hook ((prog-mode . display-fill-column-indicator-mode)
         ((prog-mode text-mode) . indicate-buffer-boundaries-left)))

(use-package emacs
  :ensure nil
  :after (evil)
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
  (define-key evil-window-map (kbd "x") nil)

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
  (define-key splitscreen/prefix (kbd "x") 'delete-window)
  (define-key splitscreen/prefix (kbd "SPC") 'balance-windows)

  (define-minor-mode splitscreen-mode
    "Provides tmux-like bindings for managing windows and buffers.
                 See https://github.com/mattduck/splitscreen"
    :init-value 1 ; enable by default
    :global 1
    :keymap splitscreen/mode-map))

(use-package diminish :after use-package) ;; if you use :diminish

(use-package font
  :ensure nil
  :demand
  :hook
  (server-after-make-frame-hook . setup-default-fonts)
  :preface
  (defun font-installed-p (font-name)
    "Check if a font with FONT-NAME is available."
    (find-font (font-spec :name font-name)))
  (defun setup-default-fonts ()
    (message "Setting faces!")
    (when (font-installed-p "Iosevka Aile")
      (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :height 150 :weight 'medium))
    (when (font-installed-p "VictorMono Nerd Font")
      (dolist (face '(default fixed-pitch))
	(set-face-attribute `,face nil :font "VictorMono Nerd Font" :height 150 :weight 'medium))))
  (if (daemonp)
      (add-hook 'after-make-frame-functions
		(lambda (frame)
                  (with-selected-frame frame
                    (setup-default-fonts))))
    (setup-default-fonts))
  (provide 'font))

(use-package display-line-numbers
  :ensure nil
  :custom
  (display-line-numbers-grow-only   t)
  (display-line-numbers-width-start t)
  (display-line-numbers-type        'relative)
  :hook (((text-mode prog-mode conf-mode) . display-line-numbers-mode)
	 (org-mode . (lambda () (display-line-numbers-mode -1)))))

(use-package no-littering
  :custom
  (no-littering-etc-directory user-emacs-data-directory)
  (no-littering-var-directory user-emacs-data-directory))

(use-package files
  :ensure nil
  :demand
  :preface
  (defvar backup-dir (no-littering-expand-var-file-name "backup")
    "Directory to store backups.")
  (defvar auto-save-dir (no-littering-expand-var-file-name "auto-save")
    "Directory to store auto-save files.")
  (defvar customfile (no-littering-expand-etc-file-name "custom.el")
    "Custom file")
  :init
  (unless (file-exists-p auto-save-dir) (make-directory auto-save-dir t))
  (unless (file-exists-p backup-dir) (make-directory backup-dir t))
  (when (file-exists-p customfile) (load customfile))
  :custom
  (create-lockfiles                 nil)
  (make-backup-files                nil)
  (backup-directory-alist           `(("\\`/tmp/" . nil)
                                      ("\\`/dev/shm/" . nil)
                                      (".*" . ,backup-dir)))
  (auto-save-file-name-transforms   `((".*" ,auto-save-dir t)))
  (custom-file                      customfile)
  (auto-save-no-message             t)
  (auto-save-interval               100)
  (require-final-newline            t)
  (backup-by-copying                t)    ; Always use copying to create backup files
  (delete-old-versions              t)    ; Delete excess backup versions
  (kept-new-versions                6)    ; Number of newest versions to keep when a new backup is made
  (kept-old-versions                2)    ; Number of oldest versions to keep when a new backup is made
  (version-control                  t)    ; Make numeric backup versions unconditionally
  (delete-by-moving-to-trash        t)    ; Move deleted files to the trash
  (mode-require-final-newline       nil)  ; Don't add newlines at the end of files
  (large-file-warning-threshold     nil)) ; Open large files without requesting confirmation

(use-package autorevert
  :ensure nil
  :defer 2
  :custom (auto-revert-verbose nil)
  :diminish auto-revert-mode)

(use-package gcmh
  :diminish gcmh-mode
  :custom
  (gcmh-mode 1)
  (gcmh-idle-delay 10)
  (gcmh-high-cons-threshold (* 32 1024 1024))
  (gc-cons-percentage 0.8))

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
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-etc-directory))
  (recentf-mode))


(use-package eldoc
  :ensure nil
  :diminish eldoc-mode)

(use-package undo-fu)
(use-package undo-fu-session
  :custom
  (undo-fu-session-directory (expand-file-name  "var/undo-fu-session/" user-emacs-data-directory))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (undo-fu-session-global-mode))

(provide 'core-cfg)
;;; core-cfg.el ends here
