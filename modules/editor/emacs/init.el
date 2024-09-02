;;; init.el --- Init config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'package)
(setq package-user-dir (expand-file-name  "var/packages/" user-emacs-data-directory))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") )
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") )

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package-ensure)
(setq use-package-always-ensure t
      use-package-compute-statistics t
      use-package-verbose t)

(require 'use-package)

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
