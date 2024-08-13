;;; core-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
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

(use-package diminish :after use-package) ;; if you use :diminish

(use-package font
  :ensure nil
  :demand
  :hook
  (after-init . setup-default-fonts)
  :preface
  (defun font-installed-p (font-name)
    "Check if a font with FONT-NAME is available."
    (find-font (font-spec :name font-name)))
  (defun setup-default-fonts ()
    (set-fontset-font "fontset-default" nil (font-spec :family "Noto Color Emoji"))
    (when (font-installed-p "Iosevka Aile")
      (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :height 150 :weight 'medium))
    (when (font-installed-p "VictorMono Nerd Font")
      (dolist (face '(default fixed-pitch))
        (set-face-attribute `,face nil :font "VictorMono Nerd Font" :height 150 :weight 'medium))))
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
  (backup-directory-alist           `(("\\`/tmp/" . nil)
                                    ("\\`/dev/shm/" . nil)
                                    ("." . ,backup-dir)))
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

(use-package aggressive-indent
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (cc-ts-mode . aggressive-indent-mode)))

(use-package eldoc
  :ensure nil
  :diminish eldoc-mode)

(use-package undo-fu)
(use-package undo-fu-session
  :custom
  (undo-fu-session-directory (concat user-emacs-data-directory "/undo-fu-session"))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (undo-fu-session-global-mode))

(provide 'core-cfg)
;;; core-cfg.el ends here
