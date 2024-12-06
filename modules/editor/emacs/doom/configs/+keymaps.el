;;; +bindings.el -*- lexical-binding: t; -*-

;; Local leader keys
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

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

(setq evil-want-fine-undo t
      evil-split-window-below t
      evil-vsplit-window-right t)

(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)
(map! :mn "WW" #'save-buffer
      :mn "D" #'doom/save-and-kill-buffer
      :mn "M-<backspace>" #'doom/kill-buried-buffers)

(map! :leader
      :desc "Load config files" "l" #'load-file
      :desc "Switch to recent buffer" "." #'(lambda ()
                                              (interactive)
                                              (switch-to-buffer (other-buffer (current-buffer))))
      :desc "Open buffer menu" "," #'switch-to-buffer
      :desc "Files" "f" #'dirvish-dwim)

(map! :leader
      :after org-roam
      "r" #'org-roam-review)

(map! :after org
      :leader
      :desc "Org Capture" "c" #'org-capture
      )
