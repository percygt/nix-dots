;;; dired-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package dired
  :ensure nil
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "L" 'nil
    "H" 'nil
    "D" 'nil
    "d" 'nil
    "r" 'dired-do-rename
    "R" 'dired-do-redisplay
    "y" 'dired-do-copy
    "d" 'dired-do-delete))

(use-package dired-single
  :after dired
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "l" 'dired-single-buffer
    "h" 'dired-single-up-directory))

(use-package diredfl
  :after dired
  :hook (dired-mode . diredfl-global-mode))

(use-package dired-open
  :after dired
  :custom
  (dired-open-extensions '(("png" . "feh")
                           ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "SPC" 'nil
    "."   'dired-hide-dotfiles-mode))

(provide 'dired-cfg)
;;; dired-cfg.el ends here
