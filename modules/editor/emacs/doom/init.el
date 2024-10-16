;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(load! "private" doom-user-dir)

(setq doom-modules-dirs
      (list (file-name-concat doom-user-dir "modules/")
            (file-name-concat orgDirectory "modules/")
            doom-modules-dir))


(doom! :_custom
       eglot
       cmp
       ts-mode
       theme

       :checkers
       (spell +aspell +everywhere)

       :completion
       (corfu +icons +orderless +dabbrev)
       (vertico +icons)

       :config
       default

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


       :lang
       cc
       data
       emacs-lisp
       (java +lsp)
       (javascript +lsp)
       (json +lsp)
       (latex +lsp +fold)
       (lua +lsp)
       (nix +lsp)
       (ocaml +lsp)
       (org +dragndrop +roam2 +pretty +present)
       (python +poetry)
       (rust +lsp)
       (sh +lsp)
       web
       (yaml +lsp)
       (zig +lsp)
       (org-exts
        +citations
        ;; +initial-buffers
        +modern
        +nursery
        +roam
        +slack)

       :term
       eshell

       :tools
       direnv
       (docker +lsp)
       editorconfig
       (eval +overlay)
       lookup
       (lsp +eglot)
       (magit +forge)
       make
       pdf
       (terraform +lsp)
       tree-sitter

       :ui
       doom-dashboard
       hl-todo
       indent-guides
       modeline
       ophints
       (popup +defaults +all)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       )