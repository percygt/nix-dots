;;; common-cfg.el --- Common Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package multiple-cursors
  :general
  (global-definer
    "n" '(nil :wk "Multicursor")
    "nn" 'mc/mark-next-word-like-this
    "np" 'mc/mark-previous-word-like-this
    "na" 'mc/mark-all-like-this
    ))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (cc-ts-mode . aggressive-indent-mode)))

(use-package yequake
  :ensure nil
  :custom
  (yequake-frames
   '(("org-capture"
      (buffer-fns . (yequake-org-capture))
      (width . 0.75)
      (height . 0.5)
      (alpha . 0.95)
      (frame-parameters . ((undecorated . t)
                           (skip-taskbar . t)
                           (sticky . t)))))))
(provide 'common-cfg)
;;; common-cfg.el ends here
