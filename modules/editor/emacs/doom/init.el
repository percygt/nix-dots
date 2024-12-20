;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(load! "private" doom-user-dir)

(setq doom-modules-dirs
      (list (file-name-concat doom-user-dir "modules/")
            (file-name-concat orgDirectory "modules/")
            doom-modules-dir))


(doom! :checkers
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
       (org +journal +dragndrop +roam2)
       cc
       data
       emacs-lisp
       (clojure +lsp)
       (java +lsp)
       (javascript +lsp)
       (json +lsp)
       (latex +lsp +fold)
       (lua +lsp)
       (nix +lsp)
       (ocaml +lsp)
       (python +poetry)
       (rust +lsp)
       (sh +lsp)
       web
       (yaml +lsp)
       (zig +lsp)

       :term
       eshell
       vterm

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
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (ligatures +extra)
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       ;; zen
       )
