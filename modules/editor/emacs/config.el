;;; init.el --- My config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Define XDG directories
(defvar user-emacs-config-directory
  (concat (getenv "XDG_CONFIG_HOME") "/emacs"))

(defvar user-emacs-data-directory
  (concat (getenv "XDG_DATA_HOME") "/emacs"))

(defvar user-emacs-cache-directory
  (concat (getenv "XDG_CACHE_HOME") "/emacs"))

;; (add-to-list 'load-path (concat user-emacs-config-directory "/modules"))

(package-initialize)

;;;
;;; Set font
;;;
(use-package fontset
  :ensure nil
  :config
  (set-face-attribute 'default nil :family "VictorMono Nerd Font")
  (set-face-attribute 'default nil :height 150)
  (set-fontset-font "fontset-default" nil (font-spec :family "Noto Color Emoji")))

(use-package emacs
  :custom
  (delete-by-moving-to-trash        t)
  (visible-bell                     t)
  (x-stretch-cursor                 t)
  (mouse-yank-at-point              t)
  (use-short-answers                t)
  (column-number-mode               t)
  (display-line-numbers-grow-only   t)
  (display-line-numbers-width-start t)
  (confirm-kill-processes           nil)
  (site-run-file                    nil)
  (text-mode-ispell-word-completion nil)
  (visible-bell                     nil)
  (fill-column                      80)
  (ring-bell-function               'flash-mode-line)
  (display-line-numbers-type        'relative)
  (tab-always-indent                'complete)
  (initial-major-mode               'fundamental-mode)
  (user-emacs-directory             user-emacs-data-directory)
  (read-extended-command-predicate  #'command-completion-default-include-p)
  :hook ((prog-mode . display-fill-column-indicator-mode)
         ((prog-mode text-mode) . display-line-numbers-mode)
         ((prog-mode text-mode) . indicate-buffer-boundaries-left)
         (after-init . auto-save-visited-mode))
  :config
  (defun flash-mode-line ()
    (invert-face 'mode-line)
    (run-with-timer 0.1 nil #'invert-face 'mode-line))
  (defun indicate-buffer-boundaries-left ()
    (setq indicate-buffer-boundaries 'left)))


(use-package no-littering
  :custom
  (no-littering-etc-directory user-emacs-data-directory)
  (no-littering-var-directory user-emacs-data-directory)
  :config
  ;; Set the custom-file to a file that won't be tracked by Git
  (setq custom-file (if (boundp 'server-socket-dir)
			(expand-file-name "custom.el" server-socket-dir)
		      (no-littering-expand-etc-file-name "custom.el")))
  (when (file-exists-p custom-file)
    (load custom-file t))

  ;; Don't litter project folders with backup files
  (let ((backup-dir (no-littering-expand-var-file-name "backup/")))
    (make-directory backup-dir t)
    (setq backup-directory-alist
          `(("\\`/tmp/" . nil)
            ("\\`/dev/shm/" . nil)
            ("." . ,backup-dir))))

  (setq auto-save-default nil)

  ;; Tidy up auto-save files
  (setq auto-save-default nil)
  (let ((auto-save-dir (no-littering-expand-var-file-name "auto-save/")))
    (make-directory auto-save-dir t)
    (setq auto-save-file-name-transforms
          `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
             ,(concat temporary-file-directory "\\2") t)
            ("\\`\\(/tmp\\|/dev/shm\\)\\([^/]*/\\)*\\(.*\\)\\'" "\\3")
            ("." ,auto-save-dir t)))))

(use-package diminish :after use-package) ;; if you use :diminish

(use-package gcmh
  :diminish gcmh-mode
  :custom
  (gcmh-mode 1)
  (gcmh-idle-delay 10)
  (gcmh-high-cons-threshold (* 32 1024 1024))
  (gc-cons-percentage 0.8))

(use-package savehist
  :custom (savehist-additional-variables
           '(last-kbd-macro
             register-alist
             (comint-input-ring        . 50)
             (dired-regexp-history     . 20)
             (face-name-history        . 20)
             (kill-ring                . 20)
             (regexp-search-ring       . 20)
             (search-ring              . 20)))
  :config (savehist-mode))

(use-package recentf
  :ensure nil
  :defer 2
  :custom
  (recentf-max-saved-items 1000)
  (recentf-exclude `("/tmp/" "/ssh:" "/nix/store/" ,(concat user-emacs-data-directory "lib/.*-autoloads\\.el\\'")))
  :config
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-etc-directory))
  (recentf-mode))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (cc-ts-mode . aggressive-indent-mode)))

(use-package autorevert
  :ensure nil
  :defer 2
  :custom (auto-revert-verbose nil)
  :diminish auto-revert-mode)

(use-package eldoc
  :ensure nil
  :diminish eldoc-mode)

(use-package project
  :ensure nil)

(use-package beframe
  :bind ("<leader>b" . beframe-prefix-map)
  :config
  (beframe-mode 1))

;;;
;;; Vim Bindings
;;;
(use-package bs :ensure nil)
(use-package evil
  :init
  (setq evil-want-keybinding     nil)
  (setq evil-emacs-state-cursor  '("white" box))
  (setq evil-normal-state-cursor '("cyan" box))
  (setq evil-visual-state-cursor '("pale goldenrod" box))
  (setq evil-insert-state-cursor '("yellow" bar))
  :custom
  (evil-want-fine-undo           t)
  (evil-respect-visual-line-mode t)
  (evil-want-C-u-scroll          t)
  (evil-want-C-i-jump            nil)
  (evil-search-module            'evil-search)
  (evil-undo-system              'undo-redo)
  (evil-split-window-right       t)
  (evil-split-window-below       t)
  (evil-want-Y-yank-to-eol       t)
  :hook ((custom-mode
          eshell-mode
          git-rebase-mode
          term-mode) . evil-emacs-state-mode)
  :bind (
	 :map evil-normal-state-map
	 ("C-e" . evil-end-of-line)
	 ("C-b" . evil-beginning-of-line)
	 ;; ("H" . previous-buffer)
	 ;; ("L" . next-buffer)
	 ("ESCAPE" . keyboard-escape-quit)
	 ("<leader>ff" . find-file)
	 ([remap evil-delete-line] . kill-dired-buffers)
	 :map evil-insert-state-map
	 ("C-k" . nil)
	 ("j" . evil-insert-jk-for-normal-mode)
	 :map evil-visual-state-map
	 ("ESCAPE" . keyboard-quit))
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; better escape
  (defun evil-insert-jk-for-normal-mode ()
    (interactive)
    (insert "j")
    (let ((event (read-event nil)))
      (if (= event ?k)
          (progn
            (backward-delete-char 1)
            (evil-normal-state))
	(push event unread-command-events))))
  (defun kill-dired-buffers ()
    (interactive)
    (mapc (lambda (buffer)
            (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
              (kill-buffer buffer)))
          (buffer-list))))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;;;
;;; Theme related settings
;;;
(use-package doom-themes
  :demand
  :config (load-theme 'doom-old-hope t))

(use-package doom-modeline
  :demand
  :hook (after-init . doom-modeline-mode))

(use-package centaur-tabs
  :demand
  :bind (:map evil-normal-state-map
              ("L" . centaur-tabs-forward)
              ("H" . centaur-tabs-backward))
  :custom
  ;; (centaur-tabs-height 32)
  (centaur-tabs-set-icons t)
  (centaur-tabs-show-new-tab-button t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-show-navigation-buttons t)
  (centaur-tabs-set-bar 'left)
  (centaur-tabs-show-count nil)
  (centaur-tabs-style "bar")
  (centaur-tabs-adjust-buffer-order t)
  (centaur-tabs-adjust-buffer-order 'left)
  :config
  (centaur-tabs-change-fonts (face-attribute 'default :font) 110)
  (centaur-tabs-enable-buffer-reordering)
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t))

(use-package nerd-icons
  :custom (nerd-icons-font-family "JetBrainsMono Nerd Font"))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package beacon ;; This applies a beacon effect to the highlighted line
  :config (beacon-mode 1))

(use-package dashboard
  :config (dashboard-setup-startup-hook))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)
;;;
;;; LSP
;;;

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :hook (flymake-mode . (lambda ()
                          (setq eldoc-documentation-functions
                                (cons 'flymake-eldoc-function
                                      (delq 'flymake-eldoc-function
                                            eldoc-documentation-functions))))))
(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-b" . eglot-format-buffer)
              ("C-c C-o" . python-sort-imports)
              ("C-c C-r" . eglot-rename))
  :config
  (add-to-list 'eglot-server-programs '((nix-mode nix-ts-mode) . ("nil")))
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:plugins (
                                       :ruff (:enabled t :lineLength 88)
                                       ;; :pylsp_mypy (:enabled t
                                       ;;              :report_progress t
                                       ;;              :live_mode :json-false)
                                       :jedi_completion (:enabled t)
                                       :pycodestyle (:enabled :json-false)
                                       :pylint (:enabled :json-false)
                                       :mccabe (:enabled :json-false)
                                       :pyflakes (:enabled :json-false)
                                       :yapf (:enabled :json-false)
                                       :autopep8 (:enabled :json-false)
                                       :black (:enabled :json-false)))))))
;;;
;;; Treesitter
;;;
(use-package treesit
  :ensure nil
  :init (setq treesit-font-lock-level 4
              major-mode-remap-alist
              '((c-mode          . c-ts-mode)
                (c++-mode        . c++-ts-mode)
                (c-or-c++-mode   . c-or-c++-ts-mode)
                (cmake-mode      . cmake-ts-mode)
                (conf-toml-mode  . toml-ts-mode)
                (css-mode        . css-ts-mode)
                (js-mode         . js-ts-mode)
                (java-mode       . java-ts-mode)
                (js-json-mode    . json-ts-mode)
                (python-mode     . python-ts-mode)
                ;; (clojure-mode    . clojure-ts-mode)
                (sh-mode         . bash-ts-mode)
                (typescript-mode . typescript-ts-mode)
                (rust-mode       . rust-ts-mode)
                (nix-mode        . nix-ts-mode)
                (go-mode         . go-ts-mode)))

  (add-to-list 'auto-mode-alist '("CMakeLists\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.y[a]?ml\\'" . yaml-ts-mode)))

;;;
;;; -- Dired -----
;;;
(use-package minibuffer
  :ensure nil
  :demand t
  :bind
  ( :map minibuffer-local-map
    ("ESCAPE" . minibuffer-keyboard-quit)
    :map minibuffer-local-ns-map
    ("ESCAPE" . minibuffer-keyboard-quit)
    :map minibuffer-local-completion-map
    ("ESCAPE" . minibuffer-keyboard-quit)
    :map minibuffer-local-must-match-map
    ("ESCAPE" . minibuffer-keyboard-quit)
    :map minibuffer-local-isearch-map
    ("ESCAPE" . minibuffer-keyboard-quit)))


(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind
  ([remap dired-do-hardlink] . previous-buffer)
  ([remap dired-do-load] . next-buffer)
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "y" 'dired-do-copy
    "m" 'dired-mark
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single)

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "." 'dired-hide-dotfiles-mode))

;;;
;;; minibuffer
;;;
(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("TAB" . vertico-insert)
              ([tab] . vertico-insert)
              ("C-k" . vertico-previous)))

;;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("C-l" . vertico-directory-enter)
              ("C-h" . vertico-directory-up))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package marginalia
  :config
  (marginalia-mode 1))

;;; `Orderless'.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot (styles orderless))))
  (orderless-component-separator #'orderless-escapable-split-on-space))

;; The `embark-consult' package is glue code to tie together `embark'
;; and `consult'.
(use-package embark-consult )

(use-package consult
  :bind
  ("<leader>sf" . consult-find)
  ("<leader>sg" . consult-ripgrep)
  ("<leader>sb" . consult-buffer)
  ("<leader>sl" . consult-line)
  ("<leader>so" . consult-outline))

(use-package embark
  :bind (("C-." . embark-act)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))

(use-package wgrep
  :bind (:map grep-mode-map
              ("e" . wgrep-change-to-wgrep-mode)
              ("C-x C-q" . wgrep-change-to-wgrep-mode)
              ("C-c C-c" . wgrep-finish-edit)))

;;; Code Completion
(use-package corfu
  :custom
  (corfu-cycle t)                 ; Allows cycling through candidates
  (corfu-auto t)                  ; Enable auto completion
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current 'insert) ; insert previewed candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
              ("M-SPC"      . corfu-insert-separator)
              ("TAB"        . corfu-next)
              ([tab]        . corfu-next)
              ("S-TAB"      . corfu-previous)
              ([backtab]    . corfu-previous)
              ("S-<return>" . corfu-insert)
              ("RET"        . nil))

  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode) ; Popup completion info
  :hook
  (eshell-mode . (lambda ()
                   (setq-local corfu-quit-at-boundary t
                               corfu-quit-no-match t
                               corfu-auto nil)
                   (corfu-mode))))

(use-package cape
  :after corfu
  :bind (("C-c p p" . completion-at-point)
         ("C-c p t" . complete-tag)
         ("C-c p d" . cape-dabbrev)
         ("C-c p f" . cape-file)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict))
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (when (eq system-type 'windows-nt)
    (plist-put kind-icon-default-style :height 0.8))
  (when (eq system-type 'gnu/linux)
    (plist-put kind-icon-default-style :height 0.7))
  (when (fboundp 'reapply-themes)
    (advice-add 'reapply-themes :after 'kind-icon-reset-cache)))

(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-keymap-disable-hook
           (lambda () (and (frame-live-p corfu--frame)
                           (frame-visible-p corfu--frame))))
  :hook (after-init . yas-global-mode))
(use-package yasnippet-snippets :after yasnippet)
(use-package consult-yasnippet
  :bind ("M-*" . consult-yasnippet)
  :config
  (with-eval-after-load 'embark
    (defvar-keymap embark-yasnippet-completion-actions
      :doc "Keymap for actions for yasnippets."
      :parent embark-general-map
      "v" #'consult-yasnippet-visit-snippet-file)
    (push '(yasnippet . embark-yasnippet-completion-actions)
          embark-keymap-alist)))

(use-package which-key
  :config (which-key-mode))

;; ;;;
;; ;;; Utilities
;; ;;;

(use-package magit
  :bind ("C-x g" . magit-status)     ; Display the main magit popup
  :init (setq magit-log-arguments
              '("--graph" "--color" "--decorate" "--show-signature" "-n256")))
;;;
;;; Programming language
;;;

;;; EAT AND ESHELL
(use-package eat
  :custom
  (eat-enable-auto-line-mode t)
  :bind (("C-x E" . eat)
         :map project-prefix-map
         ("t" . eat-project)))

(use-package eshell
  :commands eshell
  :config
  (setq eshell-destroy-buffer-when-process-dies t))

(use-package em-alias
  :ensure nil
  :after eshell
  :config
  (defun my/setup-eshell-aliases ()
    (eshell/alias "e" "find-file $1")
    (eshell/alias "ee" "find-file-other-window $1")
    (eshell/alias "v" "view-file $1")
    (add-hook 'eshell-mode-hook my/setup-eshell-aliases)))

(use-package em-term
  :ensure nil
  :after eshell
  :config
  (add-to-list 'eshell-visual-options '("git" "--help" "--paginate"))
  (add-to-list 'eshell-visual-options '("ghcup" "tui"))
  (add-to-list 'eshell-visual-commands '("htop" "top" "git" "log" "diff"
                                         "show" "less" "nix")))


;; More accurate color representation than ansi-color.el
(use-package xterm-color
  :after esh-mode
  :config
  (add-hook 'eshell-before-prompt-hook
            (lambda ()
	      (setq xterm-color-preserve-properties t)))

  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
  (setq eshell-output-filter-functions
        (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
  (setenv "TERM" "xterm-256color"))

(use-package elisp-mode
  :ensure nil
  :diminish "EL")
(use-package buttercup :defer t)
(use-package package-lint :defer t)
(use-package elisp-lint :defer t)
(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))
;; Converts regex to `rx' syntax (very useful)
;; https://github.com/mattiase/xr
(use-package xr
  :defer t)


(use-package fish-mode)

(use-package python
  :ensure nil
  :mode (("\\.py\\'" . python-ts-mode))
  :hook ((python-ts-mode . eglot-ensure)))

(use-package cc-mode
  :bind (:map c--ts-mode-map
              ("C-c C-f" . c-ts-format-buffer))
  :ensure nil
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)))
(use-package cmake-mode
  :hook (cmake-mode . eglot-ensure))

(use-package cmake-font-lock
  :after cmake-mode
  :config (cmake-font-lock-activate))

;; Nix mode
(use-package nix-mode)
(use-package nix-ts-mode
  :mode (("\\.nix\\'" . nix-ts-mode))
  :hook (nix-ts-mode . eglot-ensure))

;; Go mode
(use-package go-mode)
(use-package go-ts-mode
  :hook ((go-ts-mode . go-format-on-save-mode)
         (go-ts-mode . eglot-ensure))
  :mode (("\\.go\\'" . go-ts-mode)
         ("/go\\.mod\\'" . go-mod-ts-mode))
  :config
  (reformatter-define go-format
                      :program "goimports"
                      :args '("/dev/stdin")))


(use-package rust-mode)
(use-package rust-ts-mode
  :mode (("\\.rs\\'" . rust-ts-mode))
  :hook (rust-ts-mode . eglot-ensure))

(use-package cider)
(use-package clojure-mode)
(use-package clj-refactor)
(use-package clojure-snippets)
;; (use-package flycheck-clj-kondo)
(use-package clojure-ts-mode
  :hook ((clojure-ts-mode . clj-refactor-mode)
         (clojure-ts-mode . cider-mode)))


(use-package direnv
  :config (direnv-mode))
