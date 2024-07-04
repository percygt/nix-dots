;;; git-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package magit
  :bind ("C-x g" . magit-status)     ; Display the main magit popup
  :init (setq magit-log-arguments
              '("--graph" "--color" "--decorate" "--show-signature" "-n256")))


(provide 'git-cfg)
;;; git-cfg.el ends here
