;;; spell-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package ispell
  :ensure nil
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "en")
  :config
  (ispell-set-spellchecker-params))

(use-package flyspell
  :ensure nil
  :after ispell
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))

  (dolist (mode '(
                  ;;org-mode-hook
                  mu4e-compose-mode-hook))
    (add-hook mode (lambda () (flyspell-mode 1))))

  (setq flyspell-issue-welcome-flag nil
        flyspell-issue-message-flag nil)

  :general ;; Switches correct word from middle click to right click
  (general-define-key :keymaps 'flyspell-mouse-map
                      "<mouse-3>" #'ispell-word
                      "<mouse-2>" nil)
  (general-define-key :keymaps 'evil-motion-state-map
                      "zz" #'ispell-word)
  :bind ("C-c s" . flyspell-mode))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)))

(provide 'spell-cfg)
;;; spell-cfg.el ends here
