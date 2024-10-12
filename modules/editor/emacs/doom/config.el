;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; Settings I may need to tweak from time-to time are set here. This helps me
;; locate them them easily with a key sequence, rather than having to dig
;; through Doom modules.


;;; Keybindings

;; (map!
;;  :mn "U" 'harpoon-quick-menu-hydra
;;  :mn "C-s" 'harpoon-add-file
;;
;;  ;; Global bindings to match what I have in terminals.
;;  :gniv "C-t"  #'project-find-file
;;  :gniv "C-/"  #'+vertico/project-search
;;
;;  (:after evil-collection-magit
;;   :map 'magit-status-mode-map
;;   :niv "C-t" nil))

(setq doom-theme  'modus-vivendi-tinted)
(setq shell-file-name (executable-find "bash"))

;;; org-mode

(setq
 org-directory          "~/org"
 org-roam-directory     (file-name-concat org-directory "roam")
 ;; +bibfiles              (list (file-name-concat org-directory "org-roam.bib"))
 ;; +roam-litnotes-paths   (list (file-name-concat org-roam-directory "litnotes"))
 ;; +roam-index-node-id    "0F0670F7-A280-4DD5-8FAC-1DB3D38CD37F"
 ;; +git-auto-commit-dirs  (list org-directory)
 ispell-dictionary      "en_US")


;;; LSP

(add-hook! (c-ts-base-mode
            bash-ts-mode
            docker-ts-mode
            java-ts-mode
            json-mode
            json-ts-mode
            markdown-mode
            nix-mode
            rust-ts-mode
            rustic-mode
            ;; typescript-ts-mode
            yaml-ts-mode
            zig-mode)
           #'lsp!)

(add-hook! (java-ts-mode
            typescript-ts-mode)
           #'eglot-organize-imports-on-save-mode)


;;; Theme
;;
;; See `+theme-settings' for general theme & face settings.

;; (setq
;;  doom-font                 (font-spec :font "VictorMono NFP Medium" :size 18)
;;  doom-variable-pitch-font  (font-spec :font "Work Sans Light" :size 18
;;  doom-big-font             (font-spec :font "VictorMono NFP Medium" :size 24)
;; ))
;; in $DOOMDIR/config.el
(setq doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))
;; (setq doom-theme 'base16-materia)
;; (with-demoted-errors "Error enabling theme on startup: %S"
;;   (+theme-update))

(setq +indent-guides-enabled-modes
      '(yaml-mode yaml-ts-mode nxml-mode python-ts-mode))

(setq-hook! (dired-mode treemacs-mode)
  display-line-numbers nil)


;;; Files & Projects

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

;; (after! project
;;   (mapc #'project-remember-projects-under
;;         `("~/.config/" "~/data/" ,@(f-directories "~/data"))))
