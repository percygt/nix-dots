;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load (expand-file-name "private.el" doom-user-dir))
(load (expand-file-name "nix.el" doom-user-dir))

;;; Keybindings
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-;")
(setq shell-file-name (executable-find "bash"))
(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)

(map! :mn "WW" #'save-buffer
      :mn "D" #'doom/save-and-kill-buffer
      :mn "C-D" #'doom/kill-buried-buffers)

(map! :map minibuffer-local-map
      "<escape>" #'abort-recursive-edit
      :map minibuffer-local-ns-map
      "<escape>" #'abort-recursive-edit
      :map minibuffer-local-isearch-map
      "<escape>" #'abort-recursive-edit
      :map minibuffer-local-must-match-map
      "<escape>" #'abort-recursive-edit
      :map minibuffer-local-completion-map
      "<escape>" #'abort-recursive-edit)

(map! :after affe
      :leader
      :prefix ("s" . "Search")
      "f" #'affe-find
      "g" #'affe-grep)

(map! :after consult
      :leader
      :prefix ("s" . "Search")
      "F" #'consult-fd
      "l" #'consult-line
      "o" #'consult-outline)

(map! :leader
      :desc "Load config files" "l" #'load-file
      :desc "Switch to recent buffer" "." #'(lambda ()
                                              (interactive)
                                              (switch-to-buffer (other-buffer (current-buffer))))
      :desc "Open buffer menu" "," #'switch-to-buffer
      :desc "Files" "f" #'dirvish)

;;; UI
(push '(alpha-background . 70) default-frame-alist)

(setq doom-theme 'modus-vivendi-tinted
      doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(setq frame-inhibit-implied-resize          t
      frame-resize-pixelwise                t)

;;; Completion
(map! :after corfu
      :map corfu-map
      "TAB" #'corfu-next
      "S-<return>" #'corfu-insert)

(map! :after dirvish
      :map dirvish-mode-map
      :n "o" #'dired-create-empty-file)

;;; Dired
(after! dirvish
  (setq dirvish-default-layout '(0 0.4 0.6))
  (with-eval-after-load 'nerd-icons
    (setq dirvish-path-separators (list (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                        (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                        (format " %s " (nerd-icons-faicon "nf-fa-angle_right")))))
  )

;;;Eglot
(after! eglot
  (setq-default eglot-workspace-configuration
	        '(
                  (:pylsp . (:plugins (
				       :ruff (:enabled t :lineLength 88)
				       ;; :pylsp_mypy (:enabled t
				       ;;              :report_progress t
				       ;;              :live_mode :json-false)
				       :jedi_completion (:enabled t)
				       :pycodestyle (:enabled :json-false)
				       :pylint (:enabled :json-false)
				       :mccabe (:enabled :json-false)
				       :pyflakes (:enabled :json-false)
				       :yapf (:enabled :json-false)
				       :autopep8 (:enabled :json-false)
				       :black (:enabled :json-false))))
                  (:nil . (:nix (:flake (:autoArchive t))))
                  )))
;;; org-mode
;;; LSP

(add-hook! (c-ts-base-mode
            bash-ts-mode
            docker-ts-mode
            java-ts-mode
            json-mode
            json-ts-mode
            markdown-mode
            nix-mode
            nix-ts-mode
            lua-mode
            lua-ts-mode
            python-mode
            python-ts-mode
            go-mode
            go-ts-mode
            rust-ts-mode
            rustic-mode
            typescript-ts-mode
            yaml-ts-mode
            zig-mode)
           #'lsp!)

(setq
 org-directory          notesDirectory
 org-roam-directory     (file-name-concat org-directory "roam")
 ispell-dictionary      "en_US")

;; (with-demoted-errors "Error enabling theme on startup: %S"
;;   (+theme-update))
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
