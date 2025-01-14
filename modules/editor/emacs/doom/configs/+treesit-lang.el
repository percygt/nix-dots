;;; +treesit-lang.el -*- lexical-binding: t; -*-
(use-package! nix-ts-mode
  :after nix-mode
  :config
  (require 'nix-mode)
  (set-keymap-parent nix-ts-mode-map nix-mode-map))

(use-package! clojure-ts-mode
  :after clojure-mode
  :config
  (require 'clojure-mode)
  (set-keymap-parent clojure-ts-mode-map clojure-mode-map))
