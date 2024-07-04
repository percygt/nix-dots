;;; spell-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package ispell
  :ensure nil
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "en_US,en_PH")
  :config
  (ispell-set-spellchecker-params))
(use-package flyspell
  :ensure nil
  :after ispell
  :bind ("C-c s" . flyspell-mode))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)))

(provide 'spell-cfg)
;;; spell-cfg.el ends here
