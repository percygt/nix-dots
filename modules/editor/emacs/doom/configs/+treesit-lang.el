;;; +treesit-lang.el -*- lexical-binding: t; -*-
(require 'nix-mode)
(after! nix-ts-mode
  (set-keymap-parent nix-ts-mode-map nix-mode-map))
