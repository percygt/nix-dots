;;; +completion.el -*- lexical-binding: t; -*-
;;; :completion corfu
(map! :after corfu
      :map corfu-map
      "TAB" #'corfu-next
      "S-<return>" #'corfu-insert)

(map! :after affe
      :leader
      :prefix ("s" . "Search")
      "f" #'affe-find
      "g" #'affe-grep)

(map! :after consult
      :leader
      :prefix ("s" . "Search")
      "F" #'consult-fd
      "l" #'consult-line
      "o" #'consult-outline)

(map! :after vertico
      :map vertico-map
      "C-j" #'vertico-next
      "TAB" #'vertico-insert
      "C-k" #'vertico-previous)

(use-package! affe
  :config
  (defun affe-orderless-regexp-compiler (input _type _ignorecase)
    (setq input (cdr (orderless-compile input)))
    (cons input (apply-partially #'orderless--highlight input t)))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler)
  ;; Manual preview key for `affe-grep'
  (consult-customize affe-grep :preview-key "M-."))
