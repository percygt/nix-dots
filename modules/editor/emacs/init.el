;; -*- lexical-binding: t; -*-
;;; 
;; This file is not part of GNU Emacs.
;; This file is free software.

;; ------- The following code was auto-tangled from an Orgmode file. ------- ;;

(use-package emacs
  :ensure nil
  :demand
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

    (use-package diminish :after use-package) ;; if you use :diminish

(use-package no-littering
  :init
  (setq no-littering-etc-directory user-emacs-directory)
  (setq no-littering-var-directory user-emacs-directory)
  :demand t)

:after no-littering
:ensure nil
:demand t
:preface
(require 'no-littering)
(defvar backup-dir (no-littering-expand-var-file-name "backup/")
  "Directory to store backups.")
(defvar auto-save-dir (no-littering-expand-var-file-name "auto-save/")
  "Directory to store auto-save files.")
(defvar customfile (no-littering-expand-etc-file-name "custom.el")
  "Custom file")
:init
(unless (file-exists-p auto-save-dir) (make-directory auto-save-dir t))
(unless (file-exists-p backup-dir) (make-directory backup-dir t))
(when (file-exists-p customfile) (load customfile))
:config
(global-hl-line-mode 1)           ; Highlight the current line to make it more visible
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
(find-file-visit-truename          t)
(backup-by-copying                t)    ; Always use copying to create backup files
(delete-old-versions              t)    ; Delete excess backup versions
(kept-new-versions                6)    ; Number of newest versions to keep when a new backup is made
(kept-old-versions                2)    ; Number of oldest versions to keep when a new backup is made
(version-control                  t)    ; Make numeric backup versions unconditionally
(delete-by-moving-to-trash        t)    ; Move deleted files to the trash
(mode-require-final-newline       nil)  ; Don't add newlines at the end of files

(use-package general
  :demand t
  :preface
  (defun switch-to-recent-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer))))
  (defun kill-this-buffer ()  ; for the menu bar
    "Kill the current buffer.
When called in the minibuffer, get out of the minibuffer
using `abort-recursive-edit'."
    (interactive)
    (cond
     ;; Don't do anything when `menu-frame' is not alive or visible
     ;; (Bug#8184).
     ((not (menu-bar-menu-frame-live-and-visible-p)))
     ((menu-bar-non-minibuffer-window-p)
      (kill-buffer (current-buffer)))
     (t
      (abort-recursive-edit))))
  :config
  (general-override-mode)
  (general-auto-unbind-keys)
  (general-create-definer global-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer local-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix ","
    :global-prefix "C-,")
  (general-create-definer normal-definer
    :keymaps 'override
    :states '(normal))

  (normal-definer
    "D" 'kill-this-buffer)
  (global-definer
    "!" 'shell-command
    ":" 'eval-expression
    "f" 'find-file
    "l" 'load-file
    "d" 'dired
    "." 'switch-to-recent-buffer
    "u"  '(nil :wk "Utils")
    "u." 'repeat
    )

  (general-create-definer global-leader
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator)
    :prefix "SPC m"
    :non-normal-prefix "C-SPC m"
    "" '( :ignore t
  	      :which-key
  	      (lambda (arg)
  	        (cons (cadr (split-string (car arg) " "))
  		          (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))))))
  )

