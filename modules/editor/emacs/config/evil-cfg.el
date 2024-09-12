;;; evil-cfg.el --- Evil Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

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

;; (use-package avy
;;   :bind (:map evil-normal-state-map
;;               ("M-s" . avy-goto-char)))

(use-package move-text
  :bind (:map evil-normal-state-map
	      ("M-k" . move-text-up)
	      ("M-j" . move-text-down))
  :config
  (move-text-default-bindings))

(provide 'evil-cfg)
;;; evil-cfg.el ends here
