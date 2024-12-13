;;; +completion.el -*- lexical-binding: t; -*-
;;; :completion corfu
(map! :leader
      :prefix ("s" . "Search")
      :desc "Search current directory"         "d" #'+default/search-cwd
      :desc "Search other directory"           "D" #'+default/search-other-cwd
      :desc "Search .emacs.d"                  "e" #'+default/search-emacsd
      :desc "Jump to symbol"                   "i" #'imenu
      :desc "Jump to visible link"             "l" #'link-hint-open-link
      :desc "Jump to link"                     "L" #'ffap-menu
      :desc "Jump list"                        "j" #'evil-show-jumps
      :desc "Jump to bookmark"                 "m" #'bookmark-jump
      :desc "Look up online"                   "o" #'+lookup/online
      :desc "Look up online (w/ prompt)"       "O" #'+lookup/online-select
      :desc "Look up in local docsets"         "k" #'+lookup/in-docsets
      :desc "Look up in all docsets"           "K" #'+lookup/in-all-docsets
      :desc "Search project"                   "p" #'+default/search-project
      :desc "Search other project"             "P" #'+default/search-other-project
      :desc "Jump to mark"                     "r" #'evil-show-marks
      :desc "Search buffer"                    "s" #'+default/search-buffer
      :desc "Dictionary"                       "t" #'+lookup/dictionary-definition
      :desc "Thesaurus"                        "T" #'+lookup/synonyms
      :desc "Find file"                        "f" #'consult-fd
      :desc "Dictionary"                       "g" #'consult-ripgrep
      :desc "Dictionary"                       "l" #'consult-line
      :desc "Dictionary"                       "o" #'consult-outline
      :desc "Undo history"                     "u"  #'undo-tree-visualize
      :desc "Search buffer"                    "b" #'+default/search-buffer
      :desc "Search buffer for thing at point" "S" #'+vertico/search-symbol-at-point
      :desc "Jump to symbol in open buffers"   "I" #'consult-imenu-multi
      :desc "Search all open buffers"          "B" (cmd!! #'consult-line-multi 'all-buffers))

(map! :after corfu
      :map corfu-map
      "TAB" #'corfu-next
      "S-<return>" #'corfu-insert)

(map! :after vertico
      :map vertico-map
      "C-j" #'vertico-next
      "TAB" #'vertico-insert
      "C-k" #'vertico-previous)