(use-package evil
  :preface
  (defun evil-insert-jk-for-normal-mode ()
    (interactive)
    (insert "j")
    (let ((event (read-event nil)))
      (if (= event ?k)
          (progn
            (backward-delete-char 1)
            (evil-normal-state))
	    (push event unread-command-events))))
  :init
  (setq evil-want-keybinding      nil)
  (setq evil-want-integration     t)
  (setq evil-emacs-state-cursor  '("white" box))
  (setq evil-normal-state-cursor '("cyan" box))
  (setq evil-visual-state-cursor '("pale goldenrod" box))
  (setq evil-insert-state-cursor '("sky blue" bar))
  :custom
  (evil-want-fine-undo           t)
  (evil-respect-visual-line-mode t)
  (evil-want-C-u-scroll          t)
  (evil-want-C-i-jump            nil)
  (evil-search-module            'evil-search)
  (evil-undo-system              'undo-fu)
  (evil-split-window-right       t)
  (evil-split-window-below       t)
  (evil-want-Y-yank-to-eol       t)
  :hook ((custom-mode
          eshell-mode
          git-rebase-mode
          term-mode) . evil-emacs-state-mode)
  :bind ( :map evil-normal-state-map
	      ("C-e" . evil-end-of-line)
	      ("C-b" . evil-beginning-of-line)
	      ("ESCAPE" . keyboard-escape-quit)
	      ("WW" . save-buffer)
	      :map evil-insert-state-map
	      ("j"   . evil-insert-jk-for-normal-mode)
	      :map evil-visual-state-map
	      ("ESCAPE" . keyboard-quit)
	      :map special-mode-map
	      ("q" . quit-window))
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal))

(use-package evil-surround
  :after evil
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

(use-package evil-goggles
  :init
  (evil-goggles-mode)
  :after evil
  :config
  (setq evil-goggles-pulse t
        (evil-goggles-use-diff-faces))
        evil-goggles-duration 0.3)

(use-package avy
  :bind (:map evil-normal-state-map
              ("M-s" . avy-goto-char)))

(use-package move-text
  :bind (:map evil-normal-state-map
              ("M-k" . move-text-up)
	          ("M-j" . move-text-down))
  :config
  (move-text-default-bindings))

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
		             ,(concat user-emacs-directory "lib/.*-autoloads\\.el\\'")))
  :config
  (require 'recentf)
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
  (undo-fu-session-directory (expand-file-name  "var/undo-fu-session/" user-emacs-data-directory))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

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

(use-package dired
  :ensure nil
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "L" 'nil
    "H" 'nil
    "D" 'nil
    "d" 'nil
    "r" 'dired-do-rename
    "R" 'dired-do-redisplay
    "y" 'dired-do-copy
    "d" 'dired-do-delete))

(use-package dired-single
  :after dired
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "l" 'dired-single-buffer
    "h" 'dired-single-up-directory))
(use-package diredfl
  :after dired
  :hook (dired-mode . diredfl-global-mode))
(use-package dired-open
  :after dired
  :custom
  (dired-open-extensions '(("png" . "feh")
                           ("mkv" . "mpv"))))
(use-package dired-hide-dotfiles
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "SPC" 'nil
    "."   'dired-hide-dotfiles-mode))

(use-package minibuffer
  :ensure nil
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

(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("TAB" . vertico-insert)
              ([tab] . vertico-insert)
              ("C-k" . vertico-previous)))

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

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot (styles orderless))))
  (orderless-component-separator #'orderless-escapable-split-on-space))

(use-package embark-consult )

(use-package consult
  :general
  (global-definer
    "s" '(nil :wk "Consult")
    "sf" 'consult-fd
    "sg" 'consult-ripgrep
    ","  'consult-buffer
    "sl" 'consult-line
    "so" 'consult-outline))

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
              ("<escape>"   . corfu-quit)
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
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  )

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
  :init
  (which-key-mode)
  (which-key-setup-minibuffer)
  (which-key-define-key-recursively global-map [escape] 'ignore)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-prefix-prefix "◉ ")
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 3
        which-key-max-display-columns nil))


(use-package nerd-icons-ibuffer
  :after (nerd-icons ibuffer)
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package ispell
  :ensure nil
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "en")
  :config
  (ispell-set-spellchecker-params))

(use-package flyspell
  :ensure nil
  :after ispell
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))

  (dolist (mode '(
                  ;;org-mode-hook
                  mu4e-compose-mode-hook))
    (add-hook mode (lambda () (flyspell-mode 1))))

  (setq flyspell-issue-welcome-flag nil
        flyspell-issue-message-flag nil)

  :general ;; Switches correct word from middle click to right click
  (general-define-key :keymaps 'flyspell-mouse-map
                      "<mouse-3>" #'ispell-word
                      "<mouse-2>" nil)
  (general-define-key :keymaps 'evil-motion-state-map
                      "zz" #'ispell-word)
  :bind ("C-c s" . flyspell-mode))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)))

(use-package eat
  :custom
  (eat-enable-auto-line-mode t)
  :bind (("C-x E" . eat)
         :map project-prefix-map
         ("t" . eat-project)))

(use-package fish-mode)

(use-package eshell
  :ensure nil
  :commands eshell
  :config
  (setq eshell-destroy-buffer-when-process-dies t))


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

