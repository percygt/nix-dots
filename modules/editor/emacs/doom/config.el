;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir)
(load! "nix" doom-user-dir)

(setq shell-file-name (executable-find "bash"))
(setq display-line-numbers-type 'relative)

;; do both in `lisp-interaction-mode'.
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

;; Local leader keys
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

;;
;;; UI
;;

(setq doom-theme 'modus-vivendi-tinted
      doom-font (font-spec :family "VictorMono NFP" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 18 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))
;;
;; Auto adjust window size
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)
;;
;; Transparent background
(push '(alpha-background . 70) default-frame-alist)
;;
;; Prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;;
;;; Keybindings
;;

(map! :mn "WW" #'save-buffer
      :mn "D" #'doom/save-and-kill-buffer
      :mn "C-D" #'doom/kill-buried-buffers)

(map! :leader
      :desc "Load config files" "l" #'load-file
      :desc "Switch to recent buffer" "." #'(lambda ()
                                              (interactive)
                                              (switch-to-buffer (other-buffer (current-buffer))))
      :desc "Open buffer menu" "," #'switch-to-buffer
      :desc "Files" "f" #'dirvish)

(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)

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

;;
;;; Modules
;;

;;
;;; :completion
;;

;;; :completion corfu
(map! :after corfu
      :map corfu-map
      "TAB" #'corfu-next
      "S-<return>" #'corfu-insert)
(map! :after dirvish
      :map dirvish-mode-map
      :n "o" #'dired-create-empty-file)

;;
;;; :editor
;;

;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;
;;; :emacs
;;

;;; :emacs dired
(after! dired
  (setq dired-listing-switches "-l --almost-all --human-readable --group-directories-first --no-group"))
(after! dirvish
  (setq dirvish-default-layout '(0 0.4 0.6))
  (with-eval-after-load 'nerd-icons
    (setq dirvish-path-separators (list (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                        (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                        (format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))))

;;
;;; :lang
;;

;;; :lang (org +dragndrop +roam2 +pretty +present)
(setq org-directory orgDirectory
      org-roam-directory (file-name-concat org-directory "roam")
      org-roam-db-location (file-name-concat org-directory ".org-roam.db")
      org-roam-dailies-directory "journal/"
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory))
(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "todo" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\n%i\n%a"
           :prepend t)
          ("d" "deadline" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nDEADLINE: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("s" "schedule" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("c" "check out later" entry (file+headline "todo.org" "Check out later")
           "* [ ] %?\n%i\n%a"
           :prepend t))))
(after! org-roam
  ;; Offer completion for #tags and @areas separately from notes.
  (add-to-list 'org-roam-completion-functions #'org-roam-complete-tag-at-point)
  ;; Automatically update the slug in the filename when #+title: has changed.
  (add-hook 'org-roam-find-file-hook #'org-roam-update-slug-on-save-h)
  ;; Make the backlinks buffer easier to peruse by folding leaves by default.
  (add-hook 'org-roam-buffer-postrender-functions #'magit-section-show-level-2)
  ;; List dailies and zettels separately in the backlinks buffer.
  (advice-add #'org-roam-backlinks-section :override #'org-roam-grouped-backlinks-section)
  ;; Open in focused buffer, despite popups
  (advice-add #'org-roam-node-visit :around #'+popup-save-a)
  ;; Make sure tags in vertico are sorted by insertion order, instead of
  ;; arbitrarily (due to the use of group_concat in the underlying SQL query).
  (advice-add #'org-roam-node-list :filter-return #'org-roam-restore-insertion-order-for-tags-a)
  ;; Add ID, Type, Tags, and Aliases to top of backlinks buffer.
  (advice-add #'org-roam-buffer-set-header-line-format :after #'org-roam-add-preamble-a))

;;
;;; :tools
;;

;;; :tools (lsp +eglot)
(after! eglot
  (setq-default
   eglot-workspace-configuration
   '((:pylsp . (:plugins
                (:ruff (:enabled t :lineLength 88)
	         :jedi_completion (:enabled t)
	         :pycodestyle (:enabled :json-false)
	         :pylint (:enabled :json-false)
	         :mccabe (:enabled :json-false)
	         :pyflakes (:enabled :json-false)
	         :yapf (:enabled :json-false)
	         :autopep8 (:enabled :json-false)
	         :black (:enabled :json-false))))
     (:nil . (:nix
              (:flake (:autoArchive t))))
     )))
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

;;
;;;Misc
;;

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
