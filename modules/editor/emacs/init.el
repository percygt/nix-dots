;;; init.el --- Init config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (require 'package)
;; (setq package-user-dir (expand-file-name  "var/packages/" user-emacs-data-directory))
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") )
;; (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") )

(package-initialize)

;; (unless package-archive-contents
;;   (package-refresh-contents))
;;
;; (require 'use-package-ensure)
;; (setq use-package-always-ensure t
;;       use-package-compute-statistics t
;;       use-package-verbose t)
;;

(add-to-list 'display-buffer-alist
	         '("\\*\\(Completions\\|Help\\)\\*"
	           (display-buffer-reuse-window display-buffer-pop-up-window)
	           (window-width . 60)
	           (side . right)
               (slot . 3)))

(add-to-list 'display-buffer-alist
	         '("\\*\\(eldoc\\)\\*"
	           (display-buffer-reuse-window display-buffer-in-side-window)
	           (window-width . 60)
               (window-parameters . ((no-other-window . t)(no-delete-other-windows . t)))
               (dedicated . t)
	           (side . right)
               (slot . 5)))

(add-to-list 'display-buffer-alist
	         '("\\*\\(compilation\\|Async\\)\\*"
	           (display-buffer-reuse-window display-buffer-in-side-window)
	           (window-width . 60)
               (window-parameters . ((no-other-window . t)(no-delete-other-windows . t)))
               (dedicated . t)
	           (side . right)
               (slot . 7)))

(add-to-list 'display-buffer-alist
	         '("\\*\\(Flymake diag.+\\)\\*"
	           (display-buffer-reuse-window display-buffer-in-side-window)
	           (window-width . 60)
	           (side . right)
               (slot . 2)))

(add-to-list 'display-buffer-alist
	         '("\\*\\(Compile-Log\\|Async-native-compile-log\\|Warnings\\)\\*"
	           (display-buffer-no-window)
	           (allow-no-window t)))

(add-to-list 'display-buffer-alist
	         '("\\*\\(Ibuffer\\|vc-dir\\|vc-diff\\|vc-change-log\\|Async Shell Command\\)\\*"
	           (display-buffer-full-frame)))

(add-to-list 'display-buffer-alist
	         '("\\(magit: .+\\|magit-log.+\\|magit-revision.+\\)"
	           (display-buffer-full-frame)))

(require 'use-package)

;; (require 'package-cfg)
(require 'core-cfg)
(require 'general-cfg)
(require 'common-cfg)
(require 'latex-cfg)
(require 'evil-cfg)
(require 'ui-cfg)
(require 'filetree-cfg)
(require 'lsp-cfg)
(require 'treesit-cfg)
(require 'minibuffer-cfg)
(require 'cmp-cfg)
(require 'dired-cfg)
(require 'git-cfg)
(require 'proglang-cfg)
(require 'shell-cfg)
(require 'spell-cfg)
(require 'org-cfg)
(require 'roam-cfg)
(require 'nursery-cfg)

(provide 'init)
;;; init.el ends here
