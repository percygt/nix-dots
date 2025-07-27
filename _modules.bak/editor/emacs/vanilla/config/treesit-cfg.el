;;; treesit-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
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

(provide 'treesit-cfg)
;;; treesit-cfg.el ends here
