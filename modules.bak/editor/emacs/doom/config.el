;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir t)
(load! "nix" doom-user-dir t)

(add-to-list 'term-file-aliases '("foot" . "xterm"))
(setq doom-theme 'doom-city-lights
      doom-font (font-spec :family "VictorMono NFP" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 20 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(setq evil-emacs-state-cursor   `("brightmagenta" bar)
      evil-insert-state-cursor  `("cyan" bar)
      evil-normal-state-cursor  `("white" box)
      evil-visual-state-cursor  `("peachpuff" box))

(setq evil-snipe-override-evil-repeat-keys nil)

(if (display-graphic-p)
    (custom-theme-set-faces! 'doom-city-lights `(default :background "#00051a")
      (set-frame-parameter nil 'alpha-background 80) ; For current frame
      (add-to-list 'default-frame-alist '(alpha-background . 80)) )
  (custom-theme-set-faces! 'doom-city-lights `(default :background nil)))

(custom-set-faces!
  `(mode-line-inactive :background "#00051a")
  `(fringe :background nil)
  `(vertical-border :background "#081028")
  `(line-number :background nil)
  `(show-paren-match :background "#00051a" :foreground "yellow")
  `(mode-line-active :background "#081028")
  `(hl-line :background "#081028")
  `(header-line :background "#081028"))

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

(setq display-line-numbers-type 'relative)
(setq confirm-kill-emacs nil)
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)
(global-subword-mode 1)                           ; Iterate through CamelCase words
(pixel-scroll-precision-mode t)
(plist-put +popup-defaults :quit t)

(load! "configs/init.el")

(pushnew! vc-directory-exclusion-list
          "node_modules"
          "cdk.out"
          "target"
          ".direnv")

(pushnew! completion-ignored-extensions
          ".DS_Store"
          ".eln"
          ".drv"
          ".direnv/"
          ".git/")

(defun +config-recursive-list-directories (dir max-level &optional level)
  "Recursively list directory"
  (let ((level (or level 0)))
    (when (< level max-level)
      (let ((subdirs (seq-filter #'file-directory-p
                                 (directory-files dir t "^[^.]"))))
        (append (mapcar (lambda (subdir) (concat subdir "/")) subdirs)
                (apply #'append
                       (mapcar (lambda (subdir)
                                 (+config-recursive-list-directories subdir max-level (1+ level)))
                               subdirs)))))))

(if (require 'projectile nil 'noerror)
    (progn
      (setq projectile-project-search-path dataDirectory)
      (projectile-discover-projects-in-directory dataDirectory 4))
  (let ((project-dirs (+config-recursive-list-directories dataDirectory 4)))
    (dolist (dir project-dirs)
      (when-let ((proj (project-current nil dir)))
        (project-remember-project proj)))))
