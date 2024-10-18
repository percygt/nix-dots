;;; +evil.el -*- lexical-binding: t; -*-
;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)
