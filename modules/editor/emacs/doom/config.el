;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(add-to-list 'term-file-aliases '("foot" . "xterm"))
(load! "system" doom-user-dir t)
(load! "nix" doom-user-dir t)

(setq doom-theme 'doom-city-lights
      doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 22))

(setq evil-emacs-state-cursor   `("brightmagenta" bar)
      evil-insert-state-cursor  `("cyan" bar)
      evil-normal-state-cursor  `("white" box)
      evil-visual-state-cursor  `("peachpuff" box))

(setq evil-snipe-override-evil-repeat-keys nil)

(after! doom-themes
  (defun my/doom-fix-client-frame (frame)
    (when (display-graphic-p frame)
      (with-selected-frame frame
        (set-frame-parameter frame 'background-color "#00051a"))))

  ;; emacsclient -c frames
  (add-hook 'after-make-frame-functions #'my/doom-fix-client-frame)

  ;; first GUI frame (daemon startup)
  (when (display-graphic-p)
    (set-frame-parameter nil 'background-color "#00051a")))

(when (not (display-graphic-p))
  (custom-theme-set-faces! 'doom-city-lights `(default :background nil)))

(custom-set-faces!
  `(default :foreground "white")
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

(load! "lisps/completion.el")
(load! "lisps/dired.el")
(load! "lisps/eglot.el")
(load! "lisps/elfeed.el")
(load! "lisps/extra.el")
(load! "lisps/keymaps.el")
(load! "lisps/minibuffer.el")
(load! "lisps/pdf.el")
(load! "lisps/spell.el")
(load! "lisps/treesit-lang.el")
(load! "lisps/treesit.el")

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
