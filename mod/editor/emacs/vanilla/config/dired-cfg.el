;;; dired-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package dired
  :ensure nil
  :commands dired-jump
  :init
  (setq dired-dwim-target t  ; suggest a target for moving/copying intelligently
        ;; don't prompt to revert, just do it
        dired-auto-revert-buffer #'dired-buffer-stale-p
        ;; Always copy/delete recursively
        dired-recursive-copies  'always
        dired-recursive-deletes 'top
        ;; Ask whether destination dirs should get created when copying/removing files.
        dired-create-destination-dirs 'ask
        ;; Screens are larger nowadays, we can afford slightly larger thumbnails
        image-dired-thumb-size 150)
  :config
  )
(use-package dirvish
  :after dired
  :commands dirvish-find-entry-a dirvish-dired-noselect-a
  :init
  ;; HACK: ...
  (advice-add #'dired-find-file :override #'dirvish-find-entry-a)
  (advice-add #'dired-noselect :around #'dirvish-dired-noselect-a)
  :general
  (global-definer
   "f" 'dirvish)
  (normal-definer
   "C-c f" 'dirvish-fd)
  (normal-definer
   :keymaps '(dired-mode-map)
   "l"   'dired-find-file
   "h"   'dired-up-directory
   :keymaps '(dirvish-mode-map)
   "ESC" 'dirvish-quit
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
  ;; (dired-recursive-copies 'always)
  ;; (dired-recursive-deletes 'always)
  ;; (dired-dwim-target t)
  ;; (dired-clean-confirm-killing-deleted-buffers nil)
  ;; (dired-do-revert-buffer t)
  ;; (dired-auto-revert-buffer #'dired-directory-changed-p)
  (delete-by-moving-to-trash t)
  (dired-listing-switches "-l --almost-all --human-readable --group-directories-first --no-group")
  (dirvish-reuse-session nil)
  (dirvish-attributes '(nerd-icons file-time collapse subtree-state))
  (dired-mouse-drag-files t)                   ; added in Emacs 29
  (dired-kill-when-opening-new-dired-buffer t) ; added in Emacs 28
  (mouse-drag-and-drop-region-cross-program t) ; added in Emacs 29
  (mouse-1-click-follows-link nil)
  (dirvish-use-header-line t) ; 'global make header line span all panes
  (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-use-mode-line t)
  (dirvish-mode-line-format '(:left (sort file-time symlink) :right (omit yank index)))
  (dirvish-subtree-state-style 'nerd)
  (dirvish-default-layout '(0 0.4 0.6))
  (dirvish-preview-dispatchers '(image gif video audio epub pdf archive))
  :config
  (dirvish-override-dired-mode)
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  ;; Cscope generate *.po files which that makes dirvish preview freeze
  ;; (push "po" dirvish-preview-disabled-exts)
  ;; Use `nerd-icons' for path separators (from https://github.com/rainstormstudio/nerd-icons.el)
  (with-eval-after-load 'nerd-icons
    (setq dirvish-path-separators (list (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                        (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                        (format " %s " (nerd-icons-faicon "nf-fa-angle_right")))))
  ;; HACK: Fixes #8038. Because `dirvish-reuse-session' is unset above, when
  ;;   walking a directory tree, previous dired buffers are killed along the
  ;;   way, which is jarring for folks who expect to be able to switch back to
  ;;   those buffers before their dired session ends. As long as we retain
  ;;   those, Dirvish will still clean them up on `dirvish-quit'.
  (defun dired--retain-buffers-on-dirvish-find-entry-a (fn &rest args)
    (let ((dirvish-reuse-session t))
      (apply fn args)))

  (advice-add 'dirvish-find-entry-a :around #'dired--retain-buffers-on-dirvish-find-entry-a)
  )

;; Addtional syntax highlighting for dired
(use-package diredfl
  :hook
  ((dired-mode . diredfl-mode)
   ;; highlight parent and directory preview as well
   (dirvish-directory-view-mode . diredfl-mode))
  :config
  (set-face-attribute 'diredfl-dir-name nil :bold t))

(provide 'dired-cfg)
;;; dired-cfg.el ends here
