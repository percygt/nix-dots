;;; +evil.el -*- lexical-binding: t; -*-
;;; :editor evil

;; Focus new window after splitting
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(setq evil-split-window-below t
      evil-vsplit-window-right t)

(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)
