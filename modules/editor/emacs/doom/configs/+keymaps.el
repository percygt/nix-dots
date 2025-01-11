;;; +bindings.el -*- lexical-binding: t; -*-

;; Local leader keys
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "M-,")

(setq evil-want-fine-undo t
      evil-split-window-below t
      evil-vsplit-window-right t)

;; Focus new window after splitting
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))
(map! :after evil
      :mn "C-e" #'evil-end-of-line
      :mn "C-b" #'evil-beginning-of-line)
(map! :mn "C-s" #'save-buffer
      :mn "D" #'doom/save-and-kill-buffer
      :mn "M-<backspace>" #'doom/kill-buried-buffers)

(map! :leader
      :desc "Load config files" "l" #'load-file
      :desc "Switch to recent buffer" "." #'(lambda ()
                                              (interactive)
                                              (switch-to-buffer (other-buffer (current-buffer))))
      :desc "Open buffer menu" "," #'switch-to-buffer)
(map! :leader
      :after org-roam
      "r" #'org-roam-review)

(map! :leader
      :prefix-map ("c" . "code")
      (:when (modulep! :tools lsp +eglot)
        :desc "LSP Execute code action" "a" #'eglot-code-actions
        :desc "LSP Rename" "r" #'eglot-rename
        :desc "LSP Find declaration"                 "j"   #'eglot-find-declaration
        (:when (modulep! :completion vertico)
          :desc "Jump to symbol in current workspace" "j"   #'consult-eglot-symbols))
      :desc "Compile"                               "c"   #'compile
      :desc "Recompile"                             "C"   #'recompile
      :desc "Jump to definition"                    "d"   #'+lookup/definition
      :desc "Jump to references"                    "D"   #'+lookup/references
      :desc "Evaluate buffer/region"                "e"   #'+eval/buffer-or-region
      :desc "Evaluate & replace region"             "E"   #'+eval:replace-region
      :desc "Format buffer/region"                  "f"   #'+format/region-or-buffer
      :desc "Find implementations"                  "i"   #'+lookup/implementations
      :desc "Jump to documentation"                 "k"   #'+lookup/documentation
      :desc "Send to repl"                          "s"   #'+eval/send-region-to-repl
      :desc "Find type definition"                  "t"   #'+lookup/type-definition
      :desc "Delete trailing whitespace"            "w"   #'delete-trailing-whitespace
      :desc "Delete trailing newlines"              "W"   #'doom/delete-trailing-newlines
      :desc "List errors"                           "x"   #'+default/diagnostics)
