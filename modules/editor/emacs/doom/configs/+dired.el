;;; +dired.el -*- lexical-binding: t; -*-
;;; :emacs dired
(map! :after dired
      :map dirvish-mode-map
      :n "<escape>" #'dirvish-quit
      :n "o"         #'dired-create-empty-file
      :n "O"         #'dired-create-directory)

(after! dired
  (setq dired-listing-switches "-l --almost-all --human-readable --group-directories-first --no-group"))

(after! dirvish
  (setq dirvish-default-layout '(0 0.4 0.6))
  (with-eval-after-load 'nerd-icons
    (setq dirvish-path-separators (list (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                        (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                        (format " %s " (nerd-icons-faicon "nf-fa-angle_right")))))

  (push '("h" "~/" "Home") dirvish-quick-access-entries)
  (push '("D" "~/downloads/" "Downloads") dirvish-quick-access-entries)
  (push '("m" "/media/" "Mounted drives") dirvish-quick-access-entries))
