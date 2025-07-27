;;; +minibuffer.el -*- lexical-binding: t; -*-
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
