;;; shell-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package eat
  :custom
  (eat-enable-auto-line-mode t)
  :bind (("C-x E" . eat)
         :map project-prefix-map
         ("t" . eat-project)))

(use-package fish-mode)

(use-package eshell
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

(provide 'shell-cfg)
;;; shell-cfg.el ends here
