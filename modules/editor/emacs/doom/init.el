;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!


(setq doom-modules-dirs
      (list (file-name-concat doom-user-dir "modules/")
            "~/org/modules/"
            doom-modules-dir))

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' to
;;      view its documentation. This works on flags as well (those symbols that
;;      start with a plus).
;;
;;      Alternatively, press 'gd' on a module to browse its directory (for easy
;;      access to its source code).

(doom! :_general
       core
       ui
       extra
       :config
       (default +smartparens) ; Doom's built-in defaults
       ;; default-exts

       :editor
       (evil +everywhere)
       ;; evil-exts
       file-templates
       (format +onsave)
       fold
       multiple-cursors
       rotate-text
       ;; smartparens-exts
       snippets
       ;; snippets-exts
       word-wrap

       :emacs
       (dired +icons +dirvish)
       ;; dired-exts
       (ibuffer +icons)
       (undo +tree)
       ;; ediff-exts
       vc
       ;; vc-exts

       :completion
       (corfu +icons +orderless +dabbrev)
       (vertico +childframe +icons)

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
       ;; asm
       (cc +tree-sitter)
       data
       emacs-lisp
       ;; emacs-lisp-exts
       (elixir +tree-sitter +lsp)
       ;; (graphql +lsp)
       (json +tree-sitter +lsp)
       (java +tree-sitter +lsp)
       (latex +lsp +fold)
       (lua +tree-sitter +lsp)
       (nix +tree-sitter +lsp)

       (ocaml +tree-sitter +lsp)
       (org +dragndrop +roam2)
       ;; (org-exts
       ;;  +citations
       ;;  ;; +initial-buffers
       ;;  +modern
       ;;  +nursery
       ;;  +roam
       ;;  +slack)

       (rust +tree-sitter +lsp)
       (sh +tree-sitter +lsp)
       (javascript +tree-sitter +lsp)
       ;; (typescript +tree-sitter +lsp)
       (web +tree-sitter +lsp)
       (yaml +tree-sitter +lsp)
       (zig +tree-sitter +lsp)

       :ui
       ;; doom
       doom-dashboard    ; a nifty splash screen for Emacs
       ;; doom-exts
       (popup +defaults +all)
       hl-todo
       indent-guides
       ;; leader
       treemacs
       ;; (ligatures +fira)
       modeline
       ophints
       (vc-gutter +pretty)
       vi-tilde-fringe

       ;; :private
       ;; org
       )
