;;; dired-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package dirvish
  :after dired
  :demand
  :init
  (dirvish-override-dired-mode)
  :general
  (normal-definer
    "C-c f" 'dirvish-fd)
  (normal-definer
    :keymaps '(dired-mode-map)
    "l"   'dired-find-file
    "h"   'dired-up-directory
    :keymaps '(dirvish-mode-map)
    "q"   'dirvish-quit
    "a"   'dirvish-quick-access
    "f"   'dirvish-file-info-menu
    "y"   'dirvish-yank-menu
    "N"   'dirvish-narrow
    "^"   'dirvish-history-last
    "H"   'dirvish-history-jump ; remapped `describe-mode'
    "s"   'dirvish-quicksort    ; remapped `dired-sort-toggle-or-edit'
    "v"   'dirvish-vc-menu      ; remapped `dired-view-file'
    "TAB" 'dirvish-subtree-toggle
    "M-f" 'dirvish-history-go-forward
    "M-b" 'dirvish-history-go-backward
    "M-l" 'dirvish-ls-switches-menu
    "M-m" 'dirvish-mark-menu
    "M-t" 'dirvish-layout-toggle
    "M-s" 'dirvish-setup-menu
    "M-e" 'dirvish-emerge-menu
    "M-j" 'dirvish-fd-jump)
  :custom
  (dirvish-attributes '(nerd-icons file-time collapse subtree-state))
  (delete-by-moving-to-trash t)
  (dirvish-reuse-session nil)
  (dired-listing-switches "-l --almost-all --human-readable --group-directories-first --no-group")
  (dirvish-mode-line-format '(:left (sort file-time symlink) :right (omit yank index)))
  (dirvish-side-width 30)
  (dirvish-fd-default-dir "~/")
  (dirvish-use-header-line t) ; 'global make header line span all panes
  (dirvish-use-mode-line t)
  (dirvish-subtree-state-style 'nerd)
  (dirvish-default-layout '(0 0.4 0.6))
  :config
  (dirvish-peek-mode) ; Preview files in minibuffer
  (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  ;; Cscope generate *.po files which that makes dirvish preview freeze
  (push "po" dirvish-preview-disabled-exts)
  ;; Use `nerd-icons' for path separators (from https://github.com/rainstormstudio/nerd-icons.el)
  (with-eval-after-load 'nerd-icons
    (setq dirvish-path-separators (list (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                        (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                        (format " %s " (nerd-icons-faicon "nf-fa-angle_right")))))
  )

;; (use-package dired-single
;;   :after dired
;;   :general
;;   (normal-definer
;;     :keymaps '(dired-mode-map)
;;     "l" 'dired-single-buffer
;;     "h" 'dired-single-up-directory))

;; Addtional syntax highlighting for dired
(use-package diredfl
  :hook
  ((dired-mode . diredfl-mode)
   ;; highlight parent and directory preview as well
   (dirvish-directory-view-mode . diredfl-mode))
  :config
  (set-face-attribute 'diredfl-dir-name nil :bold t))
;; (use-package diredfl
;;   :after dired
;;   :hook (dired-mode . diredfl-global-mode))


(use-package dired-hide-dotfiles
  :general
  (normal-definer
    :keymaps '(dired-mode-map)
    "SPC" 'nil
    "."   'dired-hide-dotfiles-mode))

(provide 'dired-cfg)
;;; dired-cfg.el ends here
