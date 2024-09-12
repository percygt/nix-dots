
;;; minibuffer-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

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

;; just for looks
(use-package vertico-posframe
  :config
  (vertico-posframe-mode 1)
  :custom
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8))))

(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("TAB" . vertico-insert)
              ([tab] . vertico-insert)
              ;; ("ESCAPE" . minibuffer-force-complete-and-exit)
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
  :general
  (global-definer
    "s" '(nil :wk "Consult")
    "sf" 'consult-find
    "sg" 'consult-ripgrep
    "0"  'consult-buffer
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

(provide 'minibuffer-cfg)
;;; minibuffer-cfg.el ends here
