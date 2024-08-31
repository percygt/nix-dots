;;; dired-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package dired
  :ensure nil
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    " " 'nil)
  (evil-define-key '(normal visual emacs) dired-mode-map
    "L" nil
    "H" nil
    "D" nil
    "r" 'dired-do-rename
    "R" 'dired-do-redisplay
    "y" 'dired-do-copy
    "d" 'dired-do-delete
    )
  )

(use-package dired-single
  :after dired
  :config
  (evil-define-key 'normal dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package diredfl
  :hook (dired-mode . diredfl-global-mode))


(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "." 'dired-hide-dotfiles-mode))


(provide 'dired-cfg)
;;; dired-cfg.el ends here
