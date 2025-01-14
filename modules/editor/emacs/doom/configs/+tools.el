;;; +tools.el -*- lexical-binding: t; -*-
;;;

(use-package! simpleclip
  :config
  (if (display-graphic-p)
      ((simpleclip-mode 1)
       (defun paste-in-minibuffer ()
         (local-set-key (kbd "C-V") 'simpleclip-paste))
       (add-hook 'minibuffer-setup-hook 'paste-in-minibuffer))
    ))
(map! :after simpleclip
      :map simpleclip-mode-map
      "C-S-v" #'simpleclip-paste
      )
(map! :after simpleclip
      :map simpleclip-mode-map
      :leader
      "y" #'simpleclip-copy
      )
