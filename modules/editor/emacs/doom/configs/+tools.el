;;; +tools.el -*- lexical-binding: t; -*-
;;;

(use-package! simpleclip :config (simpleclip-mode 1))
(map! :after simpleclip
      :map simpleclip-mode-map
      "C-S-v" #'simpleclip-paste
      )
(map! :after simpleclip
      :map simpleclip-mode-map
      :leader
      "y" #'simpleclip-copy
      )
;; Allows pasting in minibuffer with M-v
(defun jib/paste-in-minibuffer ()
  (local-set-key (kbd "C-V") 'simpleclip-paste))
(add-hook 'minibuffer-setup-hook 'jib/paste-in-minibuffer)
