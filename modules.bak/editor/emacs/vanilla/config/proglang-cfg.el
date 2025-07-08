;;; proglang-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

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

;; Nix mode
(use-package nix-mode)
(use-package nix-ts-mode
  :mode (("\\.nix\\'" . nix-ts-mode))
  :hook (nix-ts-mode . eglot-ensure))

;; Lua mode
(use-package lua-mode)
(use-package lua-ts-mode
  :ensure nil
  :mode (("\\.lua\\'" . lua-ts-mode))
  :hook (lua-ts-mode . eglot-ensure))

;; Go mode
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

(use-package cider)
(use-package clojure-mode)
(use-package clj-refactor)
(use-package clojure-snippets)
;; (use-package flycheck-clj-kondo)
(use-package clojure-ts-mode
  :hook ((clojure-ts-mode . clj-refactor-mode)
         (clojure-ts-mode . cider-mode)))
(use-package markdown-mode
  :mode "\\.md\\'")
;; (use-package direnv
;;   :config (direnv-mode))

(provide 'proglang-cfg)
;;; proglang-cfg.el ends here
