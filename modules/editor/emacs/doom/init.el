;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(load! "private" doom-user-dir)

(setq doom-modules-dirs
      (list (file-name-concat doom-user-dir "modules/")
            (file-name-concat orgDirectory "modules/")
            doom-modules-dir))

(doom! :completion
       ;; (company +childframe)
       (corfu +icons +orderless +dabbrev)
       ;;ivy
       ;;helm
       ;;ido
       (vertico +icons)

       :ui
       ;;deft
       doom
       doom-dashboard
       ;;doom-quit
       ;;(emoji +unicode)
       ;;fill-column
       hl-todo
       ;;hydra
       ;;indent-guides     ; highlighted indent columns
       (ligatures +extra)
       ;;minimap
       modeline
       nav-flash
       ;;neotree
       ophints
       (popup +defaults)
       ;;treemacs
       ;;tree-sitter
       ;;unicode
       ;;tabs
       (vc-gutter +diff-hl +pretty)
       window-select
       ;;workspaces
       ;;zen
       vi-tilde-fringe

       :input
       ;;chinese
       ;;japanese

       :editor
       (evil +everywhere)
       file-templates
       fold              ; (nigh) universal code folding
       ;;objed
       (format +onsave)   ; automated prettiness
       ;;lispy             ; vim for lisp, for people who dont like vim
       multiple-cursors  ; editing in many places at once
       ;;parinfer          ; turn lisp into python, sort of
       rotate-text       ; cycle region at point between text candidates
       snippets
       ;; word-wrap

       :emacs
       (dired +icons +dirvish)             ; making dired pretty [functional]
       ;; electric          ; smarter, keyword-based electric-indent
       (ibuffer +icons)        ; interactive buffer management
       (undo +tree)
       vc

       :term
       eshell            ; a consistent, cross-platform shell (WIP)
       ;;shell
       ;;term              ; terminals in Emacs
       vterm

       :checkers
       syntax
       (spell +everywhere)
       ;;grammar

       :tools
       tree-sitter
       ;;ansible
       ;;(debugger +lsp)
       direnv
       ;;docker
       editorconfig      ; let someone else argue about tabs vs spaces
       ;;ein               ; tame Jupyter notebooks with emacs
       (eval +overlay)
       ;;gist
       (lookup +docsets +dictionary)
       (lsp +eglot)
       ;;macos             ; MacOS-specific commands
       (magit +forge)
       ;;make              ; run make tasks from Emacs
       ;;pass                ; password manager for nerds
       pdf               ; pdf enhancements
       ;;prodigy           ; FIXME managing external services & code builders
       ;;rgb               ; creating color strings
       (terraform +lsp)    ; infrastructure as code
       ;;tmux              ; an API for interacting with tmux
       ;;upload            ; map local to remote projects via ssh/ftp

       :os
       (tty +osc)               ; enable terminal integration

       :lang
       (org +roam2)
       cc
       data
       emacs-lisp
       (clojure +lsp)
       (javascript +lsp)
       (json +lsp)
       (latex +lsp +fold)
       (lua +lsp)
       (nix +lsp)
       (rust +lsp)
       (sh +lsp)
       (yaml +lsp)
       (zig +lsp)

       :email
       ;;(mu4e +gmail)       ; WIP
       ;;notmuch             ; WIP
       ;;(wanderlust +gmail) ; WIP

       :app
       ;;calendar
       ;;everywhere
       ;;irc
       ;;(rss +org)
       ;;ereader

       :config
       ;;literate
       (default +bindings))
