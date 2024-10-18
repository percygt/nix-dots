;;; +eglot.el -*- lexical-binding: t; -*-
;;; :tools (lsp +eglot)
(after! eglot
  (setq-default
   eglot-workspace-configuration
   '((:pylsp . (:plugins
                (:ruff (:enabled t :lineLength 88)
	         :jedi_completion (:enabled t)
	         :pycodestyle (:enabled :json-false)
	         :pylint (:enabled :json-false)
	         :mccabe (:enabled :json-false)
	         :pyflakes (:enabled :json-false)
	         :yapf (:enabled :json-false)
	         :autopep8 (:enabled :json-false)
	         :black (:enabled :json-false))))
     (:nil . (:nix
              (:flake (:autoArchive t))))
     )))

(after! eglot
  (eglot-booster-mode +1))

(add-hook! (c-ts-base-mode
            bash-ts-mode
            docker-ts-mode
            java-ts-mode
            json-mode
            json-ts-mode
            markdown-mode
            nix-mode
            nix-ts-mode
            lua-mode
            lua-ts-mode
            python-mode
            python-ts-mode
            go-mode
            go-ts-mode
            rust-ts-mode
            rustic-mode
            typescript-ts-mode
            yaml-ts-mode
            zig-mode)
           #'lsp!)
