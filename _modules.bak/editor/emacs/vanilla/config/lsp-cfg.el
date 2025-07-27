;;; lsp-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

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
		        '(
                  (:pylsp . (:plugins (
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
				                       :black (:enabled :json-false))))
                  (:nil . (:nix (:flake (:autoArchive t))))
                  )))

(use-package eglot-booster
  :ensure nil
  :after eglot
  :config (eglot-booster-mode))

(provide 'lsp-cfg)
;;; lsp-cfg.el ends here
