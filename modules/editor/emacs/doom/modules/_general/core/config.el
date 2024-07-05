;;; _general/core/config.el -*- lexical-binding: t; -*-
(map! :map minibuffer-local-map
      "ESC" #'abort-recursive-edit)
(map! :map minibuffer-local-ns-map
      "ESC" #'abort-recursive-edit)
(map! :map minibuffer-local-isearch-map
      "ESC" #'abort-recursive-edit)
(map! :map minibuffer-local-must-match-map
      "ESC" #'abort-recursive-edit)
(map! :map minibuffer-local-completion-map
      "ESC" #'abort-recursive-edit)
