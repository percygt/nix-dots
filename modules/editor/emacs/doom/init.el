;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!


(setq doom-modules-dirs
      (list (file-name-concat doom-user-dir "modules/")
            "~/org/modules/"
            doom-modules-dir))


(doom! :_general
       ;; core
       lsp
       ts-mode
       theme
       ;; extra
       cmp

       :config
       default ; Doom's built-in defaults

       :editor
       (evil +everywhere)
       file-templates
       (format +onsave)
       fold
       multiple-cursors
       rotate-text
       snippets
       word-wrap

       :emacs
       (dired +icons +dirvish)
       (ibuffer +icons)
       (undo +tree)
       vc

       :completion
       (corfu +icons +orderless +dabbrev)
       (vertico +icons)

       :checkers
       (spell +aspell +everywhere)

       :term
       eshell
       ;; eshell-exts

       :tools
       ;; debugging
       tree-sitter
       (docker +lsp)
       direnv
       editorconfig
       (eval +overlay)
       lookup
       (lsp +eglot)
       pdf
       ;; lsp-exts
       ;; nix
       (magit +forge)
       ;; vc-exts
       make
       ;; search
       (terraform +lsp)

       :lang
       data
       emacs-lisp
       (org +dragndrop +roam2 +pretty +present)
       (latex +lsp +fold)
       cc
       web
       (json +lsp)
       (python +poetry)
       (java +lsp)
       (lua +lsp)
       (nix +lsp)
       (ocaml +lsp)
       (rust +lsp)
       (sh +lsp)
       (javascript +lsp)
       (yaml +lsp)
       (zig +lsp)

       :ui
       doom-dashboard    ; a nifty splash screen for Emacs
       (popup +defaults +all)
       hl-todo
       indent-guides
       treemacs
       modeline
       ophints
       (vc-gutter +pretty)
       vi-tilde-fringe
       )
