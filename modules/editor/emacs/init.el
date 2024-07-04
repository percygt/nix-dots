;;; init.el --- Init config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(package-initialize)

(require 'core-cfg)
(require 'evil-cfg)
(require 'ui-cfg)
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

(provide 'init)
;;; init.el ends here
