;;; +treesit-lang.el -*- lexical-binding: t; -*-
(require 'nix-mode)
(after! nix-ts-mode
  (set-keymap-parent nix-ts-mode-map nix-mode-map))

(require 'clojure-mode)
(after! clojure-ts-mode
  (set-keymap-parent clojure-ts-mode-map clojure-mode-map))
