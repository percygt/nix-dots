;;; +bindings.el -*- lexical-binding: t; -*-

;; Local leader keys
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

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