(use-package magit
  :bind ("C-x g" . magit-status)     ; Display the main magit popup
  :init (setq magit-log-arguments
              '("--graph" "--color" "--decorate" "--show-signature" "-n256")))

(use-package visual-fill-column
  :defer t
  :config
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 80)
  (setq visual-fill-column-center-text t))

(use-package writeroom-mode
  :defer t
  :config
  (setq writeroom-maximize-window nil
        writeroom-mode-line t
        writeroom-global-effects nil ;; No need to have Writeroom do any of that silly stuff
        writeroom-extra-line-spacing 3)
  (setq writeroom-width visual-fill-column-width)
  )

(use-package font
  :ensure nil
  :demand
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

(use-package dashboard
  :after (nerd-icons evil)
  :custom
  (dashboard-items '((recents  .  5)
		             (projects .  5)
		             (agenda   . 10)))
  (dashboard-set-footer nil)
  (dashboard-set-init-info t)
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-startup-banner (concat user-emacs-config-directory "/xemacs_color.svg"))
  (dashboard-projects-backend 'project-el)
  :config
  (dashboard-setup-startup-hook)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (setq initial-buffer-choice (lambda ()
				                (get-buffer-create "*dashboard*")
				                (dashboard-refresh-buffer))))


(use-package doom-themes
  :demand
  :hook
  (server-after-make-frame . (lambda () (load-theme 'doom-ephemeral t)))
  :config
  (load-theme 'doom-ephemeral t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :custom
  (doom-modeline-icon t)
  :demand
  :hook
  (after-init . doom-modeline-mode))

(use-package keycast
  :commands toggle-keycast
  :config
  (defun toggle-keycast()
    (interactive)
    (if (member '("" keycast-mode-line " ") global-mode-string)
        (progn (setq global-mode-string (delete '("" keycast-mode-line " ") global-mode-string))
               (remove-hook 'pre-command-hook 'keycast--update)
               (message "Keycast OFF"))
      (add-to-list 'global-mode-string '("" keycast-mode-line " "))
      (add-hook 'pre-command-hook 'keycast--update t)
      (message "Keycast ON"))))

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font"))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package beacon ;; This applies a beacon effect to the highlighted line
  :config (beacon-mode 1))

(use-package solaire-mode
  :hook (after-init . solaire-global-mode)
  :config
  (push '(treemacs-window-background-face . solaire-default-face) solaire-mode-remap-alist)
  (push '(treemacs-hl-line-face . solaire-hl-line-face) solaire-mode-remap-alist))

(use-package hide-mode-line
  :defer
  :hook (org-mode . hide-mode-line-mode))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (set-face-foreground 'highlight-indent-guides-top-character-face "SteelBlue")
  (set-face-foreground 'highlight-indent-guides-character-face "gray20")
  :custom
  (highlight-indent-guides-auto-enabled  nil)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method 'character))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)

(use-package flymake
  :ensure nil
  :config
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  :hook
  (prog-mode . flymake-mode)
  (flymake-mode . (lambda ()
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

(use-package web-mode
  :mode "\\.html\\'"
  :custom
  (web-mode-attr-indent-offset 2)
  (web-mode-enable-css-colorization t)
  (web-mode-enable-auto-closing t)
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-current-element-highlight t))
(use-package auto-rename-tag
  :defer t
  :hook (web-mode . auto-rename-tag-mode))

(use-package emacs-lisp-mode
  :ensure nil
  :general
  (local-definer
    :keymaps 'emacs-lisp-mode-map
    "e" '(nil :which-key "eval")
    "es" '(eval-last-sexp :which-key "eval-sexp")
    "ee" '(eval-defun :which-key "eval-defun")
    "er" '(eval-region :which-key "eval-region")
    "eb" '(eval-buffer :which-key "eval-buffer")

    "g" '(counsel-imenu :which-key "imenu")
    "c" '(check-parens :which-key "check parens")
    "I" '(indent-region :which-key "indent-region")

    "b" '(nil :which-key "org src")
    "bc" 'org-edit-src-abort
    "bb" 'org-edit-src-exit
    )
  )
(use-package buttercup :defer t)
(use-package package-lint :defer t)
(use-package elisp-lint :defer t)
(use-package xr :defer t)
(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))

(use-package python
  :ensure nil
  :mode (("\\.py\\'" . python-ts-mode))
  :hook ((python-ts-mode . eglot-ensure)))

(use-package cc-mode
  :bind (:map c-ts-mode-map
              ("C-c C-f" . c-ts-format-buffer))
  :ensure nil
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)))
(use-package cmake-mode
  :defer t
  :hook (cmake-mode . eglot-ensure))

(use-package cmake-font-lock
  :after cmake-mode
  :config (cmake-font-lock-activate))

(use-package nix-mode)
(use-package nix-ts-mode
  :mode (("\\.nix\\'" . nix-ts-mode))
  :hook (nix-ts-mode . eglot-ensure))

(use-package go-mode)
(use-package go-ts-mode
  :ensure nil
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
  :ensure nil
  :mode (("\\.rs\\'" . rust-ts-mode))
  :hook (rust-ts-mode . eglot-ensure))

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package cider)
(use-package clojure-mode)
(use-package clj-refactor)
(use-package clojure-snippets)
;; (use-package flycheck-clj-kondo)
(use-package clojure-ts-mode
  :hook ((clojure-ts-mode . clj-refactor-mode)
         (clojure-ts-mode . cider-mode)))

;; (use-package tex-mode
;;   :ensure nil
;;   :defer t
;;   :config
;;   (setq tex-start-commands nil))

(use-package auctex
  :defer t)

(use-package latex ;; This is a weird one. Package is auctex but needs to be managed like this.
  :ensure nil
  :defer t
  :init
  (setq TeX-engine 'xetex ;; Use XeTeX
        latex-run-command "xetex")

  (setq TeX-parse-self t ; parse on load
        TeX-auto-save t  ; parse on save
        ;; Use directories in a hidden away folder for AUCTeX files.
        TeX-auto-local (concat user-emacs-directory "auctex/auto/")
        TeX-style-local (concat user-emacs-directory "auctex/style/")

        TeX-source-correlate-mode t
        TeX-source-correlate-method 'synctex

        TeX-show-compilation nil

        ;; Don't start the Emacs server when correlating sources.
        TeX-source-correlate-start-server nil

        ;; Automatically insert braces after sub/superscript in `LaTeX-math-mode'.
        TeX-electric-sub-and-superscript t
        ;; Just save, don't ask before each compilation.
        TeX-save-query nil)

  ;; To use pdfview with auctex:
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
        TeX-source-correlate-start-server t)
  :custom
  (org-latex-listings t) ;; Uses listings package for code exports
  (org-latex-compiler "xelatex") ;; XeLaTex rather than pdflatex

  :config
  ;; not sure what this is, look into it
  ;; '(org-latex-active-timestamp-format "\\texttt{%s}")
  ;; '(org-latex-inactive-timestamp-format "\\texttt{%s}")

  ;; LaTeX Classes
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("org-plain-latex" ;; I use this in base class in all of my org exports.
                   "\\documentclass{extarticle}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    )
  :general
  (local-definer
    "l"  '(nil :wk "Latex")
    "la" '(TeX-command-run-all :which-key "TeX run all")
    "lc" '(TeX-command-master :which-key "TeX-command-master")
    "le" '(LaTeX-environment :which-key "Insert environment")
    "ls" '(LaTeX-section :which-key "Insert section")
    "lm" '(TeX-insert-macro :which-key "Insert macro"))
  )

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ;; Standard way

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode)
  :config
  (setq org-latex-create-formula-image-program 'dvisvgm) ;; sharper
  (plist-put org-format-latex-options :scale 1.5) ;; bigger
  (setq org-latex-preview-ltxpng-directory (concat (temporary-file-directory) "ltxpng/"))
  )

;; (setq org-export-with-broken-links t
;;       org-export-with-smart-quotes t
;;       org-export-allow-bind-keywords t)

;; ;; From https://stackoverflow.com/questions/23297422/org-mode-timestamp-format-when-exported
;; (defun org-export-filter-timestamp-remove-brackets (timestamp backend info)
;;   "removes relevant brackets from a timestamp"
;;   (cond
;;    ((org-export-derived-backend-p backend 'latex)
;;     (replace-regexp-in-string "[<>]\\|[][]" "" timestamp))
;;    ((org-export-derived-backend-p backend 'html)
;;     (replace-regexp-in-string "&[lg]t;\\|[][]" "" timestamp))))


;; ;; HTML-specific
;; (setq org-html-validation-link nil) ;; No validation button on HTML exports

;; ;; LaTeX Specific
;; (eval-after-load 'ox '(add-to-list
;;                        'org-export-filter-timestamp-functions
;;                        'org-export-filter-timestamp-remove-brackets))

;; (use-package ox-hugo
;;   :defer 2
;;   :after ox
;;   :config
;;   (setq org-hugo-base-dir "~/Dropbox/Projects/cpb"))

;; (use-package ox-moderncv
;;   :ensure nil
;;   :init (require 'ox-moderncv))

(use-package org
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*Capture\\*$"
                 (display-buffer-full-frame)))
  (add-to-list 'display-buffer-alist
               '("\\*Org Select\\*"
                 (display-buffer-full-frame)))

  :preface
  (defun org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode)
    (auto-fill-mode 0)
    (visual-line-mode 1)
    (setq evil-auto-indent nil))
  :hook
  (org-mode . org-mode-setup)
  :custom
  (org-capture-templates
   '(("t" "todo" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\n%i\n%a"
      :prepend t)
     ("d" "deadline" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\nDEADLINE: <%(org-read-date)>\n\n%i\n%a"
      :prepend t)
     ("s" "schedule" entry (file+headline "todo.org" "Inbox")
      "* [ ] %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a"
      :prepend t)
     ("c" "check out later" entry (file+headline "todo.org" "Check out later")
      "* [ ] %?\n%i\n%a"
      :prepend t)))
  (org-highlight-latex-and-related '(native)) ;; Highlight inline LaTeX
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-list-indent-offset 1)
  (org-cycle-separator-lines 1)
  (org-ellipsis " ")
  (org-pretty-entities t)
  (org-src-preserve-indentation nil)
  (org-src-fontify-natively t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  ;; (org-hide-block-startup nil)
  (org-src-tab-acts-natively t)
  (org-startup-folded t)
  (org-image-actual-width nil)
  (org-cycle-separator-lines 1)
  (org-hide-leading-stars t)
  (org-goto-auto-isearch nil)
  (org-log-done 'time)
  (org-log-into-drawer t)
  ;; M-Ret can split lines on items and tables but not headlines and not on anything else (unconfigured)
  (org-M-RET-may-split-line '((headline) (item . t) (table . t) (default)))
  (org-loop-over-headlines-in-active-region nil)

  (org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
  (org-catch-invisible-edits 'show-and-error) ;; 'smart
  (org-todo-keywords '((type "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c@)")))
  (org-checkbox-hierarchical-statistics t)
  (org-list-demote-modify-bullet '(("+" . "*") ("*" . "-") ("-" . "+")))
  (org-enforce-todo-dependencies t)
  (org-hierarchical-todo-statistics nil)
  (org-use-property-inheritance t)
  (org-tags-column -1)
  (org-highest-priority ?A)
  (org-default-priority ?D)
  (org-lowest-priority ?E)
  :custom-face
  (outline-1 ((t (:height 1.2))))
  (outline-2 ((t (:height 1.1))))
  (outline-3 ((t (:height 1.05))))
  (outline-4 ((t (:height 1.025))))
  (outline-5 ((t (:height 1.0))))
  (outline-6 ((t (:height 1.0))))
  (outline-7 ((t (:height 1.0))))
  (outline-8 ((t (:height 1.0))))
  (org-code ((t (:inherit fixed-pitch))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-document-title ((t (:inherit (fixed-pitch) :foreground "LightGray"))))
  (org-document-info ((t (:inherit (fixed-pitch) :foreground "LightGray" :height 0.8))))
  (org-document-info-keyword ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-drawer ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-indent ((t (:inherit (org-hide fixed-pitch)))))
  (org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-property-value ((t (:inherit fixed-pitch))))
  (org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch) :height 0.8))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-tag ((t (:inherit fixed-pitch :weight bold))))
  (org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  )

(use-package evil-org
  :diminish evil-org-mode
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	        (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-table nil)
  (org-modern-hide-stars nil)		; adds extra indentation
  (org-modern-list'((?+ . "✦") (?- . "‣") (?* . "◉")))
  (org-modern-block-name '("" . "")) ; or other chars; so top bracket is drawn promptly
  ;; (org-modern-variable-pitch t)
  :commands (org-modern-mode org-modern-agenda)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-modern-indent
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t		;; A default setting that needs to be t for org-appear
        org-appear-autoemphasis t		;; Enable org-appear on emphasis (bold, italics, etc)
        org-appear-autolinks nil		;; Don't enable on links
        org-appear-autosubmarkers t))	;; Enable on subscript and superscript

(use-package org-ql
  :defer t
  :general
  (:states '(normal) :keymaps 'org-ql-view-map
           "q" 'kill-buffer-and-window))

;; (use-package org-brain
;;   :custom
;;   (org-brain-path notes-directory)
;;   (org-brain-visualize-default-choices 'all)
;;   (org-brain-title-max-length 12)
;;   (org-brain-include-file-entries nil)
;;   (org-brain-file-entries-use-title nil)
;;   ;; For Evil users
;;   :init
;;   (with-eval-after-load 'evil
;;     (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
;;   :config
;;   (bind-key "C-c b" 'org-brain-prefix-map org-mode-map))
;; (setq org-id-track-globally t)
;; (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
;; (push '("b" "Brain" plain (function org-brain-goto-end)
;;         "* %i%?" :empty-lines 1)
;;       org-capture-templates)

;; ;; allows you to edit entries directly from org-brain-visualize
;; (use-package polymode
;;   :general
;;   (local-definer
;;     :states '(normal visual)
;;     :keymaps 'polymode-mode-map
;;     "j" 'polymode-next-chunk
;;     "k" 'polymode-previous-chunk
;;     "i" 'polymode-insert-new-chunk
;;     "u" 'polymode-insert-new-chunk-code-only
;;     "U" 'polymode-insert-new-chunk-output-only
;;     "p" 'polymode-insert-new-plot
;;     "o" 'polymode-insert-yaml
;;     "d" 'polymode-kill-chunk
;;     "e" 'polymode-export
;;     "E" 'polymode-set-exporter
;;     "w" 'polymode-weave
;;     "W" 'polymode-set-weaver
;;     "$" 'polymode-show-process-buffer
;;     "n" 'polymode-eval-region-or-chunk
;;     "," 'polymode-eval-region-or-chunk
;;     "N" 'polymode-eval-buffer
;;     "1" 'polymode-eval-buffer-from-beg-to-point
;;     "0" 'polymode-eval-buffer-from-point-to-end)
;;   :config
;;   (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))


;; Templates
(use-package org-tempo
  :ensure nil
  :after org
  :config
  (let ((templates '(("sh"  . "src sh")
                     ("el"  . "src emacs-lisp")
                     ("vim" . "src vim")
                     ("cpp" . "src C++ :includes <iostream> :namespaces std"))))
    (dolist (template templates)
      (push template org-structure-template-alist))))


;; (use-package org-timeblock)

;; (use-package org-transclusion :after org)

(use-package org-agenda
  :ensure nil
  :custom
  (org-time-stamp-custom-formats '("<%A, %B %d, %Y" . "<%m/%d/%y %a %I:%M %p>"))
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-window-setup 'current-window)
  ;; Only show upcoming deadlines for the next X days. By default it shows
  ;; 14 days into the future, which seems excessive.
  (org-deadline-warning-days 3)
  ;; If something is done, don't show its deadline
  (org-agenda-skip-deadline-if-done t)
  ;; If something is done, don't show when it's scheduled for
  (org-agenda-skip-scheduled-if-done t)
  ;; If something is scheduled, don't tell me it is due soon
  (org-agenda-skip-deadline-prewarning-if-scheduled t)
  ;; use AM-PM and not 24-hour time
  (org-agenda-timegrid-use-ampm t)
  ;; A new day is 3am (I work late into the night)
  ;; (setq org-extend-today-until 3)
  ;; (setq org-agenda-time-grid '((daily today require-timed)
  ;;                              (1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200)
  ;;                              "        " "----------------"))
  (org-agenda-time-grid nil)
  ;; (setq org-agenda-span 'day)
  (org-agenda-block-separator ?-)
  ;; (setq org-agenda-current-time-string "<----------------- Now")
  ;; ;; (setq org-agenda-block-separator nil)
  ;; (setq org-agenda-scheduled-leaders '("Plan | " "Sched.%2dx: ") ; ⇛
  ;;       org-agenda-deadline-leaders '("Due: " "(in %1d d.) " "Due %1d d. ago: "))
  ;; (setq org-agenda-prefix-format '((agenda . "  %-6:T %t%s")
  ;;                                  (todo . "  %-6:T %t%s")
  ;;                                  (tags . " %i %-12:c")
  ;;                                  (search . " %i %-12:c")))

  (org-agenda-prefix-format '((agenda . " %-12:T%?-12t% s")
                              (todo . " %i %-12:c")
                              (tags . " %i %-12:c")
                              (search . " %i %-12:c")))

  (org-agenda-deadline-leaders '("Deadline:  " "In %2d d.: " "%2d d. ago: "))
  ;; (org-agenda-files '(notes-directory))
  )

(use-package org-super-agenda
  :after org
  :config
  (setq org-super-agenda-header-map nil) ;; takes over 'j'
  ;; (setq org-super-agenda-header-prefix " ◦ ") ;; There are some unicode "THIN SPACE"s after the ◦
  ;; Hide the thin width char glyph. This is dramatic but lets me not be annoyed
  (add-hook 'org-agenda-mode-hook
            #'(lambda () (setq-local nobreak-char-display nil)))
  (org-super-agenda-mode))

(use-package org-roam
  :after (org marginalia)
  :init
  (setq org-roam-v2-ack t)
  (unless (file-exists-p resourcesDir) (make-directory resourcesDir t))
  :preface
  (defvar resourcesDir (concat notes-directory "/resources")
    "Resources directory")
  (defvar auto-org-roam-db-sync--timer nil)

  (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args))) (defvar auto-org-roam-db-sync--timer-interval 5)

  (defun org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (org-roam-list-notes-by-tag "Project")))

  (defun org-roam-project-finalize-hook ()
    "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
    ;; Remove the hook since it was added temporarily
    (remove-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Add project file to the agenda list if the capture was confirmed
    (unless org-note-abort
      (with-current-buffer (org-capture-get :buffer)
        (add-to-list 'org-agenda-files (buffer-file-name)))))

  (defun org-roam-find-project ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Select a project file to open, creating it if necessary
    (org-roam-node-find
     nil
     nil
     (org-roam-filter-by-tag "Project")
     :templates '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
                   :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
                   :unnarrowed t))))

  (defun org-roam-capture-inbox ()
    (interactive)
    (org-roam-capture- :node (org-roam-node-create)
                       :templates '(("i" "inbox" plain "* %?"
                                     :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun org-roam-capture-task ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'org-roam-project-finalize-hook)
    ;; Capture the new task, creating the project file if necessary
    (org-roam-capture- :node (org-roam-node-read
                              nil
                              (org-roam-filter-by-tag "Project"))
                       :templates '(("p" "project" plain "** TODO %?"
                                     :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                            "#+title: ${title}\n#+filetags: Project"
                                                            ("Tasks"))))))
  :config
  (cl-defmethod org-roam-node-capitalized-slug
    ((node org-roam-node)) (capitalize (org-roam-node-slug node)))
  (cl-defmethod org-roam-node-capitalized-title
    ((node org-roam-node)) (capitalize (org-roam-node-title node)))
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-full-frame)))
  ;; Build the agenda list the first time for the session
  (org-roam-refresh-agenda-list)
  (org-roam-db-autosync-enable)
  (org-roam-setup)
  :custom
  (org-roam-node-display-template
   (concat "${title:80} " (propertize "${tags:20}" 'face 'org-tag))
   org-roam-node-annotation-function
   (lambda (node) (marginalia--time (org-roam-node-file-mtime node))))
  (org-roam-completion-everywhere t)
  (org-roam-directory notes-directory)
  (org-roam-db-location (concat resourcesDir "/org-roam.db"))
  (org-roam-dailies-directory "journals/")
  (org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$")
  (org-roam-capture-templates
   `(("i" "index" plain "%?"
      :target
      (file+head
       "${capitalized-slug}.org"
       "#+title: ${capitalized-title}\n#+created: <%<%Y-%m-%d>>\n#+modified: \n#+filetags: :MOC:${slug}:\n\n* Map of Content\n\n#+BEGIN: notes :tags ${slug}\n#+END:")
      :jump-to-captured t
      :immediate-finish t
      :unnarrowed t)
     ("s" "standard" plain "%?"
      :target
      (file+head
       "org/%<%Y%m%d_%H%M%S>_${slug}.org"
       "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: : \n\n")
      :unnarrowed t)
     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
      :unnarrowed t)
     ("r" "ref" plain "%?"
      :target
      (file+head
       "org/${citekey}.org"
       "#+title: ${slug}: ${title}\n#+filetags: reference ${keywords} \n\n* ${title}\n\n\n* Summary\n\n\n* Rough note space\n")
      :unnarrowed t)
     ))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+datetree
	           "%<%Y-%m-%d>.org" week))))
  (org-roam-mode-sections '(org-roam-backlinks-section
			                org-roam-reflinks-section
			                org-roam-unlinked-references-section))
  :general
  (global-definer
    "w"  '(nil :wk "Writer")
    "wb" 'org-roam-buffer-toggle
    "wf" 'org-roam-node-find
    "wg" 'org-roam-graph
    "wc" 'org-roam-capture
    "wd" 'org-roam-dailies-capture-today
    "wp" 'org-roam-find-project
    "wt" 'org-roam-capture-task
    "wi" 'org-roam-capture-inbox
    )
  (global-definer
    :keymaps '(org-mode-map)
    "w." 'completion-at-point
    "wI" 'org-roam-node-insert-immediate
    "wi" 'org-roam-node-insert))

;; (use-package consult-notes
;;   :commands (consult-notes
;;              consult-notes-search-in-all-notes
;;              ;; if using org-roam
;;              consult-notes-org-roam-find-node
;;              consult-notes-org-roam-find-node-relation)
;;   :config
;;   (setq consult-notes-file-dir-sources '(("Name"  ?key  "path/to/dir"))) ;; Set notes dir(s), see below
;;   ;; Set org-roam integration, denote integration, or org-heading integration e.g.:
;;   (setq consult-notes-org-headings-files '("~/path/to/file1.org"
;;                                            "~/path/to/file2.org"))
;;   (consult-notes-org-headings-mode)
;;   (when (locate-library "denote")
;;     (consult-notes-denote-mode))
;;   ;; search only for text files in denote dir
;;   (setq consult-notes-denote-files-function (function denote-directory-text-only-files)))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-roam-timestamps
  :after org-roam
  :config (org-roam-timestamps-mode))

;; (use-package md-roam
;;   :ensure nil
;;   :after org-roam
;;   :custom
;;   (md-roam-file-extension "md")
;;   :config
;;   (md-roam-mode 1))

(use-package org-roam-review
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-review\\*"
                 (display-buffer-full-frame)))
  :commands (org-roam-review
	         org-roam-review-list-by-maturity
	         org-roam-review-list-recently-added)
  ;; Optional - tag all newly-created notes as seedlings.
  :hook (org-roam-capture-new-node . org-roam-review-set-seedling)
  ;; Optional - keybindings for applying Evergreen note properties.
  :general
  (global-definer
    "r"  '(org-roam-review :wk "Review"))
  (global-definer
    :keymaps 'org-mode-map
    "e"  '(nil :wk "Evergreen")
    "ea" '(org-roam-review-accept :wk "accept")
    "ed" '(org-roam-review-bury :wk "bury")
    "ex" '(org-roam-review-set-excluded :wk "set excluded")
    "eb" '(org-roam-review-set-budding :wk "set budding")
    "es" '(org-roam-review-set-seedling :wk "set seedling")
    "ee" '(org-roam-review-set-evergreen :wk "set evergreen"))
  ;; ;; Optional - bindings for evil-mode compatability.
  :general
  (:states '(normal) :keymaps 'org-roam-review-mode-map
	       "TAB" 'magit-section-cycle
	       "g r" 'org-roam-review-refresh))

(use-package org-format
  :ensure nil
  :hook (org-mode . org-format-on-save-mode))

(use-package org-roam-search
  :ensure nil
  :commands (org-roam-search))

(use-package org-roam-links
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-links\\*"
                 (display-buffer-full-frame)))
  :general
  (global-definer
    :keymaps '(org-mode-map)
    "wl" 'org-roam-links)
  :commands (org-roam-links))

(use-package org-roam-dblocks
  :ensure nil
  :hook (org-mode . org-roam-dblocks-autoupdate-mode))

(use-package org-roam-rewrite
    :ensure nil
    :commands (org-roam-rewrite-rename
               org-roam-rewrite-remove
               org-roam-rewrite-inline
               org-roam-rewrite-extract))

(use-package org-capture-detect
  :ensure nil
  :after org-roam)

(use-package org-roam-links
  :ensure nil
  :after org-roam
  :demand t)

(use-package org-roam-lazy-previews
  :ensure nil
  :after org-roam
  :demand t)

(use-package org-roam-slipbox
  :ensure nil
  :after org-roam
  :demand t
  :config
  (org-roam-slipbox-buffer-identification-mode +1)
  (org-roam-slipbox-tag-mode +1))

(use-package spacious-padding
  :defer
  :hook (after-init . spacious-padding-mode))

(use-package multiple-cursors
  :general
  (global-definer
    "n" '(nil :wk "Multicursor")
    "nn" 'mc/mark-next-word-like-this
    "np" 'mc/mark-previous-word-like-this
    "na" 'mc/mark-all-like-this
    ))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (cc-ts-mode . aggressive-indent-mode)))

(use-package pdf-tools
  :defer t
  ;; stop pdf-tools being automatically updated when I update the
  ;; rest of my packages, since it would need the installation command and restart
  ;; each time it updated.
  :pin manual
  :mode  ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-loader-install)
  (setq-default pdf-view-display-size 'fit-height)
  (setq pdf-view-continuous nil) ;; Makes it so scrolling down to the bottom/top of a page doesn't switch to the next page
  (setq pdf-view-midnight-colors '("#ffffff" . "#121212" )) ;; I use midnight mode as dark mode, dark mode doesn't seem to work
  :general
  (:states 'motion :keymaps 'pdf-view-mode-map
                      "j" 'pdf-view-next-page
                      "k" 'pdf-view-previous-page

                      "C-j" 'pdf-view-next-line-or-next-page
                      "C-k" 'pdf-view-previous-line-or-previous-page

                      ;; Arrows for movement as well
                      (kbd "<down>") 'pdf-view-next-line-or-next-page
                      (kbd "<up>") 'pdf-view-previous-line-or-previous-page

                      (kbd "<down>") 'pdf-view-next-line-or-next-page
                      (kbd "<up>") 'pdf-view-previous-line-or-previous-page

                      (kbd "<left>") 'image-backward-hscroll
                      (kbd "<right>") 'image-forward-hscroll

                      "H" 'pdf-view-fit-height-to-window
                      "0" 'pdf-view-fit-height-to-window
                      "W" 'pdf-view-fit-width-to-window
                      "=" 'pdf-view-enlarge
                      "-" 'pdf-view-shrink

                      "q" 'quit-window
                      "Q" 'kill-this-buffer
                      "g" 'revert-buffer

                      "C-s" 'isearch-forward)
  )

(use-package popper
  :bind (("C-`"   . popper-toggle-latest)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Warnings\\*"
          help-mode
          compilation-mode))
  (popper-mode +1))
